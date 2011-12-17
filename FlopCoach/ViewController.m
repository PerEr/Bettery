//
//  ViewController.m
//  FlopCoach
//
//  Created by Per Ersson on 2011-12-17.
//  Copyright (c) 2011 itelect AB. All rights reserved.
//

#import "ViewController.h"
#import "TextFieldDelegate.h"
#import "SelectorCommand.h"

@implementation ViewController

@synthesize cards, players;
@synthesize expectedValueMin, expectedValueMax;
@synthesize expectedValueMinText, expectedValueMaxText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        oddsLookup = [[OddsLookup alloc] init];
        id<Command> cmd = [SelectorCommand fromObject:self andSelector:@selector(textChanged:) andData: nil];
        textFieldDelegate = [[TextFieldDelegate alloc] initWithCommand: cmd];
        timerTriggeredUpdate = false;
        timer = nil;
    }
    
    return self;
}

-(void) dealloc {
    [oddsLookup release];
    [textFieldDelegate release];
    [super dealloc];
}

- (void) awakeFromNib {
    [self textChanged: nil];
    cards.delegate = textFieldDelegate;
}

-(void)onTimer:(NSTimer *)tt {
    [timer invalidate];
    timer = nil;
    timerTriggeredUpdate = true;
    [cards selectText: cards];
}

-(void) updateEV: (NSLevelIndicator*) expectedValue withValue: (float) ev {
    
    float minValue = [expectedValue minValue];
    float maxValue = [expectedValue maxValue];
    
    float maxOdds = 2.2;
    float minOdds = -maxOdds;
    
    float scaledEv = (ev - minOdds)/(maxOdds-minOdds); // 0..1 of odds range
    scaledEv *= maxValue-minValue;  // Scale to level indicators range
    scaledEv += minValue;           // Translate so that 0 maps to the minimum value
    
    if (ev > 0.1) {
        [expectedValue setCriticalValue: maxValue];
        [expectedValue setWarningValue: maxValue];
    } else if (ev > -0.1) {
        [expectedValue setCriticalValue: maxValue];
        [expectedValue setWarningValue: minValue];
    } else {
        [expectedValue setCriticalValue: minValue];
        [expectedValue setWarningValue: minValue-1];
    }
    
    [expectedValue setFloatValue: scaledEv];
}

- (IBAction) textChanged:(id)controllerId {
    if (timerTriggeredUpdate) {
        timerTriggeredUpdate = false;
        return;
    }
    NSString* cardString = [cards stringValue];
    NSString* playersString = [players objectValue];
    int nrPlayers = [playersString intValue];
    
    NSArray* oddsArray =  [oddsLookup lookupOddsFor:cardString withPlayers:nrPlayers];
    if (oddsArray) {
        expectedValueMin.alphaValue = 1.0;
        expectedValueMax.alphaValue = 1.0;
        expectedValueMinText.alphaValue = 1.0;
        expectedValueMaxText.alphaValue = 1.0;
        
        float evSum = 0.0;
        float evCounter = 0;
        float evMin = 1000;
        float evMax = -1000;
        for (id obj in oddsArray) {
            float value = [obj floatValue];
            if (value > evMax)
                evMax = value;
            if (value < evMin)
                evMin = value;
            evSum += value;
            evCounter += 1.0;
        }
        
        [expectedValueMinText setStringValue: [NSString stringWithFormat: @"%.03f", evMin]];
        [expectedValueMaxText setStringValue: [NSString stringWithFormat: @"%.03f", evMax]];

        [self updateEV: expectedValueMin withValue: evMin];
        [self updateEV: expectedValueMax withValue: evMax];
        
        
        [timer invalidate];
        
        timer = [NSTimer scheduledTimerWithTimeInterval: 1.5
                                                 target: self
                                               selector:@selector(onTimer:)
                                               userInfo: nil repeats:NO];        
    } else {
        expectedValueMin.alphaValue = 0.3;
        expectedValueMax.alphaValue = 0.3;
        expectedValueMinText.alphaValue = 0.3;
        expectedValueMaxText.alphaValue = 0.3;
        [timer invalidate];
        timer = nil;
    }
}

@end
