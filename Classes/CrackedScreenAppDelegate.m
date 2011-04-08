//
//  CrackedScreenAppDelegate.m
//  CrackedScreen
//
//  Created by Heath Borders on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CrackedScreenAppDelegate.h"
#import "CrackedScreenViewController.h"

@implementation CrackedScreenAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [application setStatusBarHidden:YES];

    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
