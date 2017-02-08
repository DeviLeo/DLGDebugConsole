//
//  DLGDebugConsoleView.h
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG

#define DLG_DEBUG_CONSOLE_VIEW_SIZE 80

#define DLG_DEBUG_CONSOLE_VIEW_MIN_ALPHA 0.5f
#define DLG_DEBUG_CONSOLE_VIEW_MAX_ALPHA 0.8f

#endif

@interface DLGDebugConsoleView : UIView

#ifdef DEBUG

@property (nonatomic) UIWindow *window;
@property (nonatomic, readonly) BOOL shouldNotBeDragged;
@property (nonatomic, readonly) BOOL expanded;

+ (instancetype)instance;
- (void)doExpand;
- (void)doCollapse;

#endif

@end
