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
#pragma mark - Server command
@property (nonatomic, strong) NSString *serverHost;
- (NSArray *)fastSwitchServerHostList;
- (void)fastSwitchServerHost:(NSInteger)index;

#pragma mark - User command
- (NSDictionary *)getUserInfo;
- (BOOL)saveUserInfo:(NSDictionary *)updateUserInfo;

#pragma mark - Net command
@property (nonatomic) BOOL enableDebugNetwork;
@property (nonatomic) NSString *networkLogs;

#endif

@end

