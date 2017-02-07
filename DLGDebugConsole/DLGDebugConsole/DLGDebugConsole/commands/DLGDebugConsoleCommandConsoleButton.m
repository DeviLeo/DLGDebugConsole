//
//  DLGDebugConsoleCommandConsoleButton.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleCommandConsoleButton.h"

#ifdef DEBUG

#import "DLGDebugConsoleCommandParameter.h"

@interface DLGDebugConsoleCommandConsoleButton ()

@property (nonatomic) NSArray *PARAMS;

@end

#endif

@implementation DLGDebugConsoleCommandConsoleButton

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
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Collapsed Frame" andParam:@"-cf" andDetail:@"Show or modify Console Button's collapsed frame (x,y,w,h)."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Collapsed Origin" andParam:@"-co" andDetail:@"Show or modify Console Button's collapsed origin (x,y)."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Collapsed Size" andParam:@"-cs" andDetail:@"Show or modify Console Button's collapsed size (w,h)."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Collapsed X" andParam:@"-cx" andDetail:@"Show or modify Console Button's x collapsed position."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Collapsed Y" andParam:@"-cy" andDetail:@"Show or modify Console Button's y collapsed position."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Collapsed Width" andParam:@"-cw" andDetail:@"Show or modify Console Button's collapsed width."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Collapsed Height" andParam:@"-ch" andDetail:@"Show or modify Console Button's collapsed height."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Expanded Frame" andParam:@"-ef" andDetail:@"Show or modify Console Button's expanded frame (x,y,w,h)."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Expanded Origin" andParam:@"-eo" andDetail:@"Show or modify Console Button's expanded origin (x,y)."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Expanded Size" andParam:@"-es" andDetail:@"Show or modify Console Button's expanded size (w,h)."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Expanded X" andParam:@"-ex" andDetail:@"Show or modify Console Button's expanded x position."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Expanded Y" andParam:@"-ey" andDetail:@"Show or modify Console Button's expanded y position."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Expanded Width" andParam:@"-ew" andDetail:@"Show or modify Console Button's expanded width."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Console Button Expanded Height" andParam:@"-eh" andDetail:@"Show or modify Console Button's expanded height."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Hide Console Button" andParam:@"-h" andDetail:@"Hide Console Button for specified seconds. Default is 15 seconds."],
                    [[DLGDebugConsoleCommandParameter alloc] initWithName:@"Clear logs" andParam:@"-clear" andDetail:@"Clear Console Button's logs."]
                    ];
}

- (void)initCommand {
    self.name = @"Console Button Command";
    self.command = @"cb";
    self.usage = @"cb <parameters> [values]";
    self.brief = @"Show or modify Console Button's frame and hide.";
    NSMutableString *ms = [[NSMutableString alloc] init];
    [self.PARAMS enumerateObjectsUsingBlock:^(DLGDebugConsoleCommandParameter *param, NSUInteger idx, BOOL *stop) {
        [ms appendFormat:@"%@ : %@\n", param.param, param.detail];
    }];
    self.detail = ms;
    self.example = @"(1) cb -cf 10,100,30,10 \n(2) cb -co 20,50\n(3) cb -eh 400\n(4) cb -es full\n(5) cb -h 5\n(6) cb -clear";
}

