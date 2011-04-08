//
//  CrackedScreenViewController.m
//  CrackedScreen
//
//  Created by Heath Borders on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CrackedScreenViewController.h"

@implementation CrackedScreenViewController

- (void)dealloc {
	self.view = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidUnload {
	self.view = nil;
	
	[super viewDidUnload];
}

- (void) viewDidAppear:(BOOL) animated {
	[super viewDidAppear:animated];
	
	[self.view becomeFirstResponder];
}

@end
