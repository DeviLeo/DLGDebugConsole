//
//  DLGDebugConsoleView.m
//  DLGDebugConsole
//
//  Created by Liu Junqi on 11/11/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGDebugConsoleView.h"

#ifdef DEBUG
#import "DLGDebugConsoleViewDelegate.h"
#import "DLGDebugConsoleCommands.h"

@interface DLGDebugConsoleView () <DLGDebugConsoleViewDelegate, UITextFieldDelegate>

@property (nonatomic) IBOutlet UIButton *btnConsole;
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@property (nonatomic) UILabel *lblBasicInfo;
@property (nonatomic) UITextView *tvOutput;
@property (nonatomic) UITextField *tfCommand;

@property (nonatomic) CGRect rcCollapsedFrame;
@property (nonatomic) CGRect rcExpandedFrame;
@property (nonatomic) NSMutableAttributedString *masLogs;

@property (nonatomic) NSString *lastCommand;

@end
#endif

@implementation DLGDebugConsoleView

#ifdef DEBUG
+ (instancetype)instance
{
    static DLGDebugConsoleView *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DLGDebugConsoleView alloc] init];
    });
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initVars];
        [self initViews];
        [self initLogs];
    }
    return self;
}

- (void)initVars {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.rcExpandedFrame = screenBounds;
    self.rcCollapsedFrame = CGRectMake(0, 0, DLG_DEBUG_CONSOLE_VIEW_SIZE, DLG_DEBUG_CONSOLE_VIEW_SIZE);
    self.lastCommand = @"";
    
    _shouldNotBeDragged = NO;
}

- (void)initViews {
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    self.frame = self.rcCollapsedFrame;
    self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
    [self initConsoleButton];
}

