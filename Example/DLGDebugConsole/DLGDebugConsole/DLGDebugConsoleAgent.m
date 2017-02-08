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
#import "ViewController.h"

// define here
#define CONFIG_KEY_NETWORK_DEBUG    @"NETWORK_DEBUG"
#define CONFIG_KEY_SERVER_HOST      @"SERVER_HOST"
#define CONFIG_MASK_SERVER_HOST     (1)

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
        [self initNetCommandVars];
        [self initServerCommandVars];
    }
    return self;
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
#pragma mark - Server command
- (void)initServerCommandVars {
    [self loadServerConfig];
}

- (void)setServerHost:(NSString *)serverHost {
    _serverHost = serverHost;
    [self saveServerConfig:CONFIG_MASK_SERVER_HOST];
}

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

#pragma mark - User command
- (NSDictionary *)getUserInfo {
    NSDictionary *user = [ViewController user];
    return user;
}

- (BOOL)saveUserInfo:(NSDictionary *)updateUserInfo {
    [ViewController setUser:updateUserInfo];
    
    return YES;
}

#pragma mark - Net command
- (void)initNetCommandVars {
    _enableDebugNetwork = [self loadNetworkDebugConfig];
    [ViewController setDebugNetwork:_enableDebugNetwork];
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
