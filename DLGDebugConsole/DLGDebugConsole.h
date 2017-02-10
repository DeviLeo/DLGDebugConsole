//
//  DLGDebugConsole.h
//  DLGDebugConsole
//
//  Created by DeviLeo on 2017/1/14.
//  Copyright © 2017 Liu Junqi. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG

#import "UIWindow+DLGDebugConsole.h"
#import "DLGDebugConsoleAgent.h"

#endif

@interface DLGDebugConsole : NSObject

#ifdef DEBUG

+ (void)addConsoleView;
+ (void)addConsoleViewToWindow:(UIWindow *)window;
+ (void)removeConsoleView;

#endif

@end