- (void)initConsoleButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"Console" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:button];
    NSDictionary *views = NSDictionaryOfVariableBindings(button);
    NSArray *ch = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|"
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self addConstraints:ch];
    NSArray *cv = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self addConstraints:cv];
    [button addTarget:self action:@selector(onConsoleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.btnConsole = button;
}

- (void)initLogs {
    self.masLogs = [[NSMutableAttributedString alloc] init];
}

- (void)doExpand {
    [self expand];
    [self showBasicInfoLabel];
    [self showCommandTextField];
    [self showLogsTextView];
    [self registerKeyboardNotification];
}

- (void)doCollapse {
    [self collapse];
    [self hideBasicInfoLabel];
    [self hideCommandTextField];
    [self hideLogsTextView];
    [self removeKeyboardNotification];
    self.btnConsole.hidden = NO;
}

#pragma mark - Gesture
- (void)addGesture {
    if (self.tapGesture != nil) return;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    self.tapGesture = tap;
}

- (void)removeGesture {
    if (self.tapGesture == nil) { return; }
    
    [self removeGestureRecognizer:self.tapGesture];
    self.tapGesture = nil;
}

#pragma mark - Notification
- (void)registerKeyboardNotification {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect tfFrame = self.tfCommand.frame;
    CGFloat tfMaxYInScreen = CGRectGetMinY(self.frame) + CGRectGetMaxY(tfFrame);
    CGFloat keyboardY = CGRectGetMinY(endFrame);
    if (tfMaxYInScreen <= keyboardY) return;
    
    CGRect frame = self.frame;
    CGFloat diffHeight = tfMaxYInScreen - keyboardY + 2;
    if (frame.origin.y - diffHeight >= 0) {
        frame.origin.y -= diffHeight;
        self.frame = frame;
    } else {
        CGFloat leftDiffHeight = diffHeight - frame.origin.y;
        frame.origin.y = 0;
        self.frame = frame;
        CGFloat y = CGRectGetMinY(tfFrame) - leftDiffHeight - 2;
        tfFrame.origin.y = y;
        self.tfCommand.frame = tfFrame;
        
        CGRect tvFrame = self.tvOutput.frame;
        CGFloat h = y - 2 - CGRectGetMinY(tvFrame);
        tvFrame.size.height = h;
        self.tvOutput.frame = tvFrame;
        
        [self scrollTextViewToEnd];
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    CGRect tfFrame = self.tfCommand.frame;
    CGFloat y = CGRectGetHeight(self.frame) - 2 - CGRectGetHeight(tfFrame);
    tfFrame.origin.y = y;
    self.tfCommand.frame = tfFrame;
    
    CGRect tvFrame = self.tvOutput.frame;
    CGFloat h = y - 2 - CGRectGetMinY(tvFrame);
    tvFrame.size.height = h;
    self.tvOutput.frame = tvFrame;
    
    [self scrollTextViewToEnd];
}

#pragma mark - Debug Info
- (void)addBasicInfoLabel {
    if (self.lblBasicInfo != nil) return;
    
    // Basic Info
    NSMutableString *ms = [NSMutableString string];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [ms appendFormat:@"Version %@ (%@)\nBuild Date: %s %s", version, build, __DATE__, __TIME__];
    
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:ms attributes:@{NSForegroundColorAttributeName:[UIColor yellowColor], NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
    
    //
    CGFloat width = self.frame.size.width - 10;
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 0.5f;
    CGRect rect = [mas boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:context];
    UILabel *lblBasicInfo = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, width, rect.size.height)];
    lblBasicInfo.numberOfLines = 0;
    lblBasicInfo.attributedText = mas;
    lblBasicInfo.minimumScaleFactor = context.actualScaleFactor;
    lblBasicInfo.backgroundColor = [UIColor clearColor];
    self.lblBasicInfo = lblBasicInfo;
    [self addSubview:lblBasicInfo];
}

- (void)removeBasicInfoLabel {
    if (self.lblBasicInfo != nil) {
        [self.lblBasicInfo removeFromSuperview];
        self.lblBasicInfo = nil;
    }
}

- (void)showBasicInfoLabel {
    if (self.lblBasicInfo == nil) [self addBasicInfoLabel];
    if (!self.lblBasicInfo.hidden) return;
    self.lblBasicInfo.hidden = NO;
}

- (void)hideBasicInfoLabel {
    if (self.lblBasicInfo == nil) [self addBasicInfoLabel];
    if (self.lblBasicInfo.hidden) return;
    self.lblBasicInfo.hidden = YES;
}

- (void)addLogsTextView {
    if (self.tvOutput != nil) return;
    
    CGRect lblBasicInfoFrame = self.lblBasicInfo.frame;
    CGRect tfCommandFrame = self.tfCommand.frame;
    CGFloat x = CGRectGetMinX(lblBasicInfoFrame);
    CGFloat y = CGRectGetMaxY(lblBasicInfoFrame) + 2;
    CGFloat w = CGRectGetWidth(lblBasicInfoFrame);
    CGFloat h = CGRectGetMinY(tfCommandFrame) - y - 2;
    
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    tv.editable = NO;
    tv.selectable = YES;
    tv.textColor = [UIColor whiteColor];
    tv.attributedText = self.masLogs;
    tv.scrollEnabled = YES;
    tv.bounces = YES;
    tv.backgroundColor = [UIColor clearColor];
    self.tvOutput = tv;
    [self scrollTextViewToEnd];
    [self addSubview:tv];
}

- (void)removeLogsTextView {
    if (self.tvOutput != nil) {
        [self.tvOutput removeFromSuperview];
        self.tvOutput = nil;
    }
}

- (void)showLogsTextView {
    if (self.tvOutput == nil) [self addLogsTextView];
    if (!self.tvOutput.hidden) return;
    self.tvOutput.hidden = NO;
}

- (void)hideLogsTextView {
    if (self.tvOutput == nil) [self addLogsTextView];
    
    CGRect lblBasicInfoFrame = self.lblBasicInfo.frame;
    CGRect tfCommandFrame = self.tfCommand.frame;
    CGFloat x = CGRectGetMinX(lblBasicInfoFrame);
    CGFloat y = CGRectGetMaxY(lblBasicInfoFrame) + 2;
    CGFloat w = CGRectGetWidth(lblBasicInfoFrame);
    CGFloat h = CGRectGetMinY(tfCommandFrame) - y - 2;
    self.tvOutput.frame = CGRectMake(x, y, w, h);
    [self scrollTextViewToEnd];
    
    if (self.tvOutput.hidden) return;
    self.tvOutput.hidden = YES;
}

- (void)addCommandTextField {
    if (self.tfCommand != nil) return;
    
    CGRect lblBasicInfoFrame = self.lblBasicInfo.frame;
    CGFloat w = CGRectGetWidth(lblBasicInfoFrame);
    CGFloat h = 30;
    CGFloat x = CGRectGetMinX(lblBasicInfoFrame);
    CGFloat y = self.frame.size.height - 2 - h;
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.enabled = YES;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.spellCheckingType = UITextSpellCheckingTypeNo;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.keyboardType = UIKeyboardTypeASCIICapable;
    tf.backgroundColor = [UIColor whiteColor];
    tf.textColor = [UIColor blackColor];
    tf.text = @"";
    tf.placeholder = @"Enter ? for command help";
    tf.delegate = self;
    self.tfCommand = tf;
    [self addSubview:tf];
}

- (void)removeCommandTextField {
    if (self.tfCommand != nil) {
        [self.tfCommand removeFromSuperview];
        self.tfCommand = nil;
    }
}

- (void)showCommandTextField {
    if (self.tfCommand == nil) [self addCommandTextField];
    if (!self.tfCommand.hidden) return;
    self.tfCommand.hidden = NO;
}

- (void)hideCommandTextField {
    if (self.tfCommand == nil) [self addCommandTextField];
    if ([self.tfCommand canResignFirstResponder]) [self.tfCommand resignFirstResponder];
    
    CGRect lblBasicInfoFrame = self.lblBasicInfo.frame;
    CGFloat w = CGRectGetWidth(lblBasicInfoFrame);
    CGFloat h = 30;
    CGFloat x = CGRectGetMinX(lblBasicInfoFrame);
    CGFloat y = self.rcExpandedFrame.size.height - 2 - h;
    self.tfCommand.frame = CGRectMake(x, y, w, h);
    
    if (self.tfCommand.hidden) return;
    self.tfCommand.hidden = YES;
}

#pragma mark - UITextView
- (void)scrollTextViewToEnd {
    [self.tvOutput scrollRangeToVisible:NSMakeRange(self.masLogs.length, 0)];
}

#pragma mark - Events
- (IBAction)onConsoleButtonTapped:(id)sender {
    [self doExpand];
}

#pragma mark - Expand & Collapse
- (void)expand {
    _shouldNotBeDragged = YES;
    CGRect frame = self.rcCollapsedFrame;
    frame.origin = self.frame.origin;
    self.rcCollapsedFrame = frame;
    self.btnConsole.hidden = YES;
    self.layer.cornerRadius = 0;
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.frame = self.rcExpandedFrame;
                         self.alpha = DLG_DEBUG_CONSOLE_VIEW_MAX_ALPHA;
                     }
                     completion:^(BOOL finished) {
                         self.frame = self.rcExpandedFrame;
                         self.alpha = DLG_DEBUG_CONSOLE_VIEW_MAX_ALPHA;
                     }];
    
    [self addGesture];
}

