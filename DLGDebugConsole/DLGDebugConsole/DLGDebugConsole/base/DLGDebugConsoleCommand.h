//
//  DLGDebugConsoleCommand.h
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG

#import "DLGDebugConsoleViewDelegate.h"

#endif

@interface DLGDebugConsoleCommand : NSObject

#ifdef DEBUG

@property (nonatomic, weak) id<DLGDebugConsoleViewDelegate> delegate;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *command;
@property (nonatomic) NSString *usage;
@property (nonatomic) NSString *brief;
@property (nonatomic) NSString *detail;
@property (nonatomic) NSString *example;

- (id)initWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate;
- (BOOL)execute:(NSArray *)params;

#endif

@end
