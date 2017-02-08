//
//  UIWindow+DLGDebugConsole.h
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
@class DLGDebugConsoleView;
#endif

@interface UIWindow (DLGDebugConsole)

#ifdef DEBUG
- (BOOL)dragging;
- (void)setDragging:(BOOL)dragging;
- (CGPoint)startPosition;
- (void)setStartPosition:(CGPoint)pt;
- (DLGDebugConsoleView *)consoleView;
- (void)setConsoleView:(DLGDebugConsoleView *)view;
- (void)handleGesture:(UIPanGestureRecognizer *)sender;
#endif

@end
