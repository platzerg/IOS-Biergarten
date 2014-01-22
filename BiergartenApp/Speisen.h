//
//  Speisen.h
//  BiergartenApp
//
//  Created by Günter Platzer on 17.08.12.
//  Copyright (c) 2012 Günter Platzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Biergarten;

@interface Speisen : NSManagedObject

@property (nonatomic, retain) NSString * lieblingsgericht;
@property (nonatomic, retain) NSString * obazda;
@property (nonatomic, retain) NSString * riesenbreze;
@property (nonatomic, retain) NSString * speisenkommentar;
@property (nonatomic, retain) Biergarten *biergarten;

@end
