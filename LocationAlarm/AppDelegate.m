//
//  AppDelegate.m
//  LocationAlarm
//
//  Created by Рубанов Михаил on 05.04.14.
//  Copyright (c) 2014 Рубанов Михаил. All rights reserved.
//

#import "AppDelegate.h"
//#import "AnnotationManager.h"

#import "AnnotationManager.h"
#import "PlacesListController.h"



@implementation AppDelegate

    @synthesize mapViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *placesListStoryboadrID    = NSStringFromClass([PlacesListController class]);
    NSString *mapControllerStoryboardID = NSStringFromClass([MapController class]);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
    
    // Formate First Screen
    UINavigationController *navigationController;
    
    AnnotationManager *annotationManager = [AnnotationManager sharedManager];{
        [annotationManager loadAnnotations];
    }
    
    NSArray *savedAnnotations = [annotationManager annotations];
    
    if ([savedAnnotations count] < 2) {
        // Show Map
        mapViewController = [storyboard instantiateViewControllerWithIdentifier:mapControllerStoryboardID];{
            [mapViewController.navigationItem.backBarButtonItem setTitle:@"Map"];
            //        [mapViewController loadFromFile];
        }
        navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    } else {
        // Show List
        PlacesListController *placesListController = [storyboard instantiateViewControllerWithIdentifier:placesListStoryboadrID];{
            [placesListController setList:[savedAnnotations mutableCopy]];
            [placesListController setTitle:@"Select Destination"];
        }
        navigationController = [[UINavigationController alloc] initWithRootViewController:placesListController];
        
    }
    
    
    self.window =[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];{
        [self.window setRootViewController:navigationController];
        [self.window setTintColor:[UIColor colorWithHue:0.3 saturation:1 brightness:0.8 alpha:1]];
        [self.window addSubview:navigationController.view];
        [self.window makeKeyAndVisible];
    }
    // Did You see this comment? :D
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
//    NSLog(@"Annotations in Map %@", mapViewController.mapView.annotations);
    [[AnnotationManager sharedManager] saveAnnotations];
    
    //:mapViewController.mapView.annotations];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    [[AnnotationManager sharedManager] saveToFile];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [[AnnotationManager sharedManager] loadFromFile];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"Local notification recived");
    
    [self showAlarm:notification.alertBody];
}

- (void)showAlarm:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Wake up!"
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
@end
