//
//  PlaceCell.m
//  LocationAlarm
//
//  Created by Рубанов Михаил on 07.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import "PlaceCell.h"
#import "LocationNotifier.h"


@implementation PlaceCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Public

- (void)setAnnotation:(PlaceAnnotation *)annotation{
    _annotation = annotation;
    [self.radiusLabel   setTitle:[NSString stringWithFormat:@"%.0f m", annotation.radius]
                        forState:UIControlStateNormal];
    
    [self.titleLabel    setText:annotation.title];
    [self.subtitleLabel setText:annotation.subtitle];
    [self.switcher      setOn:annotation.locationEnabled];
}


#pragma mark - Private
- (IBAction)switcherChanged:(UISwitch *)sender {
    LocationNotifier *locationNotifier = [LocationNotifier sharedNotifier];
    if (sender.isOn) {
        [locationNotifier notificateWhenAchieveAnnotation:self.annotation];
    } else {
        [locationNotifier removeNotificationForAnnotation:self.annotation];
    }
    [self.annotation setLocationEnabled:sender.isOn];
    
    [self.delegate cell:self didChangeActivityToState:sender.isOn];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.switcher setAlpha:!editing];
                     }];
    
    
    [super setEditing:editing animated:animated];
    
}
@end
