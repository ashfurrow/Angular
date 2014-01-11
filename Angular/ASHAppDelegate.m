//
//  ASHAppDelegate.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHAppDelegate.h"

#import <Crashlytics/Crashlytics.h>

@implementation ASHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Crashlytics startWithAPIKey:@"e92912505e9b6327bad28022d04290c3ddffaa82"];
    self.window.tintColor = [UIColor colorWithHexString:@"FF0062"];
    
    return YES;
}

@end
