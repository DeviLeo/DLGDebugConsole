//
//  ViewController.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 07/02/2017.
//  Copyright © 2017 DeviLeo. All rights reserved.
//

#import "ViewController.h"
#import "DLGDebugConsole.h"

static NSDictionary *userinfo;
static BOOL debugNetwork;
static NSMutableString *networkLogs;

#ifdef DEBUG

#define SERVER_HOST ([DLGDebugConsoleAgent instance].serverHost)

#else

#define SERVER_HOST @"192.168.1.1"

#endif

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *lblUserInfo;
@property (nonatomic, weak) IBOutlet UILabel *lblNetworkStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    networkLogs = [NSMutableString stringWithCapacity:1024];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [DLGDebugConsole addConsoleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generateUser {
    int x = arc4random() % 10;
    NSString *nickname = @"none";
    if (x == 0) nickname = @"Apple";
    else if (x == 1) nickname = @"Banana";
    else if (x == 2) nickname = @"Cheery";
    else if (x == 3) nickname = @"Durian";
    else if (x == 4) nickname = @"Ehh";
    else if (x == 5) nickname = @"Filbert";
    else if (x == 6) nickname = @"Grape";
    else if (x == 7) nickname = @"Hawthorn";
    else if (x == 8) nickname = @"Lemon";
    else if (x == 9) nickname = @"Mango";
    userinfo = @{@"nickname" : nickname, @"mobile" : @"+86-021-000000"};
    _lblUserInfo.text = userinfo[@"nickname"];
}

- (IBAction)refreshUser {
    _lblUserInfo.text = userinfo[@"nickname"];
}

- (IBAction)connect {
    BOOL success = arc4random() % 2 == 1;
    _lblNetworkStatus.text = [NSString stringWithFormat:@"Connecting %@...%@",
                              SERVER_HOST, success ? @"SUCCESS" : @"FAILED"];
    if (debugNetwork) {
        [networkLogs appendFormat:@"Connecting %@...\n", SERVER_HOST];
        if (success) {
            [networkLogs appendString:@"Connected. Validating...\n"];
            [networkLogs appendString:@"Success. Get server information...\n"];
            [networkLogs appendString:@"Gotcha! Downloading files...\n"];
            [networkLogs appendString:@"Done!\n"];
        } else {
            [networkLogs appendString:@"Found server. Validating...\n"];
            [networkLogs appendString:@"Access Denied!\n"];
        }
    }
}

- (IBAction)disconnect {
    BOOL local = arc4random() % 2 == 1;
    _lblNetworkStatus.text = [NSString stringWithFormat:@"Disconnected...%@",
                              local ? @"local" : @"remote"];
    if (debugNetwork) {
        [networkLogs appendString:@"Disconnecting...\n"];
        if (local) {
            [networkLogs appendString:@"Syncing...\n"];
            [networkLogs appendString:@"Uploading local information...\n"];
            [networkLogs appendString:@"Done!\n"];
        } else {
            [networkLogs appendString:@"Server will shutdown in 5 seconds...\n"];
            [networkLogs appendString:@"4...\n"];
            [networkLogs appendString:@"3...\n"];
            [networkLogs appendString:@"2...\n"];
            [networkLogs appendString:@"1...\n"];
        }
        [networkLogs appendString:@"Disconnected.\n"];
    }
}

- (IBAction)addConsoleView:(id)sender {
    [DLGDebugConsole addConsoleView];
}

- (IBAction)removeConsoleView:(id)sender {
    [DLGDebugConsole removeConsoleView];
}

+ (NSDictionary *)user {
    return userinfo;
}

+ (void)setUser:(NSDictionary *)user {
    userinfo = user;
}

+ (void)setDebugNetwork:(BOOL)debug {
    debugNetwork = debug;
}

+ (NSString *)networkLogs {
    NSString *logs = [networkLogs copy];
    networkLogs = [NSMutableString stringWithCapacity:1024];
    return logs;
}

@end
