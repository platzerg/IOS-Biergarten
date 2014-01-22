//
//  JSMCoreDataHelper.h
//  CoreDataProjekt
//
//  Created by trainer on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface JSMCoreDataHelper : NSObject

+ (NSString*) directoryForDatabaseFilename;
+ (NSString*) databaseFilename;

+ (NSManagedObjectContext*) managedObjectContext;

+ (id) insertManagedObjectOfClass: (Class) aClass inManagedObjectContext: (NSManagedObjectContext*) managedObjectContext;

+ (BOOL) saveManagedObjectContext: (NSManagedObjectContext*) managedObjectContext;

+ (NSArray*) fetchEntitiesForClass: (Class) aClass withPredicate: (NSPredicate*) predicate inManagesObjectContext: (NSManagedObjectContext*) managedObjectContext;

@end
