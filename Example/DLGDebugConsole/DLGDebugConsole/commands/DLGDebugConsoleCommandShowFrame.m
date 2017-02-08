//
//  DLGDebugConsoleCommandShowFrame.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleCommandShowFrame.h"

#ifdef DEBUG

#import "DLGDebugConsoleCommandParameter.h"
#import "DLGDebugConsoleAgent.h"

@interface DLGDebugConsoleCommandShowFrame ()

@property (nonatomic) NSArray<DLGDebugConsoleCommandParameter *> *parameters;

@end

#endif

@implementation DLGDebugConsoleCommandShowFrame

#ifdef DEBUG

- (id)initWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    
    if (self) {
        [self initParameters];
        [self initCommand];
    }
    
    return self;
}

- (void)initParameters {
    self.parameters = @[
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"All Frames" andParam:@"-all" andDetail:@"Show all visible views' frame."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Window Frame" andParam:@"-win" andDetail:@"Show window's frame."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Status Bar Frame" andParam:@"-sb" andDetail:@"Show status bar frame."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Navigation Bar Frame" andParam:@"-nb" andDetail:@"Show navigation bar frame."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Tab Bar Frame" andParam:@"-tb" andDetail:@"Show tab bar frame."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Current View Frame" andParam:@"-cv" andDetail:@"Show current view controller."]
                    ];
}

- (void)initCommand {
    self.name = @"Show Frame Command";
    self.command = @"sf";
    self.usage = @"sf <parameters>";
    self.brief = @"Show view's frame.";
    NSMutableString *ms = [[NSMutableString alloc] init];
    [self.parameters enumerateObjectsUsingBlock:^(DLGDebugConsoleCommandParameter *param, NSUInteger idx, BOOL *stop) {
        [ms appendFormat:@"%@ : %@\n", param.param, param.detail];
    }];
    self.detail = ms;
    self.example = @"(1) sf -all\n(2) sf -sb -nb -tb";
}

- (BOOL)execute:(NSArray *)params {
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    DLGDebugConsoleAgent *agent = [DLGDebugConsoleAgent instance];

    CGRect statusBarFrame = [agent getStatusBarFrame];
    CGRect navigationBarFrame = [agent getNavigationBarFrame];
    CGRect currentViewFrame = [agent getCurrentViewFrame];
    CGRect tabBarFrame = [agent getTabBarFrame];
    
    BOOL showAll = (params.count == 0 || [params containsObject:self.parameters[0].param]);
    
    // App Window Info
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (showAll || [params containsObject:self.parameters[1].param])
        [ms appendFormat:@"Window Frame: %@\n", NSStringFromCGRect(window.frame)];
    
    // Status Bar
    if (showAll || [params containsObject:self.parameters[2].param])
        [ms appendFormat:@"Status Bar frame: %@\n", NSStringFromCGRect(statusBarFrame)];
    
    // Navigation Controller
    if (showAll || [params containsObject:self.parameters[3].param])
        [ms appendFormat:@"Navigation Bar Frame: %@\n", NSStringFromCGRect(navigationBarFrame)];
    
    // Bottom Tab Bar
    if (showAll || [params containsObject:self.parameters[4].param])
        [ms appendFormat:@"Bottom Tab Bar Frame: %@\n", NSStringFromCGRect(tabBarFrame)];
    
    // Current View Controller Info
    if (showAll || [params containsObject:self.parameters[5].param])
        [ms appendFormat:@"Current VC Frame: %@\n", NSStringFromCGRect(currentViewFrame)];
    
    if (ms.length == 0) {
        NSString *usage = [NSString stringWithFormat:@"%@", self];
        if ([self.delegate respondsToSelector:@selector(outputCommandResult:)]) {
            [self.delegate outputCommandResult:usage];
        } else { return NO; }
    } else {
        if ([self.delegate respondsToSelector:@selector(outputCommandResult:)]) {
            [self.delegate outputCommandResult:ms];
        } else { return NO; }
    }
    
    return YES;
}


#endif

@end
