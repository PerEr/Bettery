//
//  AppDelegate.m
//  FlopCoach
//
//  Created by Per Ersson on 2011-12-17.
//  Copyright (c) 2011 itelect AB. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc {
    [super dealloc];
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [_window setLevel: NSStatusWindowLevel];
}

@end
