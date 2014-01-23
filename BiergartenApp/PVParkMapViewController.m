#import "PVParkMapViewController.h"
#import "PVPark.h"
#import "PVParkMapOverlayView.h"
#import "PVParkMapOverlay.h"
#import "PVAttractionAnnotation.h"
#import "PVAttractionAnnotationView.h"
#import "PVCharacter.h"


@interface PVParkMapViewController ()

@property (nonatomic, strong) PVPark *park;

@end

@implementation PVParkMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedOptions = [NSMutableArray array];
    [self.selectedOptions addObject:[NSNumber numberWithInt:2]];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
    
    
    
    
    // define span for map: how much area will be shown
    MKCoordinateSpan span;
    span.latitudeDelta = 0.002;
    span.longitudeDelta = 0.002;
    
    // define starting point for map
    CLLocationCoordinate2D start;
    start.latitude = 48.185977;
    start.longitude = 11.620038;
    
    // create region, consisting of span and location
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
    
    // move the map to our location
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeHybrid;
    
    [self.mapView setRegion:region animated:YES];
    
    PVAttractionAnnotation *annotation = [[PVAttractionAnnotation alloc] init];
    CGPoint point = CGPointFromString(@"{48.185977, 11.620038}");
            
    annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
    annotation.title = @"Aumeister";
    annotation.type = 6;
    annotation.subtitle = @"München";
    
    [self.mapView addAnnotation:annotation];
    
    CLLocationCoordinate2D centerCoord = { 48.185977, 11.620038 };
    self.mapView.zoomEnabled = true;
    self.mapView.centerCoordinate = centerCoord;

    

}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location");
    [manager stopUpdatingLocation];
    
}

- (void)addOverlay {
    PVParkMapOverlay *overlay = [[PVParkMapOverlay alloc] initWithPark:self.park];
    [self.mapView addOverlay:overlay];
}

- (void)addAttractionPins {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MagicMountainAttractions" ofType:@"plist"];
    NSArray *attractions = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *attraction in attractions) {
        PVAttractionAnnotation *annotation = [[PVAttractionAnnotation alloc] init];
        CGPoint point = CGPointFromString(attraction[@"location"]);
        annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        annotation.title = attraction[@"name"];
        annotation.type = [attraction[@"type"] integerValue];
        annotation.subtitle = attraction[@"subtitle"];
        [self.mapView addAnnotation:annotation];
    }
}

- (void)addRoute {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"EntranceToGoliathRoute" ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];
    
    NSInteger pointsCount = pointsArray.count;
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for(int i = 0; i < pointsCount; i++) {
        CGPoint p = CGPointFromString(pointsArray[i]);
        pointsToUse[i] = CLLocationCoordinate2DMake(p.x,p.y);
    }
    
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    
    [self.mapView addOverlay:myPolyline];
}

- (void)addBoundary {
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:self.park.boundary
                                                     count:self.park.boundaryPointsCount];
    [self.mapView addOverlay:polygon];
}

- (void)addCharacterLocation {
    NSString *batmanFilePath = [[NSBundle mainBundle] pathForResource:@"BatmanLocations" ofType:@"plist"];
    NSArray *batmanLocations = [NSArray arrayWithContentsOfFile:batmanFilePath];
    CGPoint batmanPoint = CGPointFromString(batmanLocations[rand()%4]);
    PVCharacter *batman = (PVCharacter *)[PVCharacter circleWithCenterCoordinate:CLLocationCoordinate2DMake(batmanPoint.x, batmanPoint.y)
                                                                          radius:MAX(5, rand()%40)];
    batman.color = [UIColor blueColor];
    
    NSString *tazFilePath = [[NSBundle mainBundle] pathForResource:@"TazLocations" ofType:@"plist"];
    NSArray *tazLocations = [NSArray arrayWithContentsOfFile:tazFilePath];
    CGPoint tazPoint = CGPointFromString(tazLocations[rand()%4]);
    PVCharacter *taz = (PVCharacter *)[PVCharacter circleWithCenterCoordinate:CLLocationCoordinate2DMake(tazPoint.x, tazPoint.y)
                                                                       radius:MAX(5, rand()%40)];
    taz.color = [UIColor orangeColor];
    
    NSString *tweetyFilePath = [[NSBundle mainBundle] pathForResource:@"TweetyBirdLocations" ofType:@"plist"];
    NSArray *tweetyLocations = [NSArray arrayWithContentsOfFile:tweetyFilePath];
    CGPoint tweetyPoint = CGPointFromString(tweetyLocations[rand()%4]);
    PVCharacter *tweety = (PVCharacter *)[PVCharacter circleWithCenterCoordinate:CLLocationCoordinate2DMake(tweetyPoint.x, tweetyPoint.y)
                                                                          radius:MAX(5, rand()%40)];
    tweety.color = [UIColor yellowColor];
    
    [self.mapView addOverlay:batman];
    [self.mapView addOverlay:taz];
    [self.mapView addOverlay:tweety];
}


- (void)loadSelectedOptions {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    for (NSNumber *option in self.selectedOptions) {
        switch ([option integerValue]) {
            case PVMapOverlay:
                [self addOverlay];
                break;
            case PVMapPins:
                [self addAttractionPins];
                break;
            case PVMapRoute:
                [self addRoute];
                break;
            case PVMapBoundary:
                [self addBoundary];
                break;
            case PVMapCharacterLocation:
                [self addCharacterLocation];
                break;
            default:
                break;
        }
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:PVParkMapOverlay.class]) {
        UIImage *magicMountainImage = [UIImage imageNamed:@"overlay_park"];
        PVParkMapOverlayView *overlayView = [[PVParkMapOverlayView alloc] initWithOverlay:overlay overlayImage:magicMountainImage];
        
        return overlayView;
    } else if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineView *lineView = [[MKPolylineView alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor greenColor];
        
        return lineView;
    } else if ([overlay isKindOfClass:MKPolygon.class]) {
        MKPolygonView *polygonView = [[MKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor magentaColor];
        
        return polygonView;
    } else if ([overlay isKindOfClass:PVCharacter.class]) {
        MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        circleView.strokeColor = [(PVCharacter *)overlay color];
        
        return circleView;
    }
    
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    PVAttractionAnnotationView *annotationView = [[PVAttractionAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Attraction"];
    annotationView.canShowCallout = YES;
    return annotationView;
}


- (IBAction)mapTypeChanged:(id)sender {
    switch (self.mapTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}
@end
