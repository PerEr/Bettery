//
//  ProcessMaster.m
//  Bettery
//
//  Created by Per Ersson on 2012-09-12.
//  Copyright (c) 2012 itelect AB. All rights reserved.
//

#import "ProcessMaster.h"

@implementation ProcessMaster

@synthesize table;

- (id) init {
    
    if ((self = [super init])) {
        apps = [[[NSWorkspace sharedWorkspace] launchedApplications] copy];
    }
    
    return self;
}

-(void) awakeFromNib {
    [table reloadData];
}

- (void) dealloc {
    [apps release];
    [super dealloc];
}

- (int) numberOfRowsInTableView:( NSTableView*) tableView {
    return (int) [apps count] ;
}

- (id)tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn*) tableColumn row:(int)row {
    
    NSDictionary* procInfo = [apps objectAtIndex: row];

    NSString* name = [procInfo objectForKey: @"NSApplicationName"];
    //NSInteger* pid = (NSInteger*) [procInfo objectForKey: @"NSApplicationProcessIdentifier"];

    return name;
}

@end
