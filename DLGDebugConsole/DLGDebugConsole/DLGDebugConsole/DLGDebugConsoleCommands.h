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
#import "DLGDebugConsoleCommandNet.h"
#import "DLGDebugConsoleCommandShowFrame.h"
#import "DLGDebugConsoleCommandShowUserInfo.h"
#import "DLGDebugConsoleCommandShowServerInfo.h"

#endif

@interface DLGDebugConsoleCommands : NSObject

#ifdef DEBUG

+ (NSArray *)commandsWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate;

#endif

@end
