//
//  PlacesListController.h
//  LocationAlarm
//
//  Created by Рубанов Михаил on 07.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceCell.h"

@interface PlacesListController : UITableViewController <CellActivityDelegate>
    @property NSMutableArray *list;

@end
