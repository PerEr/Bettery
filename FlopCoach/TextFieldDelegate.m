//
//  TextFieldDelegate.m
//  FlopCoach
//
//  Created by Per Ersson on 2011-12-18.
//  Copyright (c) 2011 itelect AB. All rights reserved.
//

#import "TextFieldDelegate.h"

@implementation TextFieldDelegate 

-(id) initWithCommand: (id<Command>) _command {
    
    if ((self = [super init])) {
        command = [_command retain];
    }
    return self;
}

- (void) dealloc {
    [command release];
    [super dealloc];
}

- (void) controlTextDidChange:(NSNotification *)aNotification {
    [command process];
}

@end
