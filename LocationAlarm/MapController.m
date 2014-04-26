//
//  ViewController.m
//  LocationAlarm
//
//  Created by Рубанов Михаил on 05.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import "MapController.h"
@import CoreLocation;
#import "PlaceAnnotation.h"
#import "PlacesDetailController.h"
#import "AnnotationManager.h"
#import <MapKit/MKUserTrackingBarButtonItem.h>

//#import "MKCircle_LocationEnabled.h"
//#import "ToggleCircle.h"
#import "MKCircle+locationEnabled.h"
#import "LocationNotifier.h"

@interface MapController ()


@end



@implementation MapController

@synthesize mapView;
    CLLocationDistance  userRegionDistance          = 1000;
    CLLocationDistance  deffaultRadius              = 300;

    float               toolbarAnimationDuration    = 0.3;
    bool                locating                    = NO;

    NSString            *PlaceAnnotationID          = @"PlaceAnnotation";
    NSString            *startTitle                 = @"Start";
    NSString            *stopTitle                  = @"Stop";


    CGAffineTransform   toolbarTranslation;

    BOOL needsUserLocationUpdate;


#pragma mark View Cycle Managment

- (void)viewDidLoad
{
    [super viewDidLoad];
//    annotationManager = [AnnotationManager sharedManager];
//    [annotationManager setDelegate:self];
    
    [self setupMap];
    
    
    // Add User Tracking Button
    [self.navigationItem setRightBarButtonItem:[[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    toolbarTranslation = CGAffineTransformMakeTranslation(0, self.toolbar.bounds.size.height * 2);

    NSLog(@"Curent location is %@", self.currentAnnotation);
    if (self.currentAnnotation) {
        [self.mapView selectAnnotation:self.currentAnnotation animated:YES];
        [self zoomToAnnotation:self.currentAnnotation];
    } else {
        // Schedule Zooming to User Location
//        [self zoomToCoordinate:self.mapView.userLocation.coordinate];
        needsUserLocationUpdate = YES;
        [self hideToolbar];
    }
    
#warning update toolbar position
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    
//    
//    
//}



- (void)redrawSelectedAnnotation{
    if ([[self.mapView selectedAnnotations] count] != 0) {
        id <MKAnnotation> annotation = [[self.mapView selectedAnnotations] firstObject];
        [self hideAllCircles];
        [self showCircleForAnnotation:(PlaceAnnotation *)annotation];

    }
}



#pragma mark - Delegates
#pragma mark Map Kit Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        if (needsUserLocationUpdate) {
            needsUserLocationUpdate = NO;
            [self zoomToCoordinate:userLocation.coordinate];
        }
        
//    });
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *newAnnotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:PlaceAnnotationID];
    
    if (!newAnnotationView) {
        newAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PlaceAnnotationID];{
            newAnnotationView.pinColor          = MKPinAnnotationColorPurple;
            newAnnotationView.animatesDrop      = YES;
            newAnnotationView.canShowCallout    = YES;
            newAnnotationView.draggable         = YES;
            
            [newAnnotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
        }
    }

    return newAnnotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if([view.annotation isKindOfClass:[MKUserLocation class]])
        // Ignore user location
        return;
    
    if ([view.annotation isKindOfClass:[PlaceAnnotation class]])
    {
        [self showToolbar];
        
        PlaceAnnotation * annotation = (PlaceAnnotation *)view.annotation;
        NSLog(@"Annotation subtitle is %@", annotation.subtitle);
//        [self showCircleForAnnotation:annotation];
        
        [annotation addObserver:self forKeyPath:@"radius" options:0 context:NULL];
    }
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    if([view.annotation isKindOfClass:[MKUserLocation class]])
        // Ignore user location
        return;
    
    [self hideToolbar];
    
    PlaceAnnotation * annotation = (PlaceAnnotation *)view.annotation;
    [annotation removeObserver:self forKeyPath:@"radius"];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [self showDetatilForAnnotation:(PlaceAnnotation *)view.annotation];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];{
        [circleView setLineWidth:2];

//)]) {
            MKCircle *circleOverlay = (MKCircle *)overlay;
            if (circleOverlay.locationEnabled) {
                [circleView setStrokeColor:[UIColor greenColor]];
                [circleView setFillColor:[UIColor colorWithHue:0.3 saturation:1 brightness:1 alpha:0.2]];
            } else {
                [circleView setStrokeColor:[UIColor lightGrayColor]];
                [circleView setFillColor:[UIColor colorWithHue:0 saturation:0 brightness:0.5 alpha:0.2]];
            }
//        }
        


    }
    return circleView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
                                didChangeDragState:(MKAnnotationViewDragState)newState
                                      fromOldState:(MKAnnotationViewDragState)oldState{
    
#warning do not hide/show all circles
    switch (newState) {
        case MKAnnotationViewDragStateStarting:
            [self hideAllCircles];
            break;
        case MKAnnotationViewDragStateEnding:
            [self showAllCircles];
            [self updateGeocoderInformation:(PlaceAnnotation *)view.annotation];
            break;
        default:
            NSLog(@"other annotation drag state is %d", newState);
            break;
    }
}







#pragma mark AnotationManagerDelegate
-(void)annotationDidLoad:(NSArray *)annotations{
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self.mapView addAnnotations:annotations];
}



#pragma mark - Private

- (void)setupMap{
    
    // Zoom ro current location
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setShowsPointsOfInterest:NO];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                      action:@selector(longPressRecognized:)];
    [self.mapView addGestureRecognizer:longPressRecognizer];
    
    [self.mapView addAnnotations:[AnnotationManager sharedManager].annotations];
    
    [self showAllCircles];
}

