//
//  Command.h
//  Spello
//
//  Created by Per on 2011-03-04.
//

#import <Cocoa/Cocoa.h>


@protocol Command<NSObject>

-(void) process;

@end
