//
//  _MiscMergeLoopCommand.m
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

#import "_MiscMergeLoopCommand.h"
//#import <Foundation/NSUtilities.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSCharacterSet.h>
#import "MiscMergeCommandBlock.h"
#import "MiscMergeExpression.h"
#import "MiscMergeFunctions.h"

@implementation _MiscMergeLoopCommand

- init
{
    [super init];
    commandBlock = [[MiscMergeCommandBlock alloc] initWithOwner:self];
    return self;
}

- (void)dealloc
{
    [indexName release];
    [loopName release];
    [commandBlock release];
    [startKey release];
    [stopKey release];
    [stepKey release];
    [super dealloc];
}

- (NSString *)validateStep:(int)step
{
    if (step == 0)
    {
        return [NSString stringWithFormat:@"%@: Loop %@ is infinite (no step value).",
            [self class], loopName];
    }

    return nil;
}

- (NSString *)validateStart:(int)start stop:(int)stop step:(int)step
{
    NSString *error = nil;

    if (step == 0)
    {
        step = (start <= stop)? 1 : -1;
        error = [NSString stringWithFormat:@"%@: Loop %@ is infinite (no step value).  Setting to %d.\n",
            [self class], loopName, step];
    }

    if (((start < stop) && (step < 0)) || ((start > stop) && (step > 0)))
    {
        return [NSString stringWithFormat:@"%@%@: Loop %@ is probably longer than you want. (start,end,step) = (%d,%d,%d).",
                              error?error:@"", [self class], loopName, start, stop, step];
    }

    return error;
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    [self eatKeyWord:@"loop" fromScanner:aScanner isOptional:NO];

    indexName  = [[self getArgumentStringFromScanner:aScanner toEnd:NO] retain];
    startKey   = [[self getPrimaryExpressionFromScanner:aScanner] retain];
    stopKey    = [[self getPrimaryExpressionFromScanner:aScanner] retain];
    stepKey    = [[self getPrimaryExpressionFromScanner:aScanner] retain];
    loopName   = [[self getArgumentStringFromScanner:aScanner toEnd:NO] retain];

    [template pushCommandBlock:commandBlock];

    return YES;
}

- (NSString *)loopName
{
    return loopName;
}

- (void)handleEndLoopInTemplate:(MiscMergeTemplate *)template
{
    [template popCommandBlock:commandBlock];
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    NSMutableDictionary *loopContext = [NSMutableDictionary dictionary];
    int theIndex;
    int start = [startKey evaluateAsIntWithEngine:aMerger];
    int stop  = [stopKey evaluateAsIntWithEngine:aMerger];
    int step  = [stepKey evaluateAsIntWithEngine:aMerger];
    MiscMergeCommandExitType exitCode = MiscMergeCommandExitNormal;

    NSString *error = [self validateStart:start stop:stop step:step];
    if (error) {
        NSLog(@"%@", error);
    }

    if (step == 0)
        step = (start <= stop)? 1 : -1;

    [aMerger addContextObject:loopContext];
    for (theIndex = start; (exitCode != MiscMergeCommandExitBreak) && ((step > 0)? (theIndex <= stop) : (theIndex >= stop)); theIndex += step)
    {
        [loopContext setObject:[NSString stringWithFormat:@"%d", theIndex] forKey:indexName];
        exitCode = [aMerger executeCommandBlock:commandBlock];
    }
    [aMerger removeContextObject:loopContext];
    return MiscMergeCommandExitNormal;
}

@end

