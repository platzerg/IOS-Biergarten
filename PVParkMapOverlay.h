#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class PVPark;

@interface PVParkMapOverlay : NSObject <MKOverlay>

- (instancetype)initWithPark:(PVPark *)park;

@end
