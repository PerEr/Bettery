//
//  ProcessMaster.h
//  Bettery
//
//  Created by Per Ersson on 2012-09-12.
//  Copyright (c) 2012 itelect AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessMaster : NSObject {
    
    IBOutlet NSTableView* table;
    
@private
    NSArray* apps;
}

@property (assign) NSTableView * table;

@end
