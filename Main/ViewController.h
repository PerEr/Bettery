//
//  ViewController.h
//  FlopCoach
//
//  Created by Per Ersson on 2011-12-17.
//  Copyright (c) 2011 itelect AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController {
 
    IBOutlet NSTableView* apps;
}

@property(retain) IBOutlet NSTableView* apps;

@end
