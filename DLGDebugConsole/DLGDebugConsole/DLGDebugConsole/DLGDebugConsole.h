//
//  DLGDebugConsole.h
//  DLGDebugConsole
//
//  Created by DeviLeo on 2017/1/14.
//  Copyright © 2017 Liu Junqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIWindow+DLGDebugConsole.h"
#import "DLGDebugConsoleView.h"

@interface DLGDebugConsole : NSObject

+ (void)addConsoleView;
+ (void)addConsoleViewToWindow:(UIWindow *)window;

@end
