//
//  ViewController.h
//  LocationAlarm
//
//  Created by Рубанов Михаил on 05.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
//#import "AnnotationManager.h"
#import "PlaceAnnotation.h"

@interface MapController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic)   IBOutlet MKMapView *mapView;
@property (strong, nonatomic) PlaceAnnotation* currentAnnotation;


    @property (weak, nonatomic)     IBOutlet UIToolbar *toolbar;
    @property (strong, nonatomic) IBOutlet UISegmentedControl *distanceSegmented;
    - (IBAction)distanceChanged:(UISegmentedControl *)sender;

    @property (strong, nonatomic) IBOutlet UIBarButtonItem *startButton;
    - (IBAction)startButtonPressed:(UIBarButtonItem *)sender;



//- (void)saveToFile;
//- (void)loadFromFile;

@end