- (void)zoomToAnnotation:(id<MKAnnotation>)annotation{
    [self zoomToCoordinate:annotation.coordinate];
}

- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate,
                                                                   userRegionDistance, userRegionDistance);
    [self.mapView setRegion:region animated:NO];
}

- (void)addPlace:(CLLocationCoordinate2D)location{
    PlaceAnnotation *newPlaceAnnotation = [[PlaceAnnotation alloc] initWithCoodinate:location
                                                                               title:@"New Location"];
        [newPlaceAnnotation setRadius:deffaultRadius];
        [self.mapView addAnnotation:newPlaceAnnotation];
        [self.mapView selectAnnotation:newPlaceAnnotation animated:YES];
    
    [self updateGeocoderInformation:newPlaceAnnotation];
    
    [[AnnotationManager sharedManager] addAnnotation:newPlaceAnnotation];
}

- (void)updateGeocoderInformation:(PlaceAnnotation *)placeAnnotation{
    CLLocationCoordinate2D coordinate = placeAnnotation.coordinate;
    CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                        longitude:coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:clLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       CLPlacemark *placemark = [placemarks firstObject];
                       
                       NSString *locatedAt = [[NSString alloc] init] ;
                       if (placemark.thoroughfare) {
                           locatedAt = [locatedAt stringByAppendingString:placemark.thoroughfare];
                       }
                       if (placemark.subThoroughfare) {
                           locatedAt = [locatedAt stringByAppendingFormat:@" %@", placemark.subThoroughfare];
                       }
                       placeAnnotation.subtitle = locatedAt;
                   }];
}

- (void)showDetatilForAnnotation:(PlaceAnnotation *)annotation{
    NSString *detatilControllerID = NSStringFromClass([PlacesDetailController class]);
    PlacesDetailController *detailController = [self.storyboard instantiateViewControllerWithIdentifier:detatilControllerID];{

        [detailController setCurrentAnnotation:annotation];
        detailController.mapController = self;
    }
    
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)modifyAnnotation:(PlaceAnnotation *)annotation{
    [annotation setTitle:@"lol"];
}



#pragma mark Toolbar Visibility
- (void)showToolbar{
    [UIView animateWithDuration:toolbarAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                            self.toolbar.center = CGPointMake(self.toolbar.center.x,
                                                              self.toolbar.center.y - 88);
//                         [self.toolbar setTransform:CGAffineTransformIdentity];
                     } completion:nil];
    
}

- (void)hideToolbar{
    [UIView animateWithDuration:toolbarAnimationDuration
                          delay:0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
//                         [self.toolbar setTransform:toolbarTranslation];//CGAffineTransformMakeTranslation(0, 44)];
                         self.toolbar.center = CGPointMake(self.toolbar.center.x,
                                                           self.toolbar.center.y + 88);
                     } completion:nil];
    
    
}



#pragma mark Circle Drawing
- (void)showCircleForAnnotation:(PlaceAnnotation *)annotation{
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:annotation.coordinate
                                                             radius:annotation.radius];
    [circle setLocationEnabled:annotation.locationEnabled];
    [self.mapView addOverlay:circle];
}

- (void)hideCircleForAnnotation:(PlaceAnnotation *)annotation{
#warning dummy method
}

- (void)showAllCircles{
    for (PlaceAnnotation *annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[PlaceAnnotation class]]) {
            [self showCircleForAnnotation:annotation];
        }
    }
}
- (void)hideAllCircles{
    [self.mapView removeOverlays:self.mapView.overlays];
}



#pragma mark - Gesture Recognizer
- (void)longPressRecognized:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        // Get Map Coordinate
        CGPoint     mapCoordinate                 = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchPlaceLocation   = [self.mapView convertPoint:mapCoordinate toCoordinateFromView:self.mapView];

        
        // Add Pin
        [self addPlace:touchPlaceLocation];
    }
    
}



#pragma mark - IBOutlets

- (IBAction)startButtonPressed:(UIBarButtonItem *)sender {
    LocationNotifier *locationNotifier = [LocationNotifier sharedNotifier];
    PlaceAnnotation  *targetAnnotation = [[self.mapView selectedAnnotations] firstObject];
    
    if ([sender.title isEqualToString:startTitle]) {
        [sender setTitle:stopTitle];
        [sender setStyle:UIBarButtonItemStyleDone];
        [self.distanceSegmented setEnabled:NO];
        
        [locationNotifier notificateWhenAchieveAnnotation:targetAnnotation];
    } else {
        [sender setTitle:startTitle];
        [sender setStyle:UIBarButtonItemStyleBordered];
        [self.distanceSegmented setEnabled:YES];
        
        [locationNotifier removeNotificationForAnnotation:targetAnnotation];
    }
    
}

- (IBAction)distanceChanged:(UISegmentedControl *)sender {
    
    PlaceAnnotation *annotation = (PlaceAnnotation *)[[self.mapView selectedAnnotations] firstObject];
    [annotation setRadius:[self distanceRadius]];
    
//    [self redrawSelectedAnnotation];
}

// FIXME: remove duplicated method
- (CLLocationDistance)distanceRadius{
    switch ([self.distanceSegmented selectedSegmentIndex]) {
        case 0:
            return 300;
        case 1:
            return 1000;
        case 2:
            return 5000;
        case 3:
            return 50;
            
        default:
            return 0;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"radius changed to %d", [[object valueForKey:keyPath] integerValue]);
    [self redrawSelectedAnnotation];
}
@end

