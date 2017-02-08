//
//  ViewController.h
//  DLGDebugConsole
//
//  Created by Liu Junqi on 07/02/2017.
//  Copyright © 2017 DeviLeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

+ (NSDictionary *)user;
+ (void)setUser:(NSDictionary *)user;

+ (void)setDebugNetwork:(BOOL)debug;
+ (NSString *)networkLogs;

@end

