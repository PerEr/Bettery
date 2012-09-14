//
//  ProcessMaster.m
//  Bettery
//
//  Created by Per Ersson on 2012-09-12.
//  Copyright (c) 2012 itelect AB. All rights reserved.
//

#import "ProcessMonitor.h"

@implementation ProcessMonitor

@synthesize tableRunning, tableManaged;

- (id) init {
    
    if ((self = [super init])) {
        apps = [[[NSWorkspace sharedWorkspace] launchedApplications] copy];
    }
    
    return self;
}

-(void) awakeFromNib {

    NSNotificationCenter* ns = [[NSWorkspace sharedWorkspace] notificationCenter];
    [ns addObserver:self
           selector:@selector(onProcessActivated:)
               name:NSWorkspaceDidActivateApplicationNotification object:nil];
    
    [ns addObserver:self
           selector:@selector(onProcessDeActivated:)
               name:NSWorkspaceDidDeactivateApplicationNotification object:nil];
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [apps release];
    [super dealloc];
}

- (int) numberOfRowsInTableView:( NSTableView*) tableView {
    return (int) ((tableView == tableRunning) ? [apps count] : 0);
}

- (id)tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn*) tableColumn row:(int)row {
    
    if (tableView == tableRunning) {
        NSDictionary* procInfo = [apps objectAtIndex: row];

        NSString* name = [procInfo objectForKey: @"NSApplicationName"];
        //NSInteger* pid = (NSInteger*) [procInfo objectForKey: @"NSApplicationProcessIdentifier"];

        return name;
    }
    return @"";
}


- (bool) isSuspendable: (NSString*) name {
    return [name compare:@"Spotify"] == 0;
}

- (void) killPid: (pid_t) pid withType: (NSString*) type {
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/kill"];
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: type, [NSString stringWithFormat:@"%d", pid], nil];
    [task setArguments: arguments];
    
    [task launch];
}

- (void) suspend: (pid_t) pid {
    [self killPid: pid withType: @"-STOP"];
}

- (void) resume: (pid_t) pid {
    [self killPid: pid withType: @"-CONT"];
}

- (void) onProcessActivated: (NSNotification *) note {

    NSRunningApplication* app = [[note userInfo] objectForKey:@"NSWorkspaceApplicationKey"];
    NSString* name = [app localizedName];
    NSLog(@"pop %@\n", name);

    if ([self isSuspendable: name]) {
        pid_t pid = [app processIdentifier];
        NSLog(@"Will resume app %@ (%d)", name, pid);
        [self resume: pid];
    }
}


- (void) onProcessDeActivated: (NSNotification *) note {
    NSRunningApplication* app = [[note userInfo] objectForKey:@"NSWorkspaceApplicationKey"];
    NSString* name = [app localizedName];

    NSLog(@"hide %@\n", name);

    if ([self isSuspendable: name]) {
        pid_t pid = [app processIdentifier];
        NSLog(@"Will suspend app %@ (%d)", name, pid);
        [self suspend: pid];
    }
}


@end