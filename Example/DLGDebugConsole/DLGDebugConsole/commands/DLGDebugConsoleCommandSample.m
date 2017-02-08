//
//  DLGDebugConsoleCommandSample.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 08/02/2017.
//  Copyright © 2017 DeviLeo. All rights reserved.
//

#import "DLGDebugConsoleCommandSample.h"

#ifdef DEBUG

#import "DLGDebugConsoleCommandParameter.h"

@interface DLGDebugConsoleCommandSample ()

@property (nonatomic) NSArray<DLGDebugConsoleCommandParameter *> *parameters; // command's parameter list

@end

#endif

@implementation DLGDebugConsoleCommandSample

#ifdef DEBUG

- (id)initWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    
    if (self) {
        [self initParameters];
        [self initCommand];
        // Put your initialization codes here
    }
    
    return self;
}

- (void)initParameters {
    // Put your parameters' initialization here
    DLGDebugConsoleCommandParameter *param1 =
    [[DLGDebugConsoleCommandParameter alloc]
     initWithName:@"Print Message"                  // parameter's name
         andParam:@"-p"                             // parameter
        andDetail:@"Print a message on console."];  // Details about parameters
    
    DLGDebugConsoleCommandParameter *param2 = [[DLGDebugConsoleCommandParameter alloc]
                                               initWithName:@"Save Message"
                                               andParam:@"-s"
                                               andDetail:@"Save the message to disk."];
    
    self.parameters = @[param1, param2];
}

- (void)initCommand {
    // Put your command's initialization here
    // Command name
    self.name = @"Sample Command";
    
    // Command
    self.command = @"spl";
    
    // Usage format
    self.usage = @"s <parameters> [values]";
    
    // A breif introduction to this command
    self.brief = @"This is a sample command.";
    
    // Details about this command and each parameter
    NSMutableString *ms = [[NSMutableString alloc] init];
    [self.parameters enumerateObjectsUsingBlock:^(DLGDebugConsoleCommandParameter *param, NSUInteger idx, BOOL *stop) {
        [ms appendFormat:@"%@ : %@\n", param.param, param.detail];
    }];
    self.detail = ms;
    
    // Examples about how to use this command
    self.example = @"(1) spl -p Sample message\n(2) spl -s Message to disk";
}

- (BOOL)execute:(NSArray *)params {
    // Put what this command want to do here
    
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    NSUInteger count = params.count;
    if (params.count == 0) {
        // command without parameters
        [ms appendFormat:@"%@", self];
    } else {
        for (NSUInteger i = 0; i < count; ++i) {
            NSString *key = params[i];
            if ([key compare:self.parameters[0].param] == NSOrderedSame) {
                NSString *value = [self entireValueFromParams:params fromIndex:++i endInIndex:&i];
                if (value != nil && value.length > 0) {
                    [ms appendFormat:@"%@\n", value];
                }
            } else if ([key compare:self.parameters[1].param] == NSOrderedSame) {
                NSString *value = [self entireValueFromParams:params fromIndex:++i endInIndex:&i];
                if (value != nil && value.length > 0) {
                    [ms appendFormat:@"%@ ... Saved\n", value];
                }
            }
        }
    }
    
    // Output the results to the console view
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

// spl -p "aaa bbb ccc" -> params: [@"-p", @"\"aaa", @"bbb", @"ccc\""] -> param: -p, value: aaa bbb ccc
- (NSString *)entireValueFromParams:(NSArray *)params fromIndex:(NSUInteger)i endInIndex:(NSUInteger *)endIndex {
    NSString *value = nil;
    NSUInteger count = params.count;
    if (i < count) { value = params[i]; }
    if (value != nil && [value characterAtIndex:0] == '\"') {
        // Search the entire string
        NSMutableString *s = [NSMutableString stringWithString:value];
        while (++i < count) {
            value = params[i];
            [s appendFormat:@" %@", value];
            if ([value characterAtIndex:value.length - 1] == '\"') {
                if (value.length >= 2) {
                    if ([value characterAtIndex:value.length - 2] != '\\')
                        break;
                } else break;
            }
        }
        if (endIndex != nil) *endIndex = i;
        value = [s substringWithRange:NSMakeRange(1, s.length - 2)];
    }
    return value;
}

#endif

@end
