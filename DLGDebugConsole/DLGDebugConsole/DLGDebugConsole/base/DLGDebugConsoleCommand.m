//
//  DLGDebugConsoleCommand.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleCommand.h"

@implementation DLGDebugConsoleCommand

#ifdef DEBUG

- (id)initWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (NSString *)description {
    NSString *s = [NSString stringWithFormat:@"Name: %@\nCommand: %@\nUsage: %@\nBrief: %@\nDetail:\n%@\n\nExample:\n\n%@",
                   self.name, self.command, self.usage, self.brief, self.detail, self.example];
    return s;
}

- (BOOL)execute:(NSArray *)params {
    return NO;
}

#endif

@end
