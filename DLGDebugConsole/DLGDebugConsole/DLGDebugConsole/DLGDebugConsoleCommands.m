//
//  DLGDebugConsoleCommands.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 07/02/2017.
//  Copyright © 2017 DeviLeo. All rights reserved.
//

#import "DLGDebugConsoleCommands.h"

@implementation DLGDebugConsoleCommands

#ifdef DEBUG

+ (NSArray *)commandsWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate {
    NSArray *commands = @[
                          [[DLGDebugConsoleCommandHelp alloc] initWithDelegate:delegate],
                          [[DLGDebugConsoleCommandConsoleButton alloc] initWithDelegate:delegate],
                          [[DLGDebugConsoleCommandNet alloc] initWithDelegate:delegate],
                          [[DLGDebugConsoleCommandShowFrame alloc] initWithDelegate:delegate],
                          [[DLGDebugConsoleCommandShowUserInfo alloc] initWithDelegate:delegate],
                          [[DLGDebugConsoleCommandShowServerInfo alloc] initWithDelegate:delegate]
                          ];
    return commands;
}

#endif

@end
