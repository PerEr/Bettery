//
//  ProcessMaster.m
//  Bettery
//
//  Created by Per Ersson on 2012-09-12.
//  Copyright (c) 2012 itelect AB. All rights reserved.
//

#import "ProcessMaster.h"

@implementation ProcessMaster

- (void) test {
    //NSLog(@"%@", [[NSWorkspace sharedWorkspace] launchedApplications]);

    NSArray* procs = [[NSWorkspace sharedWorkspace] launchedApplications];
    for (NSDictionary* procInfo in procs) {
        
        NSString* name = [procInfo objectForKey: @"NSApplicationName"];
        NSInteger* pid = [procInfo objectForKey: @"NSApplicationProcessIdentifier"];
        
        NSLog(@"%@ %@", name, pid);
    }
}

@end
