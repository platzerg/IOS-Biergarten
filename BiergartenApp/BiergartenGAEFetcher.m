//
//  BiergartenGAEFetcher.m
//  BiergartenApp
//
//  Created by Günter Platzer on 17.08.12.
//  Copyright (c) 2012 Günter Platzer. All rights reserved.
//

#import "BiergartenGAEFetcher.h"
#import "BiergartenDataHelper.h"
#import "Biergarten.h"
#import "Adresse.h"
#import "Getraenke.h"
#import "Speisen.h"
#import "JSMCoreDataHelper.h"
#import "Constants.h"

#define kBiergartenURL [NSURL URLWithString: @"http://beergardenservice.appspot.com/platzerworld/biergarten/holebiergarten"] //
#define kBiergartenQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1


@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end


@implementation BiergartenGAEFetcher

- (void) loadBiergaerten
{
    
    dispatch_async(kBiergartenQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: kBiergartenURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:kNilOptions
                                                           error:&error];
    
    
    NSManagedObjectContext *context1 = [JSMCoreDataHelper managedObjectContext];

    
    NSArray* latestLoans = [json objectForKey:cAttributeBiergartenliste]; //2
    
    NSLog(@"Biergaerten: %@", latestLoans); //3
    
    
    for (int i = 0; i < [latestLoans count]; i++) {
        // 1) Get the latest loan
        NSDictionary* loan = [latestLoans objectAtIndex:i];
        NSLog(@"Biergaerten: %@", loan); //3
        
        NSString* biergartenId = [loan objectForKey:cAttributeId];
        NSString* name = [loan objectForKey:cAttributeName];
        NSString* strasse = [loan objectForKey:cAttributeStrasse];
        NSString* plz = [loan objectForKey:cAttributePlz];
        NSString* ort = [loan objectForKey:cAttributeOrt];
        NSString* telefon = [loan objectForKey:cAttributeTelefon];
        NSString* email = [loan objectForKey:cAttributeEmail];
        NSString* url = [loan objectForKey:cAttributeUrl];
        NSString* latitude = [loan objectForKey:cAttributeLatitude];
        NSString* longitude = [loan objectForKey:cAttributeLongitude];
        NSString* desc = [loan objectForKey:cAttributeDesc];
        NSString* desclong = [loan objectForKey:cAttributeDesclong];
        NSString* mass = [loan objectForKey:cAttributeMass];
        NSString* apfelschorle = [loan objectForKey:cAttributeApfelschorle];
        NSString* riesenbreze = [loan objectForKey:cAttributeRiesenbreze];
        NSString* obazda = [loan objectForKey:cAttributeObazda];
        NSString* biermarke = [loan objectForKey:cAttributeBiermarke];
        NSString* lieblingsgericht = [loan objectForKey:cAttributeLieblingsgericht];
        NSString* speisenkommentar = [loan objectForKey:cAttributeSpeisenkommentar];
        NSString* favorit = [loan objectForKey:cAttributeFavorit];
        
        Biergarten *biergarten = [JSMCoreDataHelper insertManagedObjectOfClass:[Biergarten class] inManagedObjectContext:context1];
    
        biergarten.id =  [NSNumber numberWithInt:[biergartenId integerValue]];
        biergarten.name = name;
        biergarten.telefon = telefon;
        biergarten.email = email;
        biergarten.url = url;
        biergarten.desc = desc;
        biergarten.desclong = desclong;
        biergarten.favorit = 0;
        
        
        
        Adresse *adresse = [BiergartenDataHelper insertManagedObjectOfClass:[Adresse class ]inManagedObjectContext:context1];
        adresse.strasse = strasse;
        adresse.plz = plz;
        adresse.ort = ort;
        adresse.latitude =   [NSNumber numberWithFloat:[[latitude stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue]];
        adresse.longitude =  [NSNumber numberWithFloat:[[longitude stringByReplacingOccurrencesOfString:@"," withString:@"."]  floatValue]];
        NSLog(@"Adresse: %@", adresse);
        
        Getraenke *getraenke = [BiergartenDataHelper insertManagedObjectOfClass:[Getraenke class ]inManagedObjectContext:context1];
        getraenke.biermarke = biermarke;
        getraenke.mass = mass;
        getraenke.apfelschorle = apfelschorle;
        
        Speisen *speisen = [BiergartenDataHelper insertManagedObjectOfClass:[Speisen class ]inManagedObjectContext:context1];
        speisen.lieblingsgericht = lieblingsgericht;
        speisen.riesenbreze = riesenbreze;
        speisen.obazda = obazda;
        speisen.speisenkommentar = speisenkommentar;
        
        biergarten.adresse = adresse;
        biergarten.speisen = speisen;
        biergarten.getraenke = getraenke;
        
        [JSMCoreDataHelper saveManagedObjectContext:context1];
    }
       
    
    

    
    /*    
    // 3) Set the label appropriately
    NSString *str1 = [NSString stringWithFormat:@"Name: %@ PLZ: %@ Strasse: %@ ",
                         name,
                         plz,
                         strasse
                         ];
    NSLog(@"Biergaerten String 1: %@", str1);
    
    //build an info object and convert to json
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          [loan objectForKey:cAttributeName], cAttributeName,
                          [loan objectForKey:cAttributeStrasse], cAttributeStrasse,
                          [loan objectForKey:cAttributeDesc], cAttributeDesc,
                          nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    //print out the data contents
    NSString *str2 = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"Biergaerten String 2: %@", str2);
    
    */
    // Override point for customization after application launch.
        
    
    
   
    
    NSArray *items = [JSMCoreDataHelper fetchEntitiesForClass:[Biergarten class] withPredicate:nil inManagesObjectContext:context1];
    
    for (Biergarten *biergarten in items) {
        NSLog(@"Biergarten mit Namen %@ und adresse %@ Biermarke %@ und Speise %@ gefunden",
              biergarten.name, biergarten.adresse.strasse, biergarten.getraenke.biermarke, biergarten.speisen.lieblingsgericht);
    }

    
    // [self storeData];
}

- (void) storeData
{
    // Override point for customization after application launch.
    
    Biergarten *biergarten = [BiergartenDataHelper insertManagedObjectOfClass:[Biergarten class ]inManagedObjectContext:
                              [[BiergartenDataHelper sharedInstance]managedObjectContext]];
    biergarten.name = @"Aumeister";
    
    Adresse *adresse = [BiergartenDataHelper insertManagedObjectOfClass:[Adresse class ]inManagedObjectContext:
                        [[BiergartenDataHelper sharedInstance]managedObjectContext]];
    adresse.strasse = @"Aumeisterweg 3";
    
    Getraenke *getraenke = [BiergartenDataHelper insertManagedObjectOfClass:[Getraenke class ]inManagedObjectContext:
                            [[BiergartenDataHelper sharedInstance]managedObjectContext]];
    getraenke.biermarke = @"Hofbräu";
    
    Speisen *speisen = [BiergartenDataHelper insertManagedObjectOfClass:[Speisen class ]inManagedObjectContext:
                        [[BiergartenDataHelper sharedInstance]managedObjectContext]];
    speisen.lieblingsgericht = @"Steckerl-Fisch";
    
    biergarten.adresse = adresse;
    biergarten.speisen = speisen;
    biergarten.getraenke = getraenke;
    
    [BiergartenDataHelper saveManagedObjectContext:
     [[BiergartenDataHelper sharedInstance]managedObjectContext]];
    
    /*
     Person *person = [JSMCoreDataHelper insertManagedObjectOfClass:[Person class] inManagedObjectContext:context];
     person.name = @"Frank Jüstel 2";
     
     Postanschrift *postanschrift = [JSMCoreDataHelper insertManagedObjectOfClass:[Postanschrift class] inManagedObjectContext:context];
     postanschrift.adresse = @"Am Pfahlgraben 20, 61239 Ober-Mören";
     
     person.postanschrift = postanschrift;
     
     [JSMCoreDataHelper saveManagedObjectContext:context];
     */
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", @"a"];
    
    NSArray *items = [BiergartenDataHelper fetchEntitiesForClass:[Biergarten class] withPredicate:predicate inManagesObjectContext:
                      [[BiergartenDataHelper sharedInstance]managedObjectContext]];
    
    for (Biergarten *biergarten in items) {
        NSLog(@"Biergarten mit Namen %@ und adresse %@ gefunden", biergarten.name, biergarten.desclong);
    }

}


@end
