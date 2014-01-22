//
//  BiergartenDataHelper.h
//  BiergartenApp
//
//  Created by Günter Platzer on 17.08.12.
//  Copyright (c) 2012 Günter Platzer. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface BiergartenDataHelper : NSObject

+ (BiergartenDataHelper*) sharedInstance;

+ (NSString*) directoryForDatabaseFilename;
+ (NSString*) databaseFilename;

- (NSManagedObjectContext*) managedObjectContext;

+ (id) insertManagedObjectOfClass: (Class) aClass inManagedObjectContext: (NSManagedObjectContext*) managedObjectContext;

+ (BOOL) saveManagedObjectContext: (NSManagedObjectContext*) managedObjectContext;

+ (NSArray*) fetchEntitiesForClass: (Class) aClass withPredicate: (NSPredicate*) predicate inManagesObjectContext: (NSManagedObjectContext*) managedObjectContext;

+ (BOOL) performFetchOnFetchedResultsController: (NSFetchedResultsController*) fetchedResultsController;

@end
