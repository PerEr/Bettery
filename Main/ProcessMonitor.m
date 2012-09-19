//
//  ProcessMaster.m
//  Bettery
//
//  Created by Per Ersson on 2012-09-12.
//  Copyright (c) 2012 itelect AB. All rights reserved.
//

#import "ProcessMonitor.h"
#import "ProcList.h"


@implementation ProcessMonitor

@synthesize tableRunning, tableManaged;

- (id) init {
    
    if ((self = [super init])) {
        suspendables = [[NSMutableDictionary alloc] init];
        suspended = [[NSMutableDictionary alloc] init];

        [suspendables setObject: [NSArray arrayWithObjects: @"PluginProcess", @"WebProcess", nil] forKey: @"Safari"];
        [suspendables setObject: [NSArray arrayWithObjects: nil] forKey: @"Spotify"];
        [suspendables setObject: [NSArray arrayWithObjects: nil] forKey: @"TextWrangler"];
        [suspendables setObject: [NSArray arrayWithObjects: nil] forKey: @"IntelliJ IDEA"];
        [suspendables setObject: [NSArray arrayWithObjects: nil] forKey: @"AppCode"];
    }
    
    return self;
}

-(void) awakeFromNib {

    [self onProcessListChanged: nil];

    NSNotificationCenter* ns = [[NSWorkspace sharedWorkspace] notificationCenter];
    [ns addObserver:self
           selector:@selector(onProcessActivated:)
               name:NSWorkspaceDidActivateApplicationNotification object:nil];
    
    [ns addObserver:self
           selector:@selector(onProcessDeActivated:)
               name:NSWorkspaceDidDeactivateApplicationNotification object:nil];

    [ns addObserver:self
           selector:@selector(onProcessListChanged:)
               name:NSWorkspaceDidLaunchApplicationNotification object:nil];
    [ns addObserver:self
           selector:@selector(onProcessListChanged:)
               name:NSWorkspaceDidTerminateApplicationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
           selector:@selector(onApplicationQuit:)
               name:NSApplicationWillTerminateNotification object:nil];
}

- (void) killPid: (pid_t) pid withType: (NSString*) type {
    NSTask *task;
    task = [[[NSTask alloc] init] autorelease];
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


- (void) onApplicationQuit: (NSNotification *) note {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    NSLog(@"Resuming suspended apps:");
    for (NSString *s in [suspended allKeys]) {
        NSNumber* pid = [suspended objectForKey: s];
        NSLog(@"  %@ (%@)", s, pid);
        [self resume: [pid unsignedIntValue]];
    }

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
    return [suspendables objectForKey: name];
}

- (void) onProcessActivated: (NSNotification *) note {

    NSRunningApplication* app = [[note userInfo] objectForKey:@"NSWorkspaceApplicationKey"];
    NSString* name = [app localizedName];
    NSLog(@"pop %@\n", name);

    if ([self isSuspendable: name]) {
        pid_t pid = [app processIdentifier];
        NSLog(@"Will resume app %@ (%d)", name, pid);
        [self resume: pid];
        [suspended removeObjectForKey: name];
        NSLog(@"Suspended apps = %lu", [suspended count]);
    }
}


- (void) onProcessDeActivated: (NSNotification *) note {
    NSRunningApplication* app = [[note userInfo] objectForKey:@"NSWorkspaceApplicationKey"];
    NSString* name = [app localizedName];

    NSLog(@"hide %@\n", name);

    if ([self isSuspendable: name]) {
        pid_t pid = [app processIdentifier];
        for (NSString* friend in [suspendables objectForKey: name]) {

        }
        NSLog(@"Will suspend app %@ (%d)", name, pid);
        [self suspend: pid];
        [suspended setValue:  [NSNumber numberWithInt: pid] forKey: name];
        NSLog(@"Suspended %lu", [suspended count]);
    }
}

- (void) onProcessListChanged: (id) obj {
    [apps release];
    apps = [[[NSWorkspace sharedWorkspace] launchedApplications] copy];
    NSArray * procs = [ProcList runningProcesses];
    for (NSDictionary *pp in procs) {

    }
}




@end
