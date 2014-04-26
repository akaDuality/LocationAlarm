//
//  LocationManager.m
//  LocationAlarm
//
//  Created by Рубанов Михаил on 24.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import "LocationNotifier.h"

@implementation LocationNotifier

static LocationNotifier *sharedLocationManager;
static CLLocationManager *locationManager;

// Constatnts
const NSTimeInterval deffaultFireInterval = 5;//sec



#pragma mark Public
+ (LocationNotifier *)sharedNotifier{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[LocationNotifier alloc] init];
        
        locationManager = [[CLLocationManager alloc] init];{
            [locationManager setDelegate:sharedLocationManager];
            [locationManager setDistanceFilter:kCLDistanceFilterNone];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        }
    });
    return sharedLocationManager;
}



#pragma mark Notification
- (void)notificateWhenAchieveAnnotation:(PlaceAnnotation *)annotation{
    CLCircularRegion *targetRegion = [[CLCircularRegion alloc] initWithCenter:annotation.coordinate
                                                                       radius:annotation.radius
                                                                   identifier:annotation.title];
    [locationManager startMonitoringForRegion:targetRegion];
}
- (void)removeNotificationForAnnotation:(PlaceAnnotation *)annotation{
    CLCircularRegion *targetRegion = [[CLCircularRegion alloc] initWithCenter:annotation.coordinate
                                                                       radius:annotation.radius
                                                                   identifier:annotation.title];
    [locationManager stopMonitoringForRegion:targetRegion];

    
}

- (void)removeAllNotificationDetection{
    for (CLCircularRegion *region in locationManager.monitoredRegions) {
        [locationManager stopMonitoringForRegion:region];
    }
}


#pragma mark CLLocationManager Delegate
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    [[UIApplication sharedApplication] scheduleLocalNotification:[self alarmNotification]];
}



#pragma mark - Notifiactions
- (UILocalNotification *)alarmNotification{
//    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:deffaultFireInterval];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];{
        [notification setFireDate:nil];
        [notification setTimeZone:[NSTimeZone systemTimeZone]];
        
        notification.alertAction    = @"Show";
        notification.alertBody      = @"You arrived to location";
        notification.soundName      = UILocalNotificationDefaultSoundName;
    }
    
    return notification;
}
@end
