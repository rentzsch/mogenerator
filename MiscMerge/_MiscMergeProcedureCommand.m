//
//  _MiscMergeProcedureCommand.m
//
//	Written by Don Yacktman and Carl Lindberg
//
//	Copyright 2001-2004 by Don Yacktman and Carl Lindberg.
//	All rights reserved.
//
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//	

#import "_MiscMergeProcedureCommand.h"
#import <Foundation/Foundation.h>
#import "MiscMergeEngine.h"
#import "MiscMergeTemplate.h"
#import "MiscMergeCommandBlock.h"
#import "NSNull.h"
#import "NSScanner+MiscMerge.h"

typedef enum _ArgTypes {
    RequiredArg = 1,
    OptionalArg = 2,
    ArrayArg = 3
} ArgTypes;

@implementation _MiscMergeProcedureCommand

- init
{
    [super init];
    commandBlock = [[MiscMergeCommandBlock alloc] initWithOwner:self];
    argumentArray = [[NSMutableArray alloc] init];
    argumentTypes = [[NSMutableArray alloc] init];
    return self;
}

- (void)dealloc
{
    [commandBlock release];
    [procedureName release];
    [argumentArray release];
    [argumentTypes release];
    [super dealloc];
}

- (NSString *)procedureName
{
    return procedureName;
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    NSString *argName;
    BOOL optArgProcessing = NO;

    [self eatKeyWord:@"procedure" fromScanner:aScanner isOptional:NO];
    procedureName = [[self getArgumentStringFromScanner:aScanner toEnd:NO] retain];

    while ((argName = [self getArgumentStringFromScanner:aScanner toEnd:NO])) {
        if ( [argName hasSuffix:@"?"] ) {
            optArgProcessing = YES;
            argName = [argName substringToIndex:([argName length] - 1)];
            [argumentTypes addObject:[NSNumber numberWithInt:OptionalArg]];
        }
        else if ( [argName hasSuffix:@"..."] ) {
            argName = [argName substringToIndex:([argName length] - 3)];
            [aScanner remainingString];
            [argumentTypes addObject:[NSNumber numberWithInt:ArrayArg]];
        }
        else if ( optArgProcessing ) {
            [template reportParseError:@"%@:  Can only specify optional arguments after an initial optional argument:  \"%@\".", procedureName, argName];
            return NO;
        }
        else {
            [argumentTypes addObject:[NSNumber numberWithInt:RequiredArg]];
        }

        [argumentArray addObject:argName];
    }

    [template pushCommandBlock:commandBlock];

    return YES;
}

- (void)handleEndProcedureInTemplate:(MiscMergeTemplate *)template
{
    [template popCommandBlock:commandBlock];
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    /* Just want to register ourselves to the engine */
    NSString *symbolName = [NSString stringWithFormat:@"_MiscMergeProcedure%@", procedureName];
    [[aMerger userInfo] setObject:self forKey:symbolName];
    return MiscMergeCommandExitNormal;
}

/* The *real* execute; messaged from the call command */
- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger arguments:(NSArray *)passedArgArray
{
    NSInteger argumentIndex = 0, argumentCount = [argumentArray count];
    NSInteger passedIndex = 0, passedCount = [passedArgArray count];
    NSInteger addToArgIndex = 0;
    NSMutableDictionary *procedureContext = [NSMutableDictionary dictionary];

    for ( ; passedIndex < passedCount; passedIndex++ ) {
        NSString *argName;
        int argType;

        id argValue = [passedArgArray objectAtIndex:passedIndex];

        if ( argumentIndex >= argumentCount ) {
            NSLog(@"%@: More arguments than declared.", procedureName);
            break;
        }

        argName = [argumentArray objectAtIndex:argumentIndex];
        argType = [[argumentTypes objectAtIndex:argumentIndex] intValue];
        
        switch ( argType ) {
            case RequiredArg:
            case OptionalArg:
                if ( argValue == [NSNull null] )
                    argValue = @"";
                [procedureContext setObject:argValue forKey:argName];
                argumentIndex++;
                break;

            case ArrayArg:
            {
                NSMutableArray *array = [procedureContext objectForKey:argName];
                if ( array == nil ) {
                    array = [NSMutableArray array];
                    [procedureContext setObject:array forKey:argName];
                }
                addToArgIndex = 1;
                [array addObject:argValue];
            }
                break;
        }
    }

    argumentIndex += addToArgIndex;

    /* Insure any optional parameters get set to "" and log any required parameters there were not
        gotten in the call. */
    if ( argumentIndex < argumentCount ) {
        NSMutableString *string = [NSMutableString string];
        
        for ( ; argumentIndex < argumentCount; argumentIndex++ ) {
            NSString *argName = [argumentArray objectAtIndex:argumentIndex];
            int argType = [[argumentTypes objectAtIndex:argumentIndex] intValue];

            if ( argType == OptionalArg ) {
                [procedureContext setObject:@"" forKey:argName];
            }
            else if ( argType == ArrayArg ) {
                [procedureContext setObject:[NSArray array] forKey:argName];
            }
            else {
                if ( [string length] > 0 )
                    [string appendString:@", "];
                [string appendString:argName];
            }
        }

        if ( [string length] > 0 )
            NSLog(@"%@: Missing arguments for: %@", procedureName, string);
    }


    [aMerger addContextObject:procedureContext andSetLocalSymbols:YES];
    [aMerger executeCommandBlock:commandBlock];
    [aMerger removeContextObject:procedureContext];

    return MiscMergeCommandExitNormal;
}

@end

