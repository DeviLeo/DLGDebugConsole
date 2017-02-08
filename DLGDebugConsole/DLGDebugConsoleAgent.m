//
//  DLGDebugConsoleAgent.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleAgent.h"

#ifdef DEBUG

// import headers here

// define here

#endif

@implementation DLGDebugConsoleAgent

#ifdef DEBUG

+ (instancetype)instance
{
    static DLGDebugConsoleAgent *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DLGDebugConsoleAgent alloc] init];
    });
    return _instance;
}

#pragma mark - Show Frame Command's Methods
- (CGRect)getCurrentViewFrame {
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *top = root;
    while (top.presentedViewController) top = top.presentedViewController;
    return top.view.frame;
}

- (CGRect)getStatusBarFrame {
    UIApplication *app = [UIApplication sharedApplication];
    return app.statusBarFrame;
}

- (CGRect)getNavigationBarFrame {
    CGRect frame = CGRectZero;
    UIApplication *app = [UIApplication sharedApplication];
    UIViewController *root = app.keyWindow.rootViewController;
    if ([root isKindOfClass:[UINavigationController class]]) {
        frame = ((UINavigationController *)root).navigationBar.frame;
    }
    return frame;
}

- (CGRect)getTabBarFrame {
    CGRect frame = CGRectZero;
    UIApplication *app = [UIApplication sharedApplication];
    UIViewController *root = app.keyWindow.rootViewController;
    if ([root isKindOfClass:[UITabBarController class]]) {
        frame = ((UITabBarController *)root).tabBar.frame;
    }
    return frame;
}

// Other commands' methods here
#pragma mark -

#endif

@end
