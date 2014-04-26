//
//  PlaceAnnotation.h
//  LocationAlarm
//
//  Created by Рубанов Михаил on 05.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>


@interface PlaceAnnotation : NSObject <MKAnnotation, NSCoding>

    @property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

    @property (nonatomic, readonly, copy)   NSString            *title;
    @property (nonatomic, readonly, copy)   NSString            *subtitle;
    @property (nonatomic)                   CLLocationDistance  radius;
    @property (nonatomic, readwrite)        BOOL                locationEnabled;


- (id<MKAnnotation>)initWithCoodinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle;
- (id<MKAnnotation>)initWithCoodinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;

- (NSString *)description;
@end

