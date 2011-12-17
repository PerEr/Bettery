//
//  OddsLookup.m
//  FlopCoach
//
//  Created by Per Ersson on 2011-12-17.
//  Copyright (c) 2011 itelect AB. All rights reserved.
//

#import "OddsLookup.h"

@implementation OddsLookup

-(NSDictionary*) loadOddsFrom: (NSString*) key {
    
    //stores the path of the plist file present in the bundle
    NSString *path = [[NSBundle mainBundle]pathForResource: key ofType:@"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

    return dict;
}

-(id) init {
    if ((self = [super init])) {
        tableOdds = [[NSMutableDictionary alloc] init];
        for (int ii = 2; ii<= 10 ; ++ii) {
            NSString* key = [NSString stringWithFormat: @"%d", ii];
            NSDictionary* odds = [self loadOddsFrom: key];
            [tableOdds setValue: odds forKey: key];
        }
    }
    return self;
}

-(void) dealloc {
    [tableOdds release];
    [super dealloc];
}

-(NSArray*) lookupOddsFor: (NSString*) cards withPlayers: (int) players {

    NSString* cardKey1 = nil;
    NSString* cardKey2 = nil;
    
    if ([cards length] == 2) {
        char c1 = toupper([cards characterAtIndex:0]);
        char c2 = toupper([cards characterAtIndex:1]);
        cardKey1 = [NSString stringWithFormat:@"%c%c", c1, c2];
        cardKey2 = [NSString stringWithFormat:@"%c%c", c2, c1];
    } else if ([cards length] == 3) {
        char c1 = toupper([cards characterAtIndex:0]);
        char c2 = toupper([cards characterAtIndex:1]);
        char c3 = tolower([cards characterAtIndex:2]);

        cardKey1 = [NSString stringWithFormat:@"%c%c%c", c1, c2, c3];
        cardKey2 = [NSString stringWithFormat:@"%c%c%c", c2, c1, c3];
    }
    if (cardKey1 != nil) {
        NSString* tableKey = [NSString stringWithFormat: @"%d", players];
        NSDictionary* dict = [tableOdds objectForKey: tableKey];
        NSArray* data = [dict objectForKey: cardKey1];
        if (data == nil)
            data = [dict objectForKey: cardKey2];
        return data;
    }
    return nil;
}

@end
