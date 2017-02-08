//
//  DLGDebugConsoleCommands.h
//  DLGDebugConsole
//
//  Created by Liu Junqi on 07/02/2017.
//  Copyright © 2017 DeviLeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG

#import "DLGDebugConsoleCommandHelp.h"
#import "DLGDebugConsoleCommandConsole.h"
#import "DLGDebugConsoleCommandShowFrame.h"

// Import commands' headers here
#import "DLGDebugConsoleCommandNet.h"
#import "DLGDebugConsoleCommandShowUserInfo.h"
#import "DLGDebugConsoleCommandShowServerInfo.h"
#import "DLGDebugConsoleCommandSample.h"

#endif

@interface DLGDebugConsoleCommands : NSObject

#ifdef DEBUG

+ (NSArray *)commandsWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate;

#endif

@end
