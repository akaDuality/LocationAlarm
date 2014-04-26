//
//  MKCircle+locationEnabled.m
//  LocationAlarm
//
//  Created by Рубанов Михаил on 24.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import "MKCircle+locationEnabled.h"
#import <objc/runtime.h>

@implementation MKCircle (locationEnabled)

static char const * const ObjectTagKey = "ObjectTag";

- (BOOL)locationEnabled
{
    
    return [objc_getAssociatedObject(self, &ObjectTagKey) boolValue];
}

- (void)setLocationEnabled:(BOOL)locationEnabled{
    NSNumber *number = [NSNumber numberWithBool: locationEnabled];
    objc_setAssociatedObject(self, &ObjectTagKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

@end
