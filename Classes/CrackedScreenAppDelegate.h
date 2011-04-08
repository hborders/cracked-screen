//
//  CrackedScreenAppDelegate.h
//  CrackedScreen
//
//  Created by Heath Borders on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CrackedScreenViewController;

@interface CrackedScreenAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CrackedScreenViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CrackedScreenViewController *viewController;

@end

