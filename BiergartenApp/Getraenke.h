//
//  Getraenke.h
//  BiergartenApp
//
//  Created by Günter Platzer on 17.08.12.
//  Copyright (c) 2012 Günter Platzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Biergarten;

@interface Getraenke : NSManagedObject

@property (nonatomic, retain) NSString * apfelschorle;
@property (nonatomic, retain) NSString * biermarke;
@property (nonatomic, retain) NSString * mass;
@property (nonatomic, retain) Biergarten *biergarten;

@end
