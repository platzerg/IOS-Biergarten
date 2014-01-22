//
//  Biergarten.h
//  BiergartenApp
//
//  Created by Günter Platzer on 17.08.12.
//  Copyright (c) 2012 Günter Platzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Adresse, Getraenke, Speisen;

@interface Biergarten : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * desclong;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * favorit;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * telefon;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Adresse *adresse;
@property (nonatomic, retain) Getraenke *getraenke;
@property (nonatomic, retain) Speisen *speisen;
@end
