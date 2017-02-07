//
//  DLGDebugConsoleAgent.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleAgent.h"

#define CONFIG_KEY_NETWORK_DEBUG    @"NETWORK_DEBUG"
#define CONFIG_KEY_SERVER_HOST      @"SERVER_HOST"
#define CONFIG_MASK_SERVER_HOST     (1)

#ifdef DEBUG

#import "ViewController.h"

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

- (id)init {
    self = [super init];
    if (self) {
        [self initVars];
        [self loadServerConfig];
    }
    return self;
}

- (void)initVars {
    _enableDebugNetwork = [self loadNetworkDebugConfig];
    [ViewController setDebugNetwork:_enableDebugNetwork];
}

- (void)setServerHost:(NSString *)serverHost {
    _serverHost = serverHost;
    [self saveServerConfig:CONFIG_MASK_SERVER_HOST];
}

#pragma mark - Server Host
- (NSArray *)fastSwitchServerHostList {
    // @[@"App接口服务器"]
    // @[@"Server Host"]
    NSArray *servers = @[
                         @[@"127.0.0.1"],
                         @[@"192.168.31.1"]
                         ];
    return servers;
}
- (void)fastSwitchServerHost:(NSInteger)index {
    NSArray *servers = [self fastSwitchServerHostList];
    NSArray *server = servers[index];
    _serverHost = server[0];
    [self saveServerConfig];
}
- (void)loadServerConfig {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *serverHost = [userDefaults stringForKey:CONFIG_KEY_SERVER_HOST];
    if (serverHost == nil) {
        [self fastSwitchServerHost:0];
        [self saveServerConfig];
    } else {
        _serverHost = serverHost;
    }
}

- (void)saveServerConfig:(NSInteger)serverMask {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (serverMask & CONFIG_MASK_SERVER_HOST)   [userDefaults setValue:self.serverHost forKey:CONFIG_KEY_SERVER_HOST];
}

- (void)saveServerConfig {
    [self saveServerConfig:(CONFIG_MASK_SERVER_HOST)];
}

- (void)saveNetworkDebugConfig:(BOOL)debug {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(debug) forKey:CONFIG_KEY_NETWORK_DEBUG];
}

- (BOOL)loadNetworkDebugConfig {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL debug = [userDefaults boolForKey:CONFIG_KEY_NETWORK_DEBUG];
    return debug;
}

#pragma mark -
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
    UIApplication *app = [UIApplication sharedApplication];
    UINavigationController *root = (UINavigationController *)app.keyWindow.rootViewController;
    return root.navigationBar.frame;
}

- (NSDictionary *)getUserInfo {
    NSDictionary *user = [ViewController user];
    return user;
}

- (BOOL)saveUserInfo:(NSDictionary *)updateUserInfo {
    [ViewController setUser:updateUserInfo];
    
    return YES;
}

- (void)setEnableDebugNetwork:(BOOL)enableDebugNetwork {
    _enableDebugNetwork = enableDebugNetwork;
    [self saveNetworkDebugConfig:enableDebugNetwork];
    [ViewController setDebugNetwork:enableDebugNetwork];
}

- (BOOL)isEnableDebugNetwork {
    return _enableDebugNetwork;
}

- (NSString *)networkLogs {
    return [ViewController networkLogs];
}

#endif

@end
