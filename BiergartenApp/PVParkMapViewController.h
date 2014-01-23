#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, PVMapOption ) {
    PVMapBoundary = 0,
    PVMapOverlay,
    PVMapPins,
    PVMapCharacterLocation,
    PVMapRoute
};

@interface PVParkMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectedOptions;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)mapTypeChanged:(id)sender;

@end
