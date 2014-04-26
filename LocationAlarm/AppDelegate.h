//
//  AppDelegate.h
//  LocationAlarm
//
//  Created by Рубанов Михаил on 05.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property MapController *mapViewController;

@end
