//
//  Adresse.h
//  BiergartenApp
//
//  Created by Günter Platzer on 17.08.12.
//  Copyright (c) 2012 Günter Platzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Biergarten;

@interface Adresse : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * ort;
@property (nonatomic, retain) NSString * plz;
@property (nonatomic, retain) NSString * strasse;
@property (nonatomic, retain) Biergarten *biergarten;
@end
