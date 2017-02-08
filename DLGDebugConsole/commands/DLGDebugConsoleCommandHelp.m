//
//  DLGDebugConsoleCommandHelp.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleCommandHelp.h"

@implementation DLGDebugConsoleCommandHelp

#ifdef DEBUG

- (id)initWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    
    if (self) {
        [self initCommand];
    }
    
    return self;
}

- (void)initCommand {
    self.name = @"Command Help";
    self.command = @"?";
    self.usage = @"? <command>";
    self.brief = @"Show command help.";
    self.detail = @"Show specified command usage and description.";
    self.example = @"(1) ? ?\n(2) ? usr svr";
}

- (BOOL)execute:(NSArray *)params {
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    NSArray *commands = nil;
    if ([self.delegate respondsToSelector:@selector(getCommands)]) {
        commands = [self.delegate getCommands];
    }
    
    if (commands == nil || commands.count == 0) {
        [ms appendString:@"No commands"];
    } else if (params == nil || params.count == 0) {
        [commands enumerateObjectsUsingBlock:^(DLGDebugConsoleCommand *cmd, NSUInteger idx, BOOL *stop) {
            [ms appendFormat:@"%@ - %@\n", cmd.command, cmd.brief];
        }];
    } else {
        [params enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL *stop) {
            [commands enumerateObjectsUsingBlock:^(DLGDebugConsoleCommand *cmd, NSUInteger idx, BOOL *stop) {
                if ([cmd.command compare:param] == NSOrderedSame) {
                    [ms appendFormat:@"%@\n\n", cmd];
                    *stop = YES;
                }
            }];
        }];
    }
    
    if (ms.length == 0) {
        NSString *usage = [NSString stringWithFormat:@"%@", self];
        if ([self.delegate respondsToSelector:@selector(outputCommandResult:)]) {
            [self.delegate outputCommandResult:usage];
        } else { return NO; }
    } else {
        if ([self.delegate respondsToSelector:@selector(outputCommandResult:)]) {
            [self.delegate outputCommandResult:ms];
        } else { return NO; }
    }
    
    return YES;
}

#endif

@end
