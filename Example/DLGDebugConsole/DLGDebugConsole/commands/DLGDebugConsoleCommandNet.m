//
//  DLGDebugConsoleCommandNet.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleCommandNet.h"

#ifdef DEBUG

#import "DLGDebugConsoleCommandParameter.h"
#import "DLGDebugConsoleAgent.h"

@interface DLGDebugConsoleCommandNet ()

@property (nonatomic) NSArray *PARAMS;

@end

#endif

@implementation DLGDebugConsoleCommandNet

#ifdef DEBUG

- (id)initWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    
    if (self) {
        [self initPARAMS];
        [self initCommand];
    }
    
    return self;
}

- (void)initPARAMS {
    self.PARAMS = @[
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Debug ON/OFF" andParam:@"-dbg" andDetail:@"Show or change debug status."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Show logs" andParam:@"-log" andDetail:@"Show recent network logs."]
                    ];
}

- (void)initCommand {
    self.name = @"Net Command";
    self.command = @"net";
    self.usage = @"net <parameters>";
    self.brief = @"Config network communication.";
    NSMutableString *ms = [[NSMutableString alloc] init];
    [self.PARAMS enumerateObjectsUsingBlock:^(DLGDebugConsoleCommandParameter *param, NSUInteger idx, BOOL *stop) {
        [ms appendFormat:@"%@ : %@\n", param.param, param.detail];
    }];
    self.detail = ms;
    self.example = @"(1) net -dbg 1\n(2) net -log";
}

- (BOOL)execute:(NSArray *)params {
    DLGDebugConsoleAgent *agent = [DLGDebugConsoleAgent instance];
    
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    NSUInteger count = params.count;
    if (params.count == 0) {
        [ms appendFormat:@"Current Network Debug: %@\n", agent.enableDebugNetwork ? @"ON" : @"OFF"];
    } else {
        for (NSUInteger i = 0; i < count; ++i) {
            NSString *key = params[i];
            if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[0]).param] == NSOrderedSame) {
                NSString *value = nil;
                if (++i < count) { value = params[i]; }
                if (value != nil && value.length == 1) {
                    BOOL enableDebugNetwork = [value isEqualToString:@"0"] ? NO : YES;
                    agent.enableDebugNetwork = enableDebugNetwork;
                    [ms appendFormat:@"Set network debug %@\n", (enableDebugNetwork ? @"ON" : @"OFF")];
                }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[1]).param] == NSOrderedSame) {
                NSString *logs = agent.networkLogs;
                if (logs != nil && logs.length > 0) [ms appendFormat:@"%@\n", logs];
                else [ms appendFormat:@"%@\n", @"No network logs."];
            }
        }
    }
    
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
