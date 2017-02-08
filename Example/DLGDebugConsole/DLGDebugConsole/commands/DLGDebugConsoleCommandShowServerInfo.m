//
//  DLGDebugConsoleCommandShowServerInfo.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleCommandShowServerInfo.h"

#ifdef DEBUG

#import "DLGDebugConsoleCommandParameter.h"
#import "DLGDebugConsoleAgent.h"

@interface DLGDebugConsoleCommandShowServerInfo ()

@property (nonatomic) NSArray<DLGDebugConsoleCommandParameter *> *parameters;

@end

#endif

@implementation DLGDebugConsoleCommandShowServerInfo

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
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"All Servers Information" andParam:@"-all" andDetail:@"Show all servers' information."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Server Host" andParam:@"-host" andDetail:@"Show or modify the server host."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Fast Switch Server Host" andParam:@"-fs" andDetail:@"Fast modify the server host to predefined server host."]
                    ];
}

- (void)initCommand {
    self.name = @"Server Information Command";
    self.command = @"svr";
    self.usage = @"svr <parameters> [values]";
    self.brief = @"Show or modify server's information.";
    NSMutableString *ms = [[NSMutableString alloc] init];
    [self.parameters enumerateObjectsUsingBlock:^(DLGDebugConsoleCommandParameter *param, NSUInteger idx, BOOL *stop) {
        [ms appendFormat:@"%@ : %@\n", param.param, param.detail];
    }];
    self.detail = ms;
    self.example = @"(1) svr -all\n(2) svr -host\n(3) svr -host 127.0.0.1\n(4) svr -fs 0";
}

- (BOOL)execute:(NSArray *)params {
    DLGDebugConsoleAgent *agent = [DLGDebugConsoleAgent instance];
    
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    NSUInteger count = params.count;
    if (params.count == 0 || [params containsObject:self.parameters[0].param]) {
        [ms appendFormat:@"Server: %@", agent.serverHost];
    } else {
        for (NSUInteger i = 0; i < count; ++i) {
            NSString *key = params[i];
            if ([key compare:self.parameters[1].param] == NSOrderedSame) {
                NSString *value = nil;
                if (++i < count) { value = params[i]; }
                if (value == nil || value.length == 0) {
                    [ms appendFormat:@"Server: %@\n", agent.serverHost];
                } else if ([value characterAtIndex:0] == '-') {
                    --i;
                    [ms appendFormat:@"Server: %@\n", agent.serverHost];
                } else {
                    NSString *oldServerHost = agent.serverHost;
                    agent.serverHost = value;
                    [ms appendFormat:@"Server changed. %@ -> %@\n", oldServerHost, value];
                }
            } else if ([key compare:self.parameters[2].param] == NSOrderedSame) {
                NSString *value = nil;
                NSArray *servers = [agent fastSwitchServerHostList];
                if (++i < count) { value = params[i]; }
                if (value == nil || value.length == 0) {
                    [ms appendFormat:@"Fast Switch Server Host:\n"];
                    [servers enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
                        [ms appendFormat:@"(%lu) %@\n", (unsigned long)idx, obj];
                    }];
                } else if ([value characterAtIndex:0] == '-'){
                    --i;
                    [ms appendFormat:@"Fast Switch Server Host:\n"];
                    [servers enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
                        [ms appendFormat:@"(%lu) %@\n", (unsigned long)idx, obj];
                    }];
                } else if ([value integerValue] >= servers.count) {
                    [ms appendFormat:@"Please select the following Server Host:\n"];
                    [servers enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
                        [ms appendFormat:@"(%lu) %@\n", (unsigned long)idx, obj];
                    }];
                } else {
                    NSInteger index = [value integerValue];
                    NSString *oldServerHost = agent.serverHost;
                    NSArray *server = servers[index];
                    agent.serverHost = server[0];
                    [ms appendFormat:@"Servers changed.\nServer: %@ -> %@",
                     oldServerHost, agent.serverHost];
                }
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
