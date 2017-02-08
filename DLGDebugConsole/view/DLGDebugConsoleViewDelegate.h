//
//  DLGDebugConsoleViewDelegate.h
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLGDebugConsoleViewDelegate <NSObject>

#ifdef DEBUG

- (void)log:(NSString *)log;
- (void)outputCommand:(NSString *)command;
- (void)outputCommandResult:(NSString *)result;

- (CGRect)collapsedFrame;
- (CGRect)expandedFrame;
- (void)setCollapsedFrame:(CGRect)frame;
- (void)setExpandedFrame:(CGRect)frame;
- (void)hideConsoleButtonForSeconds:(CGFloat)seconds;
- (void)clearLogs;

- (NSArray *)getCommands;

#endif

@end