- (void)collapse {
    _shouldNotBeDragged = NO;
    CGRect frame = self.rcExpandedFrame;
    frame.origin = self.frame.origin;
    self.rcExpandedFrame = frame;
    self.layer.cornerRadius = 40;
    [self removeGesture];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.frame = self.rcCollapsedFrame;
                         self.alpha = DLG_DEBUG_CONSOLE_VIEW_MIN_ALPHA;
                     }
                     completion:^(BOOL finished) {
                         self.frame = self.rcCollapsedFrame;
                         self.alpha = DLG_DEBUG_CONSOLE_VIEW_MIN_ALPHA;
                     }];
}

#pragma mark - Gesture
- (void)handleGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint pt = [sender locationInView:self.window];
        CGRect frameInScreen = self.tfCommand.frame;
        frameInScreen.origin.x += CGRectGetMinX(self.frame);
        frameInScreen.origin.y += CGRectGetMinY(self.frame);
        if (CGRectContainsPoint(frameInScreen, pt)) {
            if ([self.tfCommand canBecomeFirstResponder]) {
                if (![self.tfCommand becomeFirstResponder]) {
                    [self log:@"Cannot open keyboard for command text field."];
                }
            }
        } else {
            [self doCollapse];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyDefault) {
        NSString *command = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.lastCommand = command;
        [self doCommand:command];
        [self.tfCommand resignFirstResponder];
        self.tfCommand.text = @"";
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length == 0 && [string compare:@" "] == NSOrderedSame) {
        textField.text = self.lastCommand;
        return NO;
    }
    return YES;
}

#pragma mark - DebugViewDelegate
- (CGRect)collapsedFrame {
    return self.rcCollapsedFrame;
}

- (CGRect)expandedFrame {
    return self.rcExpandedFrame;
}

- (void)setCollapsedFrame:(CGRect)frame {
    self.rcCollapsedFrame = frame;
    if (!_shouldNotBeDragged) {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ self.frame = self.rcCollapsedFrame; }
                         completion:^(BOOL finished) { self.frame = self.rcCollapsedFrame; }];
    }
}