- (BOOL)execute:(NSArray *)params {
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    NSUInteger count = params.count;
    if (params.count == 0) {
        if ([self.delegate respondsToSelector:@selector(collapsedFrame)]) {
            CGRect collapsedFrame = [self.delegate collapsedFrame];
            [ms appendFormat:@"Console Button Collapsed Frame: %@\n", NSStringFromCGRect(collapsedFrame)];
        }
        if ([self.delegate respondsToSelector:@selector(expandedFrame)]) {
            CGRect expandedFrame = [self.delegate expandedFrame];
            [ms appendFormat:@"Console Button Expanded Frame: %@", NSStringFromCGRect(expandedFrame)];
        }
    } else {
        CGRect collapsedFrame = CGRectZero;
        CGRect expandedFrame = CGRectZero;
        if ([self.delegate respondsToSelector:@selector(collapsedFrame)]) {
            collapsedFrame = [self.delegate collapsedFrame];
        }
        if ([self.delegate respondsToSelector:@selector(expandedFrame)]) {
            expandedFrame = [self.delegate expandedFrame];
        }
        for (NSUInteger i = 0; i < count; ++i) {
            NSString *key = params[i];
            if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[0]).param] == NSOrderedSame) {
#pragma mark - Collapsed Frame
                BOOL modified = NO;
                NSString *p = nil;
                if (++i < count) { p = params[i]; }
                if (p != nil && [p characterAtIndex:0] != '-') {
                    NSArray *a = [p componentsSeparatedByString:@","];
                    if (a.count == 4) {
                        NSString *xs = a[0], *ys = a[1], *ws = a[2], *hs = a[3];
                        CGFloat x = [xs floatValue];
                        CGFloat y = [ys floatValue];
                        CGFloat w = [ws floatValue];
                        CGFloat h = [hs floatValue];
                        
                        if (w > 0 && h > 0) {
                            CGRect oldFrame = collapsedFrame;
                            collapsedFrame = CGRectMake(x, y, w, h);
                            if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                                [self.delegate setCollapsedFrame:collapsedFrame];
                                modified = YES;
                            }
                            [ms appendFormat:@"Console Button Collapsed Frame changed. %@ -> %@\n", NSStringFromCGRect(oldFrame), NSStringFromCGRect(collapsedFrame)];
                        } else {
                            [ms appendFormat:@"Console Button Collapsed Frame cannot be changed to (%@, %@, %@, %@)\n", xs, ys, ws, hs];
                        }
                        
                    } else if ([p compare:@"full"] == NSOrderedSame) {
                        CGRect screenBounds = [UIScreen mainScreen].bounds;
                        CGRect oldFrame = collapsedFrame;
                        collapsedFrame = screenBounds;
                        if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                            [self.delegate setCollapsedFrame:collapsedFrame];
                            modified = YES;
                        }
                        [ms appendFormat:@"Console Button Collapsed Frame changed. %@ -> %@\n", NSStringFromCGRect(oldFrame), NSStringFromCGRect(collapsedFrame)];
                    }
                }
                if (!modified) { [ms appendFormat:@"Console Button Collapsed Frame: %@", NSStringFromCGRect(collapsedFrame)]; }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[1]).param] == NSOrderedSame) {
#pragma mark Collapsed Origin
                BOOL modified = NO;
                NSString *p = nil;
                if (++i < count) { p = params[i]; }
                if (p != nil && [p characterAtIndex:0] != '-') {
                    NSArray *a = [p componentsSeparatedByString:@","];
                    if (a.count == 2) {
                        NSString *xs = a[0], *ys = a[1];
                        CGFloat x = [xs floatValue];
                        CGFloat y = [ys floatValue];
                        
                        CGRect oldFrame = collapsedFrame;
                        collapsedFrame.origin = CGPointMake(x, y);
                        if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                            [self.delegate setCollapsedFrame:collapsedFrame];
                            modified = YES;
                        }
                        [ms appendFormat:@"Console Button Collapsed Origin changed. %@ -> %@\n", NSStringFromCGPoint(oldFrame.origin), NSStringFromCGPoint(collapsedFrame.origin)];
                    }
                }
                if (!modified) { [ms appendFormat:@"Console Button Collapsed Origin: %@", NSStringFromCGPoint(collapsedFrame.origin)]; }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[2]).param] == NSOrderedSame) {
#pragma mark Collapsed Size
                BOOL modified = NO;
                NSString *p = nil;
                if (++i < count) { p = params[i]; }
                if (p != nil && [p characterAtIndex:0] != '-') {
                    NSArray *a = [p componentsSeparatedByString:@","];
                    if (a.count == 2) {
                        NSString *ws = a[0], *hs = a[1];
                        CGFloat w = [ws floatValue];
                        CGFloat h = [hs floatValue];
                        
                        if (w > 0 && h > 0) {
                            CGRect oldFrame = collapsedFrame;
                            collapsedFrame.size = CGSizeMake(w, h);
                            if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                                [self.delegate setCollapsedFrame:collapsedFrame];
                                modified = YES;
                            }
                            [ms appendFormat:@"Console Button Collapsed Size changed. %@ -> %@\n", NSStringFromCGSize(oldFrame.size), NSStringFromCGSize(collapsedFrame.size)];
                        } else {
                            [ms appendFormat:@"Console Button Collapsed Size cannot be changed to (%@, %@)\n", ws, hs];
                        }
                    } else if ([p compare:@"full"] == NSOrderedSame) {
                        CGRect screenBounds = [UIScreen mainScreen].bounds;
                        CGRect oldFrame = collapsedFrame;
                        collapsedFrame = screenBounds;
                        if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                            [self.delegate setCollapsedFrame:collapsedFrame];
                            modified = YES;
                        }
                        [ms appendFormat:@"Console Button Collapsed Size changed. %@ -> %@\n", NSStringFromCGSize(oldFrame.size), NSStringFromCGSize(collapsedFrame.size)];
                    }
                }
                if (!modified) { [ms appendFormat:@"Console Button Collapsed Size: %@", NSStringFromCGSize(collapsedFrame.size)]; }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[3]).param] == NSOrderedSame) {
#pragma mark Collapsed X
                NSString *xs = nil;
                if (++i < count) { xs = params[i]; }
                if (xs != nil && [xs characterAtIndex:0] != '-') {
                    CGFloat x = [xs floatValue];
                    
                    CGRect oldFrame = collapsedFrame;
                    collapsedFrame.origin.x = x;
                    if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                        [self.delegate setCollapsedFrame:collapsedFrame];
                    }
                    [ms appendFormat:@"Console Button Collapsed X changed. %f -> %f\n", oldFrame.origin.x, collapsedFrame.origin.x];
                } else {
                    [ms appendFormat:@"Console Button Collapsed X: %f", collapsedFrame.origin.x];
                }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[4]).param] == NSOrderedSame) {
#pragma mark Collapsed Y
                NSString *ys = nil;
                if (++i < count) { ys = params[i]; }
                if (ys != nil && [ys characterAtIndex:0] != '-') {
                    CGFloat y = [ys floatValue];
                    
                    CGRect oldFrame = collapsedFrame;
                    collapsedFrame.origin.y = y;
                    if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                        [self.delegate setCollapsedFrame:collapsedFrame];
                    }
                    [ms appendFormat:@"Console Button Collapsed Y changed. %f -> %f\n", oldFrame.origin.y, collapsedFrame.origin.y];
                } else {
                    [ms appendFormat:@"Console Button Collapsed Y: %f", collapsedFrame.origin.y];
                }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[5]).param] == NSOrderedSame) {
#pragma mark Collapsed Width
                NSString *ws = nil;
                if (++i < count) { ws = params[i]; }
                if (ws != nil && [ws characterAtIndex:0] != '-') {
                    if ([ws compare:@"full"] == NSOrderedSame) {
                        CGRect screenBounds = [UIScreen mainScreen].bounds;
                        CGRect oldFrame = collapsedFrame;
                        collapsedFrame.origin.x = 0;
                        collapsedFrame.size.width = screenBounds.size.width;
                        if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                            [self.delegate setCollapsedFrame:collapsedFrame];
                        }
                        [ms appendFormat:@"Console Button Collapsed Width changed. %f -> %f\n", oldFrame.size.width, collapsedFrame.size.width];
                    } else {
                        CGFloat w = [ws floatValue];
                        if (w > 0) {
                            CGRect oldFrame = collapsedFrame;
                            collapsedFrame.size.width = w;
                            if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                                [self.delegate setCollapsedFrame:collapsedFrame];
                            }
                            [ms appendFormat:@"Console Button Collapsed Width changed. %f -> %f\n", oldFrame.size.width, collapsedFrame.size.width];
                        } else {
                            [ms appendFormat:@"Console Button Collapsed Width cannot be changed to %@\n", ws];
                        }
                    }
                } else {
                    [ms appendFormat:@"Console Button Collapsed Width: %f", collapsedFrame.size.width];
                }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[6]).param] == NSOrderedSame) {
#pragma mark Collapsed Height
                NSString *hs = nil;
                if (++i < count) { hs = params[i]; }
                if (hs != nil && [hs characterAtIndex:0] != '-') {
                    if ([hs compare:@"full"] == NSOrderedSame) {
                        CGRect screenBounds = [UIScreen mainScreen].bounds;
                        CGRect oldFrame = collapsedFrame;
                        collapsedFrame.origin.y = 0;
                        collapsedFrame.size.height = screenBounds.size.height;
                        if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                            [self.delegate setCollapsedFrame:collapsedFrame];
                        }
                        [ms appendFormat:@"Console Button Collapsed Height changed. %f -> %f\n", oldFrame.size.height, collapsedFrame.size.height];
                    } else {
                        CGFloat h = [hs floatValue];
                        
                        if (h > 0) {
                            CGRect oldFrame = collapsedFrame;
                            collapsedFrame.size.height = h;
                            if ([self.delegate respondsToSelector:@selector(setCollapsedFrame:)]) {
                                [self.delegate setCollapsedFrame:collapsedFrame];
                            }
                            [ms appendFormat:@"Console Button Collapsed Height changed. %f -> %f\n", oldFrame.size.height, collapsedFrame.size.height];
                        } else {
                            [ms appendFormat:@"Console Button Collapsed Height cannot be changed to %@\n", hs];
                        }
                    }
                } else {
                    [ms appendFormat:@"Console Button Collapsed Height: %f", collapsedFrame.size.height];
                }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[7]).param] == NSOrderedSame) {
#pragma mark - Expanded Frame
                BOOL modified = NO;
                NSString *p = nil;
                if (++i < count) { p = params[i]; }
                if (p != nil && [p characterAtIndex:0] != '-') {
                    NSArray *a = [p componentsSeparatedByString:@","];
                    if (a.count == 4) {
                        NSString *xs = a[0], *ys = a[1], *ws = a[2], *hs = a[3];
                        CGFloat x = [xs floatValue];
                        CGFloat y = [ys floatValue];
                        CGFloat w = [ws floatValue];
                        CGFloat h = [hs floatValue];
                        
                        if (w > 0 || h > 0) {
                            CGRect oldFrame = expandedFrame;
                            expandedFrame = CGRectMake(x, y, w, h);
                            if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                                [self.delegate setExpandedFrame:expandedFrame];
                                modified = YES;
                            }
                            [ms appendFormat:@"Console Button Expanded Frame changed. %@ -> %@\n", NSStringFromCGRect(oldFrame), NSStringFromCGRect(expandedFrame)];
                        } else {
                            [ms appendFormat:@"Console Button Expanded Frame cannot be changed to (%@, %@, %@, %@)\n", xs, ys, ws, hs];
                        }
                    } else if ([p compare:@"full"] == NSOrderedSame) {
                        CGRect screenBounds = [UIScreen mainScreen].bounds;
                        CGRect oldFrame = expandedFrame;
                        expandedFrame = screenBounds;
                        if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                            [self.delegate setExpandedFrame:expandedFrame];
                            modified = YES;
                        }
                        [ms appendFormat:@"Console Button Expanded Frame changed. %@ -> %@\n", NSStringFromCGRect(oldFrame), NSStringFromCGRect(expandedFrame)];
                    }
                }
                if (!modified) { [ms appendFormat:@"Console Button Expanded Frame: %@", NSStringFromCGRect(expandedFrame)]; }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[8]).param] == NSOrderedSame) {
#pragma mark Expanded Origin
                BOOL modified = NO;
                NSString *p = nil;
                if (++i < count) { p = params[i]; }
                if (p != nil && [p characterAtIndex:0] != '-') {
                    NSArray *a = [p componentsSeparatedByString:@","];
                    if (a.count == 2) {
                        NSString *xs = a[0], *ys = a[1];
                        CGFloat x = [xs floatValue];
                        CGFloat y = [ys floatValue];
                        
                        CGRect oldFrame = expandedFrame;
                        expandedFrame.origin = CGPointMake(x, y);
                        if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                            [self.delegate setExpandedFrame:expandedFrame];
                            modified = YES;
                        }
                        [ms appendFormat:@"Console Button Expanded Origin changed. %@ -> %@\n", NSStringFromCGPoint(oldFrame.origin), NSStringFromCGPoint(expandedFrame.origin)];
                    }
                }
                if (!modified) { [ms appendFormat:@"Console Button Expanded Origin: %@", NSStringFromCGPoint(expandedFrame.origin)]; }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[9]).param] == NSOrderedSame) {
#pragma mark Expanded Size
                BOOL modified = NO;
                NSString *p = nil;
                if (++i < count) { p = params[i]; }
                if (p != nil && [p characterAtIndex:0] != '-') {
                    NSArray *a = [p componentsSeparatedByString:@","];
                    if (a.count == 2) {
                        NSString *ws = a[0], *hs = a[1];
                        CGFloat w = [ws floatValue];
                        CGFloat h = [hs floatValue];
                        
                        if (w > 0 || h > 0) {
                            CGRect oldFrame = expandedFrame;
                            expandedFrame.size = CGSizeMake(w, h);
                            if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                                [self.delegate setExpandedFrame:expandedFrame];
                                modified = YES;
                            }
                            [ms appendFormat:@"Console Button Expanded Size changed. %@ -> %@\n", NSStringFromCGSize(oldFrame.size), NSStringFromCGSize(expandedFrame.size)];
                        } else {
                            [ms appendFormat:@"Console Button Expanded Size cannot be changed to (%@, %@)\n", ws, hs];
                        }
                    } else if ([p compare:@"full"] == NSOrderedSame) {
                        CGRect screenBounds = [UIScreen mainScreen].bounds;
                        CGRect oldFrame = expandedFrame;
                        expandedFrame = screenBounds;
                        if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                            [self.delegate setExpandedFrame:expandedFrame];
                            modified = YES;
                        }
                        [ms appendFormat:@"Console Button Expanded Size changed. %@ -> %@\n", NSStringFromCGSize(oldFrame.size), NSStringFromCGSize(expandedFrame.size)];
                    }
                }
                if (!modified) { [ms appendFormat:@"Console Button Expanded Size: %@", NSStringFromCGSize(expandedFrame.size)]; }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[10]).param] == NSOrderedSame) {
#pragma mark Expanded X
                NSString *xs = nil;
                if (++i < count) { xs = params[i]; }
                if (xs != nil && [xs characterAtIndex:0] != '-') {
                    CGFloat x = [xs floatValue];
                    
                    CGRect oldFrame = expandedFrame;
                    expandedFrame.origin.x = x;
                    if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                        [self.delegate setExpandedFrame:expandedFrame];
                    }
                    [ms appendFormat:@"Console Button Expanded X changed. %f -> %f\n", oldFrame.origin.x, expandedFrame.origin.x];
                } else {
                    [ms appendFormat:@"Console Button Expanded X: %f", expandedFrame.origin.x];
                }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[11]).param] == NSOrderedSame) {
#pragma mark Expanded Y
                NSString *ys = nil;
                if (++i < count) { ys = params[i]; }
                if (ys != nil && [ys characterAtIndex:0] != '-') {
                    CGFloat y = [ys floatValue];
                    
                    CGRect oldFrame = expandedFrame;
                    expandedFrame.origin.y = y;
                    if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                        [self.delegate setExpandedFrame:expandedFrame];
                    }
                    [ms appendFormat:@"Console Button Expanded Y changed. %f -> %f\n", oldFrame.origin.y, expandedFrame.origin.y];
                } else {
                    [ms appendFormat:@"Console Button Expanded Y: %f", expandedFrame.origin.y];
                }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[12]).param] == NSOrderedSame) {
#pragma mark Expanded Width
                NSString *ws = nil;
                if (++i < count) { ws = params[i]; }
                if (ws != nil && [ws characterAtIndex:0] != '-') {
                    if ([ws compare:@"full"] == NSOrderedSame) {
                        CGRect screenBounds = [UIScreen mainScreen].bounds;
                        CGRect oldFrame = expandedFrame;
                        expandedFrame.origin.x = 0;
                        expandedFrame.size.width = screenBounds.size.width;
                        if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                            [self.delegate setExpandedFrame:expandedFrame];
                        }
                        [ms appendFormat:@"Console Button Expanded Width changed. %f -> %f\n", oldFrame.size.width, expandedFrame.size.width];
                    } else {
                        CGFloat w = [ws floatValue];
                        if (w > 0) {
                            CGRect oldFrame = expandedFrame;
                            expandedFrame.size.width = w;
                            if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                                [self.delegate setExpandedFrame:expandedFrame];
                            }
                            [ms appendFormat:@"Console Button Expanded Width changed. %f -> %f\n", oldFrame.size.width, expandedFrame.size.width];
                        } else {
                            [ms appendFormat:@"Console Button Expanded Width cannot be changed to %@\n", ws];
                        }
                    }
                } else {
                    [ms appendFormat:@"Console Button Expanded Width: %f", expandedFrame.size.width];
                }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[13]).param] == NSOrderedSame) {
#pragma mark Expanded Height
                NSString *hs = nil;
                if (++i < count) { hs = params[i]; }
                if (hs != nil && [hs characterAtIndex:0] != '-') {
                    if ([hs compare:@"full"] == NSOrderedSame) {
                        CGRect screenBounds = [UIScreen mainScreen].bounds;
                        CGRect oldFrame = expandedFrame;
                        expandedFrame.origin.y = 0;
                        expandedFrame.size.height = screenBounds.size.height;
                        if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                            [self.delegate setExpandedFrame:expandedFrame];
                        }
                        [ms appendFormat:@"Console Button Expanded Height changed. %f -> %f\n", oldFrame.size.height, expandedFrame.size.height];
                    } else {
                        CGFloat h = [hs floatValue];
                        if (h > 0) {
                            CGRect oldFrame = expandedFrame;
                            expandedFrame.size.height = h;
                            if ([self.delegate respondsToSelector:@selector(setExpandedFrame:)]) {
                                [self.delegate setExpandedFrame:expandedFrame];
                            }
                            [ms appendFormat:@"Console Button Expanded Height changed. %f -> %f\n", oldFrame.size.height, expandedFrame.size.height];
                        } else {
                            [ms appendFormat:@"Console Button Expanded Height cannot be changed to %@\n", hs];
                        }
                    }
                } else {
                    [ms appendFormat:@"Console Button Expanded Height: %f", expandedFrame.size.height];
                }
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[14]).param] == NSOrderedSame) {
#pragma mark Hide Console Button
                NSString *s = nil;
                if (++i < count) { s = params[i]; }
                CGFloat sec = 15.0f;
                if (s != nil && [s characterAtIndex:0] != '-') {
                    sec = [s floatValue];
                    if (sec <= 0.0f) {
                        sec = 15.0f;
                    }
                }
                if ([self.delegate respondsToSelector:@selector(hideConsoleButtonForSeconds:)]) {
                    [self.delegate hideConsoleButtonForSeconds:sec];
                }
                [ms appendFormat:@"Hide Console Button for %f %@.", sec, sec > 1.0f ? @"seconds" : @"second"];
            } else if ([key compare:((DLGDebugConsoleCommandParameter *)self.PARAMS[15]).param] == NSOrderedSame) {
#pragma mark Clear logs
                if ([self.delegate respondsToSelector:@selector(clearLogs)]) {
                    [self.delegate clearLogs];
                    return YES;
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
