//
//  BiergartenDataHelper.m
//  BiergartenApp
//
//  Created by Günter Platzer on 17.08.12.
//  Copyright (c) 2012 Günter Platzer. All rights reserved.
//

#import "BiergartenDataHelper.h"
#import "Constants.h"

@interface BiergartenDataHelper ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation BiergartenDataHelper

@synthesize managedObjectContext = _managedObjectContext;

+ (BiergartenDataHelper*) sharedInstance
{
    static BiergartenDataHelper *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (NSString*) directoryForDatabaseFilename
{
    return [NSHomeDirectory() stringByAppendingString:@"/Library/Private Documents"];
}

+ (NSString*) databaseFilename
{
    return @"biergarten.sqlite";
}


- (NSManagedObjectContext*) managedObjectContext
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:[BiergartenDataHelper directoryForDatabaseFilename] withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error) {
        NSLog(@"Fehler: %@", error.localizedDescription);
        return nil;
    }
    
    NSManagedObjectModel *managedModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedModel];
    
    NSString *storePath = [NSString stringWithFormat:@"%@/%@", [BiergartenDataHelper directoryForDatabaseFilename],
                           [BiergartenDataHelper databaseFilename]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        NSURL *ubiqURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        NSString *cloudPath = [[ubiqURL path] stringByAppendingPathComponent:@"inventar_data"];
        NSURL *transactionLogsURL = [NSURL fileURLWithPath:cloudPath];
        
        NSDictionary *options =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"de.jsmarts.Inventar.OrteUndDinge", NSPersistentStoreUbiquitousContentNameKey,
         transactionLogsURL, NSPersistentStoreUbiquitousContentURLKey,
         [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
         nil];
        
        NSError *persistentStoreError;
        [storeCoordinator lock];
        if (! [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&persistentStoreError]) {
            NSLog(@"Fehler: %@, %@", persistentStoreError.localizedDescription, persistentStoreError.userInfo);
            abort();
        }
        [storeCoordinator unlock];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:cNotificationPersistentStoreAdded object:self];
        });
    });
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext performBlockAndWait:^{
        [_managedObjectContext setPersistentStoreCoordinator:storeCoordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeiCloud:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:storeCoordinator];
    }];
    
    return _managedObjectContext;
}

-(void) mergeiCloud: (NSNotification*) notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSManagedObjectContext *managedObjectContext = [[BiergartenDataHelper sharedInstance] managedObjectContext];
    [managedObjectContext performBlock:^{
        [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}

+ (id) insertManagedObjectOfClass: (Class) aClass inManagedObjectContext: (NSManagedObjectContext*) managedObjectContext
{
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass (aClass) inManagedObjectContext:managedObjectContext];
    return managedObject;
}

+ (BOOL) saveManagedObjectContext: (NSManagedObjectContext*) managedObjectContext
{
    NSError *error;
    if (! [managedObjectContext save:&error] ) {
        NSLog(@"Fehler: %@", error.localizedDescription);
        return NO;
    }
    return YES;
}

+ (NSArray*) fetchEntitiesForClass: (Class) aClass withPredicate: (NSPredicate*) predicate inManagesObjectContext: (NSManagedObjectContext*) managedObjectContext
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(aClass) inManagedObjectContext:managedObjectContext];
    fetchRequest.entity = entityDescription;
    fetchRequest.predicate = predicate;
    
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Fehler: %@", error.localizedDescription);
        return nil;
    }
    return items;
}

+ (BOOL) performFetchOnFetchedResultsController: (NSFetchedResultsController*) fetchedResultsController
{
    NSError *error;
    if (! [fetchedResultsController performFetch:&error] ) {
        NSLog(@"Fehler: %@", error.localizedDescription);
        return NO;
    }
    return YES;
}


@end
