//
//  DLGDebugConsoleAgent.h
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLGDebugConsoleAgent : NSObject

#ifdef DEBUG

+ (instancetype)instance;

#pragma mark - Show Frame Command's Methods
- (CGRect)getStatusBarFrame;
- (CGRect)getNavigationBarFrame;
- (CGRect)getCurrentViewFrame;
- (CGRect)getTabBarFrame;

// Other commands' methods here
#pragma mark -

#endif

@end
