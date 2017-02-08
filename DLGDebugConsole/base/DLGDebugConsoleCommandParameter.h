//
//  DLGDebugConsoleCommandParameter.h
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLGDebugConsoleCommandParameter : NSObject

#ifdef DEBUG

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *param;
@property (nonatomic) NSString *detail;

- (id)initWithName:(NSString *)name andParam:(NSString *)param andDetail:(NSString *)detail;

#endif

@end
