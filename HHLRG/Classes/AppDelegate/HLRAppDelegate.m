//
//  AppDelegate.m
//  HHLRG
//
//  Created by Nathan Wood on 12/09/2015.
//  Copyright (c) 2015 Nathan Wood. All rights reserved.
//

#import "HLRAppDelegate.h"
#import "HLRViewController.h"

@interface HLRAppDelegate ()

@end

@implementation HLRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIWindow *window = [[UIWindow alloc] initWithFrame:bounds];
    window.backgroundColor = [UIColor blackColor];
    self.window = window;
    
    window.rootViewController = [[HLRViewController alloc] init];
    
    [window makeKeyAndVisible];
    return YES;
}

@end
