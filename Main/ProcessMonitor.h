//
//  ProcessMaster.h
//  Bettery
//
//  Created by Per Ersson on 2012-09-12.
//  Copyright (c) 2012 itelect AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessMonitor : NSObject {
    
    IBOutlet NSTableView* tableRunning;
    IBOutlet NSTableView* tableManaged;
    
@private
    NSArray* apps;
    NSMutableDictionary* suspendables; // main name -> {process name}+
    NSMutableDictionary* suspended;    // Set of suspended apps
    
}

@property (assign) NSTableView * tableRunning;
@property (assign) NSTableView * tableManaged;

@end
