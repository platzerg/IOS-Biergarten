//
//  JSMCoreDataHelper.m
//  CoreDataProjekt
//
//  Created by trainer on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSMCoreDataHelper.h"

@implementation JSMCoreDataHelper

+ (NSString*) directoryForDatabaseFilename
{
    return [NSHomeDirectory() stringByAppendingString:@"/Library/Private Documents"];
}

+ (NSString*) databaseFilename
{
    return @"database.sqlite";
}

+ (NSManagedObjectContext*) managedObjectContext
{
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:[JSMCoreDataHelper directoryForDatabaseFilename] withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error) {
        NSLog(@"Fehler: %@", error.localizedDescription);
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [JSMCoreDataHelper directoryForDatabaseFilename],
                      [JSMCoreDataHelper databaseFilename]];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *managedModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedModel];
    
    if (! [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        NSLog(@"Fehler: %@", error.localizedDescription);
        return nil;
    }
    
    NSManagedObjectContext *managedContext = [[NSManagedObjectContext alloc] init];
    managedContext.persistentStoreCoordinator = storeCoordinator;
    
    return managedContext;
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

@end
