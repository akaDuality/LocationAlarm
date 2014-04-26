//
//  PlacesListController.m
//  LocationAlarm
//
//  Created by Рубанов Михаил on 07.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import "PlacesListController.h"
#import "PlaceAnnotation.h"

#import "MapController.h"
#import "PlacesDetailController.h"
#import "AnnotationManager.h"
#import "LocationNotifier.h"

@interface PlacesListController ()

@end




@implementation PlacesListController{
    uint selectedAccessoryRow;
}

    @synthesize list;




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
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *newLocationButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain
                                                                         target:self action:@selector(showMap)];{
        [newLocationButton setTitle:@"Map"];
        [self.navigationItem setRightBarButtonItem:newLocationButton];
    }

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];{
        [refresh addTarget:self
                    action:@selector(refreshTable:)
          forControlEvents:UIControlEventValueChanged];
        
        NSString *title = @"Swipe Down to Delete All Notifications";
        [refresh setAttributedTitle:[[NSAttributedString alloc] initWithString:title]];
    }
    self.refreshControl = refresh;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
- (void)refreshTable:(UIRefreshControl *)sender{
    [[LocationNotifier sharedNotifier] removeAllNotificationDetection];
    [sender endRefreshing];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    PlaceAnnotation *annotation = list [section];
    
    if (annotation.locationEnabled) {
        return 2;
    }
    return 1;
}

#pragma mark Metricks
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) { return 28; }
    
    NSString *subtitle = ((PlaceAnnotation *)list[indexPath.row]).subtitle;
    if ([subtitle isEqualToString:@""]) {
        return 40;
    } else {
        return 60;
    }
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}*/
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];{
//        [view setBackgroundColor:[UIColor whiteColor]];
//    }
//    return view;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];{
//        [view setBackgroundColor:[UIColor whiteColor]];
//    }
//    return view;
//}



#pragma mark Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID;
    switch (indexPath.row) {
        case 0:
            ID = @"Cell";
            break;
        case 1:
            ID = @"ButtonCell";
            break;
        default:
            break;
    }
    PlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    if (indexPath.row == 0 && cell) {
        PlaceAnnotation *annotation = [list objectAtIndex:indexPath.section];
        [cell setAnnotation:annotation];
        [cell setDelegate:self];
        
        [cell setEditingAccessoryType:UITableViewCellAccessoryDetailButton];
    }
    
    return cell;
}



#pragma mark Editing Setup
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUInteger      annotationIndex = [indexPath section];
        PlaceAnnotation *annotation = list[annotationIndex];
        
        [[AnnotationManager sharedManager] removeAnnotation:annotation];
        [list removeObjectAtIndex:annotationIndex];
        
        [tableView beginUpdates];{
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:annotationIndex] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView deleteRowsAtIndexPaths:@[indexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
        }
        [tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



#pragma mark TableView Actions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlaceAnnotation *selectedAnnotation = list[indexPath.section];
    [self showMapAndSelectAnnotation:selectedAnnotation];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self showDetailedForLocation:list[indexPath.section]];
}



#pragma mark - Cell Activity Delegate

- (void)cell:(PlaceCell *)cell didChangeActivityToState:(BOOL)activityState{
    NSIndexPath *cellIndexPath  = [self.tableView indexPathForCell:cell];
    NSInteger   sectionIndex    = cellIndexPath.section;
    
    [self.tableView beginUpdates];{
        if (activityState) {
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:sectionIndex]]
                                                    withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:sectionIndex]]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
    } [self.tableView endUpdates];
}



#pragma mark - Private
- (void)showMap{
    [self showMapAndSelectAnnotation:nil];
}

- (void)showMapAndSelectAnnotation:(PlaceAnnotation *)annotation{
    NSString *mapID = NSStringFromClass([MapController class]);
    MapController *mapController = [self.storyboard instantiateViewControllerWithIdentifier:mapID];{
        [mapController setCurrentAnnotation:annotation];
    }
    
//    [mapController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    [self presentViewController:mapController animated:YES completion:nil];
    [self.navigationController pushViewController:mapController animated:YES];
}

- (void)showDetailedForLocation:(PlaceAnnotation *)annotation{
    NSString *detailID = NSStringFromClass([PlacesDetailController class]);
    PlacesDetailController *detailController = [self.storyboard instantiateViewControllerWithIdentifier:detailID];{
        [detailController setCurrentAnnotation:annotation];
    }
    [self.navigationController pushViewController:detailController animated:YES];
}
@end
