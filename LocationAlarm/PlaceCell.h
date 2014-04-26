//
//  PlaceCell.h
//  LocationAlarm
//
//  Created by Рубанов Михаил on 07.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceAnnotation.h"

@class PlaceCell;



@protocol CellActivityDelegate <NSObject>

    @required
    - (void)cell:(PlaceCell *)cell didChangeActivityToState:(BOOL)activityState;

@end


@interface PlaceCell : UITableViewCell

    @property (weak) id <CellActivityDelegate> delegate;

    @property (nonatomic, strong) PlaceAnnotation *annotation;
    @property (strong, nonatomic) IBOutlet UIButton *radiusLabel;
    @property (strong, nonatomic) IBOutlet UILabel *titleLabel;
    @property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;

    @property (strong, nonatomic) IBOutlet UISwitch *switcher;
    - (IBAction)switcherChanged:(UISwitch *)sender;

@end
