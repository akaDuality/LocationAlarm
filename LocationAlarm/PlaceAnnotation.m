//
//  PlaceAnnotation.m
//  LocationAlarm
//
//  Created by Рубанов Михаил on 05.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import "PlaceAnnotation.h"



@implementation PlaceAnnotation
//@synthesize coordinate;
@synthesize radius,
            locationEnabled;


NSString *longtitudeKey = @"longtitude";
NSString *latitudeKey   = @"latitude";
NSString *titleKey      = @"title";
NSString *subtitleKey   = @"subtitle";
NSString *radiusKey     = @"radius";





-(id<MKAnnotation>)initWithCoodinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title      = title;
        _subtitle   = subtitle;
    }
    return self;
}

- (id<MKAnnotation>)initWithCoodinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title{
    return [self  initWithCoodinate:coordinate title:title subtitle:nil];
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    _coordinate = newCoordinate;
}
- (void)setTitle:(NSString *)title{
    _title = title;
}
- (void)setSubtitle:(NSString *)subtitle{
    _subtitle = subtitle;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    [aCoder encodeDouble:_coordinate.longitude  forKey:longtitudeKey];
    [aCoder encodeDouble:_coordinate.latitude   forKey:latitudeKey];
    
    [aCoder encodeObject:_title                 forKey:titleKey];
    [aCoder encodeObject:_subtitle              forKey:subtitleKey];
    [aCoder encodeDouble:radius                 forKey:radiusKey];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    CLLocationDegrees       longtitude = [aDecoder decodeDoubleForKey:longtitudeKey];
    CLLocationDegrees       latitude   = [aDecoder decodeDoubleForKey:latitudeKey];
    CLLocationCoordinate2D  coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
    
    NSString *title             = [aDecoder decodeObjectForKey:titleKey];
    NSString *subtitle          = [aDecoder decodeObjectForKey:subtitleKey];
    CLLocationDistance newRadius   = [aDecoder decodeDoubleForKey:radiusKey];
    
    
    PlaceAnnotation *annotation = [[PlaceAnnotation alloc] initWithCoodinate:coordinate title:title subtitle:subtitle];
    [annotation setRadius:newRadius];
    
    return annotation;
}

- (NSString *)description{
    NSString *title = [NSString stringWithUTF8String:self.title.UTF8String];
    
    return [NSString stringWithFormat:@"%@ with radius %f, %@", title, self.radius, self.locationEnabled? @"YES": @"NO"];
    
}
@end
