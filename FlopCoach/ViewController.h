//
//  ViewController.h
//  FlopCoach
//
//  Created by Per Ersson on 2011-12-17.
//  Copyright (c) 2011 itelect AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OddsLookup.h"
#import "TextFieldDelegate.h"

@interface ViewController : NSViewController {
    
    IBOutlet NSComboBox* players;
    IBOutlet NSTextField* cards;
    IBOutlet NSLevelIndicator* expectedValueMin;
    IBOutlet NSLevelIndicator* expectedValueMax;
    IBOutlet NSTextField* expectedValueMinText;
    IBOutlet NSTextField* expectedValueMaxText;
    
    OddsLookup* oddsLookup;
    TextFieldDelegate* textFieldDelegate;
    NSTimer* timer;
    bool timerTriggeredUpdate;
}

-(void)onTimer:(NSTimer *)timer;

- (IBAction) textChanged:(id)controllerId;

@property (nonatomic, retain) IBOutlet NSComboBox* players;
@property (nonatomic, retain) IBOutlet NSTextField* cards;
@property (nonatomic, retain) IBOutlet NSLevelIndicator* expectedValueMin;
@property (nonatomic, retain) IBOutlet NSLevelIndicator* expectedValueMax;
@property (nonatomic, retain) IBOutlet NSTextField* expectedValueMinText;
@property (nonatomic, retain) IBOutlet NSTextField* expectedValueMaxText;

@end
