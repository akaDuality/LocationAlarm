//
//  PlacesDetailController.h
//  LocationAlarm
//
//  Created by Рубанов Михаил on 05.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MapKit/MKAnnotation.h>
#import "PlaceAnnotation.h"
#import "MapController.h"

@interface PlacesDetailController : UITableViewController <UITextFieldDelegate>

    @property PlaceAnnotation       *currentAnnotation;
//    @property AnnotationIndex       currentAnnotationIndex;
    @property (weak) MapController  *mapController;


    @property (strong, nonatomic) IBOutlet UITextField *nameField;
    @property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;

    @property (strong, nonatomic) IBOutlet UISegmentedControl *distanceSegmented;
    @property (strong, nonatomic) IBOutlet UITextField *distanceField;
    - (IBAction)distanceSegmentedChanged:(UISegmentedControl *)sender;

    @property (strong, nonatomic) IBOutlet UISwitch *everytimeSwitch;
    - (IBAction)everytimeSwichChanged:(UISwitch *)sender;


//    - (void)setManagmentAnnotation:(id<MKAnnotation>)annotation;
@end
