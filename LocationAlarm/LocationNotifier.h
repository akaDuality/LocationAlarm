//
//  LocationManager.h
//  LocationAlarm
//
//  Created by Рубанов Михаил on 24.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

#import "PlaceAnnotation.h"

@interface LocationNotifier : NSObject <CLLocationManagerDelegate>

    + (LocationNotifier *)sharedNotifier;

    - (void)notificateWhenAchieveAnnotation:(PlaceAnnotation *)annotation;

    - (void)removeNotificationForAnnotation:(PlaceAnnotation *)annotation;
    - (void)removeAllNotificationDetection;

@end
