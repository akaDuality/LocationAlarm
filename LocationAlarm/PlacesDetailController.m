//
//  PlacesDetailController.m
//  LocationAlarm
//
//  Created by Рубанов Михаил on 05.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import "PlacesDetailController.h"
#import "MapController.h"
#import "PlaceAnnotation.h"
#import "AnnotationManager.h"



@interface PlacesDetailController ()
    @property BOOL customDistance;


@end




@implementation PlacesDetailController
    @synthesize nameField;
    @synthesize currentAnnotation;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    self.customDistance = NO;
    
    self.nameField.delegate = self;
    [self.nameField addTarget:self action:@selector(finishedEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (![currentAnnotation.title isEqualToString:@"New Location"]) {
        [self.nameField setText:currentAnnotation.title];
    }
    [self.subTitleLabel setText:currentAnnotation.subtitle];
//    else {
//        [self.nameField becomeFirstResponder];
//    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:backButton];
    

//    [self.navigationItem.backBarButtonItem setTitle:@"Map"];
//    NSLog(@"%@", [self.navigationItem.backBarButtonItem title]);
    
//    PlaceAnnotation *currentAnnotation = [[[AnnotationManager sharedManager] annotations] objectAtIndex:currentAnnotationIndex];
    if ([self.nameField.text isEqualToString:@""]) {
        [self.nameField becomeFirstResponder];
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self saveDataToAnnotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            if (self.customDistance) {
                return 2;
            } else {
                return 1;
            }
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:2]]) {
        // Delete
        [[AnnotationManager sharedManager] removeAnnotation:self.currentAnnotation];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IBOutlet
- (IBAction)distanceSegmentedChanged:(UISegmentedControl *)sender
{
    BOOL previousState = self.customDistance;
    
    if (sender.selectedSegmentIndex == 3){
        self.customDistance = YES;
    } else {
        self.customDistance = NO;
    }

    // if Needs changes
    if (self.customDistance != previousState) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView beginUpdates];{
            if (self.customDistance){
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        [self.tableView endUpdates];
    }
    
    // Save changes
    [self saveDataToAnnotation];
    
}
- (IBAction)everytimeSwichChanged:(UISwitch *)sender {
}



#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (void)finishedEditing:(UITextField *)sender{
    [sender resignFirstResponder];

    [self saveDataToAnnotation];
}

- (void)saveDataToAnnotation{
//    AnnotationManager *annotationManager = [AnnotationManager sharedManager];
    
    
//    PlaceAnnotation *annotation = [[annotationManager annotations] objectAtIndex:currentAnnotationIndex];
//    //[self.mapController.mapView.selectedAnnotations firstObject];
//    
    [currentAnnotation setTitle:self.nameField.text];
    NSInteger radius = [self distanceRadius];
    [currentAnnotation setRadius:radius];
    
    
//    [[[AnnotationManager sharedManager] annotations] replaceObjectAtIndex:currentAnnotationIndex withObject:annotation];//addAnnotation:annotation];
    

}


#pragma mark - Private
#warning remove duplicated method
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
@end
