//
//  SelectorCommand.h
//  Spello
//
//  Created by Per on 2011-03-04.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface SelectorCommand : NSObject<Command> {

    SEL selector;
    id object;
    id argument;
    int nr;
}

// Command protocol
-(void) process;
-(void) dealloc;

+(id<Command>) fromObject: (id) obj andSelector: (SEL) sel;
+(id<Command>) fromObject: (id) obj andSelector: (SEL) sel andData: (id) arg;

@end
