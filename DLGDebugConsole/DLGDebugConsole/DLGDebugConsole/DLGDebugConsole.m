//
//  DLGDebugConsole.m
//  DLGDebugConsole
//
//  Created by DeviLeo on 2017/1/14.
//  Copyright © 2017 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsole.h"
#import "DLGDebugConsoleView.h"

@implementation DLGDebugConsole

+ (void)addConsoleView {
    UIApplication *application = [UIApplication sharedApplication];
    [DLGDebugConsole addConsoleViewToWindow:application.keyWindow];
}

+ (void)addConsoleViewToWindow:(UIWindow *)window {
    CGRect frame = CGRectMake(0, 100, DLG_DEBUG_CONSOLE_VIEW_SIZE, DLG_DEBUG_CONSOLE_VIEW_SIZE);
    DLGDebugConsoleView *consoleView = [DLGDebugConsoleView instance];
    consoleView.translatesAutoresizingMaskIntoConstraints = YES;
    consoleView.autoresizingMask = UIViewAutoresizingNone;
    consoleView.frame = frame;
    consoleView.alpha = 0.5f;
    [window addSubview:consoleView];
    window.consoleView = consoleView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:window action:@selector(handleGesture:)];
    [consoleView addGestureRecognizer:pan];
    
    // Init DebugAgent
    [DLGDebugConsoleAgent instance];
}

+ (void)removeConsoleView {
    DLGDebugConsoleView *consoleView = [DLGDebugConsoleView instance];
    if (consoleView.expanded) [consoleView doCollapse];
    NSArray *gestures = consoleView.gestureRecognizers;
    for (UIGestureRecognizer *gesture in gestures) {
        [consoleView removeGestureRecognizer:gesture];
    }
    [consoleView removeFromSuperview];
}

@end
