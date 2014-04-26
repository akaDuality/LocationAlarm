//
//  AnnotationManager.h
//  LocationAlarm
//
//  Created by Рубанов Михаил on 06.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceAnnotation.h"



typedef NSInteger AnnotationIndex;


@protocol AnnotationManagerDelegate <NSObject>

@required

- (void)annotationDidLoad:(NSArray *)annotations;

@end



@interface AnnotationManager : NSObject

@property id <AnnotationManagerDelegate> delegate;

+ (AnnotationManager *)sharedManager;

//+ (NSArray *)loadFromFile;
//+ (void)saveAnnotations:(NSArray *)annotations;
- (void)loadAnnotations;
- (void)saveAnnotations;

- (NSMutableArray *)annotations;

- (void)addAnnotation:(PlaceAnnotation *)newAnnotation;
- (void)removeAnnotation:(PlaceAnnotation *)removableAnnotation;


@end
