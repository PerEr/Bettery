//
//  TextFieldDelegate.h
//  FlopCoach
//
//  Created by Per Ersson on 2011-12-18.
//  Copyright (c) 2011 itelect AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface TextFieldDelegate : NSObject<NSTextFieldDelegate> {
    
    id<Command> command;
}

- (id) initWithCommand: (id) _command;
- (void) dealloc;

- (void) controlTextDidChange:(NSNotification *)aNotification;

@end
