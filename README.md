# DLGDebugConsole
A debug console in application on iOS.  
It's not powerful but maybe useful.

## 0. Screenshots
|![](https://github.com/DeviLeo/Screenshots/blob/master/DLGDebugConsole/DLGDebugConsoleDemo1.gif)|![](https://github.com/DeviLeo/Screenshots/blob/master/DLGDebugConsole/DLGDebugConsoleDemo2.gif)|![](https://github.com/DeviLeo/Screenshots/blob/master/DLGDebugConsole/DLGDebugConsoleDemo3.gif)|
|:---------:|:---:|:---:|
|console|usr command|net command|

## 1. Structure
+ base
 - DLGDebugConsoleCommand           **(Command base class)**
 - DLGDebugConsoleCommandParameter  **(Command parameter base class)**
+ category
 - UIWindow+DLGDebugConsole         **(Define variables and events in UIWindow)**
+ view
 - DLGDebugConsoleView              **(Console button and main view)**
 - DLGDebugConsoleViewDelegate      **(Connection between console view and command)**
+ commands
 - DLGDebugConsoleCommandHelp       **(Help command for list all commands)**
 - DLGDebugConsoleCommandConsole    **(Console command for changing console view's properties)**
 - DLGDebugConsoleCommandShowFrame  **(ShowFrame command for showing window, status bar, navigation bar, tab bar, current view's frame)**
- DLGDebugConsole         **(Main)**
- DLGDebugConsoleAgent    **(Connection between command and other classes in project)**\*
- DLGDebugConsoleCommands **(Commands initialization)**\*\*  

\* Add codes that showing or changing something in other classes using commands.  
\*\* Add commands' initialization codes in *DLGDebugConsoleCommands* file.

## 2. Usage
#### (1) Copy codes  
Copy [DLGDebugConsole folder](https://github.com/DeviLeo/DLGDebugConsole/tree/master/DLGDebugConsole) into your project.

#### (2) Write a command
Writing a command is complicated. Be patient. Here is a sample.  

***DLGDebugConsoleCommandSample.h***
```Objective-C
#import "DLGDebugConsoleCommand.h"

// Inherited from DLGDebugConsoleCommand class
@interface DLGDebugConsoleCommandSample : DLGDebugConsoleCommand

@end
```

***DLGDebugConsoleCommandSample.m***
```Objective-C
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
}

- (void)initCommand {
    // Put your command's initialization here
}

- (BOOL)execute:(NSArray *)params {
    // Put what this command want to do here
    return YES;
}

@end
```

***Implement "initParameters" method***
There are two parameters, "-p" and "-s".
```Objective-C
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
```

***Implement "initCommand" method***
```Objective-C
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
```

***Implement "execute" method***
```Objective-C
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
```

***Implement "entireValueFromParams" method used in "execute" method***
```Objective-C
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
```

Finally, add "DLGDebugConsoleCommandSample" initialization into DLGDebugConsoleCommands class.
***DLGDebugConsoleCommands.h***
```Objective-C
#import <Foundation/Foundation.h>

#ifdef DEBUG

#import "DLGDebugConsoleCommandHelp.h"
#import "DLGDebugConsoleCommandConsole.h"
#import "DLGDebugConsoleCommandShowFrame.h"

// Import commands' headers here
#import "DLGDebugConsoleCommandSample.h" // New added

#endif

@interface DLGDebugConsoleCommands : NSObject

#ifdef DEBUG

+ (NSArray *)commandsWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate;

#endif

@end
```

***DLGDebugConsoleCommands.m***
```Objective-C
#import "DLGDebugConsoleCommands.h"

@implementation DLGDebugConsoleCommands

#ifdef DEBUG

+ (NSArray *)commandsWithDelegate:(id<DLGDebugConsoleViewDelegate>)delegate {
    NSArray *commands = @[
                          [[DLGDebugConsoleCommandHelp alloc] initWithDelegate:delegate],
                          [[DLGDebugConsoleCommandConsole alloc] initWithDelegate:delegate],
                          [[DLGDebugConsoleCommandShowFrame alloc] initWithDelegate:delegate],
                          // Add commands' initialization here
                          [[DLGDebugConsoleCommandSample alloc] initWithDelegate:delegate] // New added
                          ];
    return commands;
}

#endif

@end
```

OK, now you can use "spl" command in the console.

See [Example project](https://github.com/DeviLeo/DLGDebugConsole/tree/master/Example) for more usage details.

## 3. Required frameworks and libraries
None.

## 4. References
None.

## 5. License
See [LICENSE](https://github.com/DeviLeo/DLGDebugConsole/blob/master/LICENSE "MIT License")
