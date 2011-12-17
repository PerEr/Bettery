//
//  OddsLookup.h
//  FlopCoach
//
//  Created by Per Ersson on 2011-12-17.
//  Copyright (c) 2011 itelect AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OddsLookup : NSObject {

    NSMutableDictionary* tableOdds;
}

-(NSArray*) lookupOddsFor: (NSString*) cards withPlayers: (int) players;


@end
