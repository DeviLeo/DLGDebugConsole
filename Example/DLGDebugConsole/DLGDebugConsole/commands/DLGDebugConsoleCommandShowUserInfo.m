//
//  DLGDebugConsoleCommandShowUserInfo.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleCommandShowUserInfo.h"

#ifdef DEBUG

#import "DLGDebugConsoleAgent.h"

#endif

@implementation DLGDebugConsoleCommandShowUserInfo

#ifdef DEBUG

- (id)initWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    
    if (self) {
        [self initCommand];
    }
    
    return self;
}

- (void)initCommand {
    self.name = @"User Information Command";
    self.command = @"usr";
    self.usage = @"usr <parameters> [values]";
    self.brief = @"Show or modify user's information.";
    self.detail = @"Parameters is the key of user information's dictionary with hyphen. Add a value follows the parameter to modify the value of key.";
    self.example = @"(1) usr -mobile\n(2) usr -nickname \"New Nickname\"";
}

- (BOOL)execute:(NSArray *)params {
    DLGDebugConsoleAgent *agent = [DLGDebugConsoleAgent instance];
    NSDictionary *userInfo = [agent getUserInfo];
    NSMutableDictionary *modifiedUserInfo = [[NSMutableDictionary alloc] init];
    
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    NSUInteger count = params.count;
    if (params == nil || count == 0) {
        [ms appendFormat:@"UserInfo: %@", userInfo];
    } else {
        for (NSUInteger i = 0; i < count; ++i) {
            NSString *cmd = [params objectAtIndex:i];
            if ([cmd characterAtIndex:0] == '-') {
                BOOL modified = NO;
                NSString *key = [cmd substringFromIndex:1];
                if (i + 1 < count) {
                    NSString *val = [params objectAtIndex:i + 1];
                    if ([val characterAtIndex:0] != '-') {
                        id oldValue = [userInfo objectForKey:key];
                        if ([oldValue isKindOfClass:[NSString class]]) {
                            [modifiedUserInfo setValue:val forKey:key];
                        } else if ([oldValue isKindOfClass:[NSNumber class]]) {
                            NSNumber *oldValueNum = oldValue;
                            NSString *oldValueString = [oldValueNum stringValue];
                            NSNumber *num = nil;
                            if ([oldValueString rangeOfString:@"."].location == NSNotFound) {
                                num = [NSNumber numberWithInt:[val intValue]];
                            } else {
                                num = [NSNumber numberWithFloat:[val floatValue]];
                            }
                            [modifiedUserInfo setValue:num forKey:key];
                        } else {
                            [modifiedUserInfo setValue:val forKey:key];
                        }
                        ++i;
                        modified = YES;
                        [ms appendFormat:@"%@ changed! %@ -> %@\n", key, [userInfo objectForKey:key], val];
                    }
                }
                if (!modified) {
                    [ms appendFormat:@"%@ : %@\n", key, [userInfo objectForKey:key]];
                }
            }
        }
        if (modifiedUserInfo.count > 0) {
            if (![agent saveUserInfo:modifiedUserInfo]) {
                [ms appendFormat:@"FAILED to modify! The user information to update:\n%@", modifiedUserInfo];
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
