//
//  AnnotationManager.m
//  LocationAlarm
//
//  Created by Рубанов Михаил on 06.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import "AnnotationManager.h"
#import "PlaceAnnotation.h"


@interface AnnotationManager ()
//    @property (nonatomic)
@end




@implementation AnnotationManager

    @synthesize delegate;

    static AnnotationManager *annotationManager;
    NSMutableArray *annotations;
    NSString *annotationKey = @"Annotations";


#pragma mark - Singleton
+ (AnnotationManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        annotationManager = [[AnnotationManager alloc] init];
//        [annotationManager loadFromFile];
        annotations = [[NSMutableArray alloc] init];
    });
    
    return annotationManager;
}



#pragma mark - File Managment

- (void)loadAnnotations{
    annotations = [self loadFromFile];
    NSLog(@"Load annotations %@", annotations);
}
- (void)saveAnnotations{

    [self saveAnnotations:annotations];
}


- (NSMutableArray *)loadFromFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath    = [paths objectAtIndex:0];
    NSString *filePath                  = [documentsDirectoryPath stringByAppendingPathComponent:annotationKey];
    
    NSMutableArray *loadedAnnotations = [NSMutableArray array];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData          *data               = [NSData dataWithContentsOfFile:filePath];
        NSDictionary    *loadedDictionary   = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([loadedDictionary objectForKey:annotationKey] != nil) {
            loadedAnnotations = [loadedDictionary objectForKey:annotationKey];
            
            
            
            //return loadedAnnotations;
        }
    }
    return loadedAnnotations;
}

- (void)saveAnnotations:(NSArray *)annotations{
    if ([annotations count] == 0) {
        return;
    }
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
//    if ([annotations count] > 1) {// ignore user location Annotation
    
        // Ignore Useless Annotation
//        NSMutableArray *placeAnnotations = [[NSMutableArray alloc] init];
//        for (id <MKAnnotation> annotation in annotations) {
//            if ([annotation isKindOfClass:[PlaceAnnotation class]]) {
//                NSLog(@"add");
//                [placeAnnotations addObject:annotation];
//            }
//            
//        }
        [dataDict setObject:annotations forKey:annotationKey];
        
        // Save data
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:annotationKey];
    
        [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
//    }
}



#pragma mark - Other
- (NSMutableArray *)annotations{
    return annotations;
}

- (void)addAnnotation:(PlaceAnnotation *)newAnnotation{
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), newAnnotation);
    [annotations addObject:newAnnotation];
    NSLog(@"Result annotations are %@", annotations);
    
}

- (void)removeAnnotation:(PlaceAnnotation *)removableAnnotation;{
    NSLog(@"remove annotation %@", removableAnnotation);
    [annotations removeObject:removableAnnotation];
    NSLog(@"Result annotations are %@", annotations);
}
@end