- (void)setExpandedFrame:(CGRect)frame {
    self.rcExpandedFrame = frame;
    
    // Label
    CGRect lblBasicInfoFrame = self.lblBasicInfo.frame;
    lblBasicInfoFrame.size.width = self.rcExpandedFrame.size.width - 10;
    
    // TextField
    CGRect tfCommandFrame = self.tfCommand.frame;
    tfCommandFrame.size.width = lblBasicInfoFrame.size.width;
    tfCommandFrame.origin.y = self.rcExpandedFrame.size.height - tfCommandFrame.size.height - 2;
    
    // TextView
    CGRect tvOutputFrame = self.tvOutput.frame;
    tvOutputFrame.size.width = lblBasicInfoFrame.size.width;
    tvOutputFrame.size.height = tfCommandFrame.origin.y - 2 - tvOutputFrame.origin.y;
    
    if (_shouldNotBeDragged) {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.frame = self.rcExpandedFrame;
                             self.lblBasicInfo.frame = lblBasicInfoFrame;
                             self.tvOutput.frame = tvOutputFrame;
                             self.tfCommand.frame = tfCommandFrame;
                         }
                         completion:^(BOOL finished) {
                             self.frame = self.rcExpandedFrame;
                             self.lblBasicInfo.frame = lblBasicInfoFrame;
                             self.tvOutput.frame = tvOutputFrame;
                             self.tfCommand.frame = tfCommandFrame;
                         }];
    }
}

- (void)hideConsoleButtonForSeconds:(CGFloat)seconds {
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         self.alpha = 0.0f;
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             self.hidden = NO;
                             [UIView animateWithDuration:0.5f
                                              animations:^{
                                                  self.alpha = DLG_DEBUG_CONSOLE_VIEW_MAX_ALPHA;
                                              }
                                              completion:^(BOOL finished) {
                                                  self.alpha = DLG_DEBUG_CONSOLE_VIEW_MAX_ALPHA;
                                              }];
                         });
                         
                     }];
}

- (void)clearLogs {
    if (self.tvOutput != nil) {
        [self initLogs];
        self.tvOutput.attributedText = nil;
        [self scrollTextViewToEnd];
    }
}

- (void)log:(NSString *)log {
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSString *dateString = [fmt stringFromDate:date];
    NSString *prefix = [NSString stringWithFormat:@"[%@] ", dateString];
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:prefix attributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]}];
    NSString *suffix = [NSString stringWithFormat:@"%@\n", log];
    NSAttributedString *asLog = [[NSAttributedString alloc] initWithString:suffix attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.masLogs appendAttributedString:as];
    [self.masLogs appendAttributedString:asLog];
    
    if (self.tvOutput != nil) {
        self.tvOutput.attributedText = self.masLogs;
        [self scrollTextViewToEnd];
    }
}

#pragma mark - Commands
- (void)outputCommand:(NSString *)command {
    NSString *cmd = [NSString stringWithFormat:@"> %@\n", command];
    
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:cmd attributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]}];
    [self.masLogs appendAttributedString:as];
    
    if (self.tvOutput != nil) {
        self.tvOutput.attributedText = self.masLogs;
        [self scrollTextViewToEnd];
    }
}

- (void)outputCommandResult:(NSString *)result {
    NSString *r = [NSString stringWithFormat:@"%@\n", result];

    NSAttributedString *as = [[NSAttributedString alloc] initWithString:r attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.masLogs appendAttributedString:as];
    
    if (self.tvOutput != nil) {
        self.tvOutput.attributedText = self.masLogs;
        [self scrollTextViewToEnd];
    }
}

- (NSArray *)getCommands {
    NSArray *commands = [DLGDebugConsoleCommands commandsWithDelegate:self];
    return commands;
}

- (void)doCommand:(NSString *)command {
    if (command == nil || command.length == 0) return;
    
    [self outputCommand:command];
    
    NSArray *cmdparams = [command componentsSeparatedByString:@" "];
    NSString *cmd = [cmdparams firstObject];
    NSArray *params = [cmdparams subarrayWithRange:NSMakeRange(1, cmdparams.count - 1)];
    
    NSArray *commands = [self getCommands];
    __block BOOL found = NO;
    [commands enumerateObjectsUsingBlock:^(DLGDebugConsoleCommand *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.command compare:cmd] == NSOrderedSame) {
            [obj execute:params];
            found = YES;
            *stop = YES;
        }
    }];
    
    if (!found) {
        [self outputCommandResult:[NSString stringWithFormat:@"Unknown Command - %@", cmd]];
    }
}

#endif

@end
