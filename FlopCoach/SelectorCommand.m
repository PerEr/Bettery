//
//  SelectorCommand.m
//  Spello
//
//  Created by Per on 2011-03-04.
//

#import "SelectorCommand.h"

static int s_index = 0;

@implementation SelectorCommand
 
-(id) initWithObject: (id) obj andSelector: (SEL) sel andData: (id) arg {
    if((self=[super init])) {
        object = obj;
        selector = sel;
        argument = arg;
        nr = s_index++;
    }
    return self;
}

- (void) dealloc {
    --s_index;
    [super dealloc];
}

-(void) process {
    if (argument == nil)
        [object performSelector: selector];
    else 
        [object performSelector: selector withObject: argument];
}

+(id<Command>) fromObject: (id) obj andSelector: (SEL) sel {
    return [SelectorCommand fromObject: obj andSelector: sel andData: nil];
}

+(id<Command>) fromObject: (id) obj andSelector: (SEL) sel andData: (id) arg {
    return [[[SelectorCommand alloc] initWithObject: obj andSelector: sel andData: arg] autorelease];
}

@end
