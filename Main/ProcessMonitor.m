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
    }
    
    return self;
}


-(void) dealloc {
    
    [suspendables release];
    [suspended release];
    
    [super dealloc];
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
           selector:@selector(onNewAppLaunched:)
               name:NSWorkspaceDidLaunchApplicationNotification object:nil];
    [ns addObserver:self
           selector:@selector(onAppStopped:)
               name:NSWorkspaceDidTerminateApplicationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
           selector:@selector(onApplicationQuit:)
               name:NSApplicationWillTerminateNotification object:nil];
    
    [tableRunning setTarget:self];
    [tableRunning setDoubleAction:@selector(onSelectedToSuspendRow:)];

    [tableManaged setTarget:self];
    [tableManaged setDoubleAction:@selector(onSelectedToReleaseRow:)];
}

- (void) suspend: (pid_t) pid {
    killpg(pid, SIGSTOP);
}

- (void) resume: (pid_t) pid {
    killpg(pid, SIGCONT);
}


- (void) onApplicationQuit: (NSNotification *) note {
    
    NSNotificationCenter* ns = [[NSWorkspace sharedWorkspace] notificationCenter];
    [ns removeObserver: self];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver: self];
    
    NSLog(@"Resuming suspended apps:");
    for (NSString *s in [suspended allKeys]) {
        NSNumber* pid = [suspended objectForKey: s];
        NSLog(@"  %@ (%@)", s, pid);
        [self resume: [pid unsignedIntValue]];
    }

}

- (int) numberOfRowsInTableView:( NSTableView*) tableView {
    return (int) ((tableView == tableRunning) ? [apps count] : [suspendables count]);
}

- (id)tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn*) tableColumn
            row:(int)row {
    
    if (tableView == tableRunning) {
        NSDictionary* procInfo = [apps objectAtIndex: row];

        NSString* name = [procInfo objectForKey: @"NSApplicationName"];
        //NSInteger* pid = (NSInteger*) [procInfo objectForKey: @"NSApplicationProcessIdentifier"];

        return name;
    } else {
        int count = 0;
        for (NSString* key in [suspendables keyEnumerator]) {
            if (count == row)
                return key;
            ++count;
        }
        return @"?";  // Should never happen
    }
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
        NSLog(@"Suspended apps = %ld", [suspended count]);
    }
}

- (void) onNewAppLaunched: (NSNotification *) note {
    
    [self onProcessListChanged: nil];
    [self onProcessActivated: note];
    
}

- (void) onAppStopped: (NSNotification *) note {
    
    [self onProcessListChanged: nil];
    [self onProcessDeActivated: note];
    
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
        NSString* name = [pp objectForKey: @"pname"];
        pid_t pid = (pid_t) [[pp objectForKey:@"pid"] intValue];
        if ([self isSuspendable: name]) {
            NSLog(@"Will suspend app %@ (%u)", name, pid);
            [self suspend: pid];
            [suspended setObject:[NSNumber numberWithUnsignedInt: pid] forKey:name];
        } else if ([suspended objectForKey:name]) {
            NSLog(@"Will resume app %@ (%u)", name, pid);
            [self resume: pid];
            [suspended removeObjectForKey: name];
        }

    }
    [tableRunning reloadData];
}


- (void) onSelectedToSuspendRow: (NSTableView*) tableView {
    NSInteger row = [tableView selectedRow];
    
    NSDictionary* procInfo = [apps objectAtIndex: row];
        
    NSString* name = [procInfo objectForKey: @"NSApplicationName"];
    NSLog(@"Selected %@", name);
    
    [suspendables setObject: [NSArray arrayWithObjects: nil] forKey: name];
    
    [tableManaged reloadData];
    
    [self onProcessListChanged: nil];
}

- (void) onSelectedToReleaseRow: (NSTableView*) tableView {
    NSInteger row = [tableView selectedRow];
    
    int count = 0;
    for (NSString* key in [suspendables keyEnumerator]) {
        if (count == row) {
            [suspendables removeObjectForKey: key];
            break;
        }
        ++count;
    }
    [tableManaged reloadData];    
    [self onProcessListChanged: nil];
}




@end
