//
//  DLGDebugConsoleCommandParameter.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleCommandParameter.h"

@implementation DLGDebugConsoleCommandParameter

#ifdef DEBUG

- (id)init {
    self = [super init];
    
    if (self) {
        self.name = nil;
        self.param = nil;
        self.detail = nil;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name andParam:(NSString *)param andDetail:(NSString *)detail {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.param = param;
        self.detail = detail;
    }
    
    return self;
}

#endif

@end
