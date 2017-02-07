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

@property (nonatomic, strong) NSString *serverHost;

@property (nonatomic) BOOL enableDebugNetwork;
@property (nonatomic) NSString *networkLogs;

+ (instancetype)instance;

#pragma mark - Server Host
- (NSArray *)fastSwitchServerHostList;
- (void)fastSwitchServerHost:(NSInteger)index;

- (CGRect)getStatusBarFrame;
- (CGRect)getNavigationBarFrame;
- (CGRect)getCurrentViewFrame;
- (NSDictionary *)getUserInfo;
- (BOOL)saveUserInfo:(NSDictionary *)updateUserInfo;

#endif

@end
