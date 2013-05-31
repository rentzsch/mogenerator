/*
 * Copyright (c) 2007-2008 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "DDGetoptLongParser.h"
#import "DDCliUtil.h"


@interface DDGetoptLongParser (Private)

- (NSString *) optionToKey: (NSString *) option;
- (struct option *) firstOption;
- (struct option *) currentOption;
- (void) addOption;
- (NSString *) errorOption: (NSString *) option;
- (void) handleMissingArgument: (NSString *) option
                       command: (NSString *) command;
- (void) handleArgumentNotRecognized: (NSString *) option
                             command: (NSString *) command;

@end

@implementation DDGetoptLongParser

+ (DDGetoptLongParser *) optionsWithTarget: (id) target
{
    return [[[self alloc] initWithTarget: target] autorelease];
}

- (id) initWithTarget: (id) target
{
    self = [super init];
    if (self == nil)
        return nil;
    
    mTarget = target;
    // Non-single char options start after as the last ASCII character
    mNextShortOption = 256;
    mOptionsData = [[NSMutableData alloc] initWithLength: sizeof(struct option)];
    mCurrentOption = 0;
    mUtf8Data = [[NSMutableArray alloc] init];
    mOptionString = [[NSMutableString alloc] init];
    [mOptionString appendString: @":"];
    mOptionInfoMap = [[NSMutableDictionary alloc] init];
    mGetoptFunction = getopt_long;
    
    return self;
}

- (void) dealloc
{
    [mOptionInfoMap release];
    [mOptionString release];
    [mOptionsData release];
    [mUtf8Data release];
    [mArgumentsFilename release];
    
    [super dealloc];
}

- (id) target
{
    return mTarget;
}

- (void) setTarget: (id) target
{
    mTarget = target;
}

- (void) setArgumentsFilename:(NSString *)filename
{
    mArgumentsFilename = [filename copy];
}

- (void) setGetoptLongOnly: (BOOL) getoptLongOnly
{
    if (getoptLongOnly)
        mGetoptFunction = getopt_long_only;
    else
        mGetoptFunction = getopt_long;
}

- (void) addOptionsFromTable: (DDGetoptOption *) optionTable
{
    DDGetoptOption * currentOption = optionTable;
    while ((currentOption->longOption != nil) ||
           (currentOption->shortOption != 0))
    {
        [self addLongOption: currentOption->longOption
                shortOption: currentOption->shortOption
                        key: [self optionToKey: currentOption->longOption]
            argumentOptions: currentOption->argumentOptions];
        currentOption++;
    }
}

- (void) addLongOption: (NSString *) longOption
           shortOption: (char) shortOption
                   key: (NSString *) key
       argumentOptions: (DDGetoptArgumentOptions) argumentOptions
{
    const char * utf8String = [longOption UTF8String];
    NSData * utf8Data = [NSData dataWithBytes: utf8String length: strlen(utf8String)];
    
    struct option * option = [self currentOption];
    option->name = utf8String;
    option->has_arg = argumentOptions == DDGetoptKeyValueArgument ? DDGetoptRequiredArgument : argumentOptions;
    option->flag = NULL;

    int shortOptionValue;
    if (shortOption != 0)
    {
        shortOptionValue = shortOption;
        option->val = shortOption;
        if (argumentOptions == DDGetoptRequiredArgument || argumentOptions == DDGetoptKeyValueArgument)
            [mOptionString appendFormat: @"%c:", shortOption];
        else if (argumentOptions == DDGetoptOptionalArgument)
            [mOptionString appendFormat: @"%c::", shortOption];
        else
            [mOptionString appendFormat: @"%c", shortOption];
    }
    else
    {
        shortOptionValue = mNextShortOption;
        mNextShortOption++;
        option->val = shortOptionValue;
    }
    [self addOption];
    
    NSArray * optionInfo = [NSArray arrayWithObjects:
        key, [NSNumber numberWithInt: argumentOptions], nil];
    [mOptionInfoMap setObject: optionInfo
                       forKey: [NSNumber numberWithInt: shortOptionValue]];
    
    [mUtf8Data addObject: utf8Data];
}

- (void) addLongOption: (NSString *) longOption
                   key: (NSString *) key
       argumentOptions: (DDGetoptArgumentOptions) argumentOptions
{
    [self addLongOption: longOption shortOption: 0
                    key: key argumentOptions: argumentOptions];
}

- (NSArray *) parseOptions
{
    NSProcessInfo * processInfo = [NSProcessInfo processInfo];
    NSArray * arguments = [processInfo arguments];
    
    if (mArgumentsFilename != nil) {
        if (NSClassFromString(@"NSJSONSerialization") == nil) {
            fprintf(stderr, "Warning: ignoring %s, feature supported from OS X 10.7 onwards\n", [mArgumentsFilename UTF8String]);
        } else {
            NSFileManager *fm = [NSFileManager defaultManager];
            NSString *argumentsFilePath = [[fm currentDirectoryPath] stringByAppendingPathComponent:mArgumentsFilename];
            if ([fm fileExistsAtPath:argumentsFilePath]) {
                NSError *error;
                NSArray *argumentsFromFile = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:argumentsFilePath] options:0 error:&error];
                if (argumentsFromFile != nil) {
                    NSAssert([arguments count] > 0, @"Process has no arguments (not even the command). Weird.");
                    NSString *command = [arguments objectAtIndex:0];
                    arguments = [arguments subarrayWithRange:NSMakeRange(1, [arguments count] - 1)];
                    
                    NSMutableArray *mutableArguments = [NSMutableArray arrayWithObject:command];
                    [mutableArguments addObjectsFromArray:argumentsFromFile];
                    [mutableArguments addObjectsFromArray:arguments];
                    arguments = [NSArray arrayWithArray:mutableArguments];
                } else {
                    fprintf(stderr, "Error reading %s: %s\n", [mArgumentsFilename UTF8String], [[error localizedDescription] UTF8String]);
                    exit(1);
                }
            }
        }
    }

    NSString * command = [processInfo processName];
    return [self parseOptionsWithArguments: arguments command: command];
}

- (NSArray *) parseOptionsWithArguments: (NSArray *) arguments
                                command: (NSString *) command
{
    NSUInteger argc = [arguments count];
    char ** argv = alloca(sizeof(char *) * argc);
    NSUInteger i;
    for (i = 0; i < argc; i++)
    {
        NSString * argument = [arguments objectAtIndex: i];
        argv[i] = (char *) [argument UTF8String];
    }
    argv[i] = 0;
    
    // Make sure list is NULL terminated
    struct option * option = [self currentOption];
    option->name = NULL;
    option->has_arg = 0;
    option->flag = NULL;
    option->val = 0;
    
    const char * optionString = [mOptionString UTF8String];
    struct option * options = [self firstOption];
    int ch;
    opterr = 1;
    
    int longOptionIndex = -1;
    while ((ch = mGetoptFunction((int)argc, argv, optionString, options, &longOptionIndex)) != -1)
    {
        NSString * last_argv = [NSString stringWithUTF8String: argv[optind-1]];
        if (ch == ':')
        {
            [self handleMissingArgument: last_argv command: command];
            return nil;
        }
        else if (ch == '?')
        {
            [self handleArgumentNotRecognized: last_argv command: command];
            return nil;
        }
        
        NSString * nsoptarg = nil;
        if (optarg != NULL)
            nsoptarg = [NSString stringWithUTF8String: optarg];
        
        NSArray * optionInfo = [mOptionInfoMap objectForKey: [NSNumber numberWithInt: ch]];
        NSAssert(optionInfo != nil, @"optionInfo should not be nil");

        if (optionInfo != nil)
        {
            NSString * key = [optionInfo objectAtIndex: 0];
            int argumentOptions = [[optionInfo objectAtIndex: 1] intValue];
            if (argumentOptions == DDGetoptNoArgument)
                [mTarget setValue: [NSNumber numberWithBool: YES] forKey: key];
            else if (argumentOptions == DDGetoptKeyValueArgument)
            {
                // Split the arguement on the '=' sign
                NSArray *pair = [nsoptarg componentsSeparatedByString:@"="];
                // Build a keypath from the argument and the new key
                NSString *keypath = [NSString stringWithFormat:@"%@.%@", key, [pair objectAtIndex:0]];
                
                // If it is a number or a boolean, we'll parse that out
                NSString *value = [pair objectAtIndex:1];
                id parsedValue = value;
                // Looks like a boolean?
                if ([value isCaseInsensitiveLike:@"true"] || [value isCaseInsensitiveLike:@"false"])
                {
                    parsedValue = [NSNumber numberWithBool:[value boolValue]];
                }
                else
                {
                    // Looks like a number?
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setAllowsFloats:YES];
                    NSNumber *numberValue = [formatter numberFromString:value];
                    if (numberValue)
                    {
                        parsedValue = numberValue;
                    }
                    [formatter release];
                }
                
                [mTarget setValue:parsedValue forKeyPath:keypath];
            }
            else
                [mTarget setValue: nsoptarg forKey: key];
        }
    }
    
    NSRange range = NSMakeRange(optind, argc - optind);
    return [arguments subarrayWithRange: range];
}

@end

@implementation DDGetoptLongParser (Private)

- (NSString *) optionToKey: (NSString *) option
{
    NSScanner * scanner = [NSScanner scannerWithString: option];
    [scanner setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString: @"-"]];
    NSMutableString * key = [NSMutableString string];
    NSString * string = nil;
    BOOL caps = NO;
    while ([scanner scanUpToString: @"-" intoString: &string])
    {
        if (caps)
            string = [string capitalizedString];
        [key appendString: string];
        caps = YES;
    }
    return key;
}

- (struct option *) firstOption
{
    struct option * options = [mOptionsData mutableBytes];
    return options;
}

- (struct option *) currentOption
{
    struct option * options = [mOptionsData mutableBytes];
    return &options[mCurrentOption];
}

- (void) addOption
{
    [mOptionsData increaseLengthBy: sizeof(struct option)];
    mCurrentOption++;
}

- (NSString *) errorOption: (NSString *) option
{
    if (![option hasPrefix: @"-"])
        return [NSString stringWithFormat: @"%c", optopt];
    else
        return option;
}

- (void) handleMissingArgument: (NSString *) option
                       command: (NSString *) command
{
    option = [self errorOption: option];
    
    if ([mTarget respondsToSelector: @selector(optionIsMissingArgument:)])
    {
        [mTarget optionIsMissingArgument: option];
    }
    else
    {
        ddfprintf(stderr, @"%@: option `%@' requires an argument\n",
                  command, option);
        ddfprintf(stderr, @"Try `%@ --help` for more information.\n", command);
    }
}

- (void) handleArgumentNotRecognized: (NSString *) option
                             command: (NSString *) command
{
    option = [self errorOption: option];
    if ([mTarget respondsToSelector: @selector(optionIsNotRecognized:)])
    {
        [mTarget optionIsNotRecognized: option];
    }
    else
    {
        ddfprintf(stderr, @"%@: unrecognized option `%@'\n",
                  command, option);
        ddfprintf(stderr, @"Try `%@ --help` for more information.\n", command);
    }
}

@end

