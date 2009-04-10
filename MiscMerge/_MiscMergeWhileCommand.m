//
//  _MiscMergeWhileCommand.m
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

#import "_MiscMergeWhileCommand.h"
#import <Foundation/NSString.h>
#import "MiscMergeCommandBlock.h"
#import "MiscMergeExpression.h"

@implementation _MiscMergeWhileCommand

- init
{
    [super init];
    commandBlock = [[MiscMergeCommandBlock alloc] initWithOwner:self];
    return self;
}

- (void)dealloc
{
    [expression release];
    [commandBlock release];
    [super dealloc];
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    [self eatKeyWord:@"while" fromScanner:aScanner isOptional:NO];
    expression = [[self getExpressionFromScanner:aScanner] retain];
    [template pushCommandBlock:commandBlock];

    return YES;
}

- (void)handleEndWhileInTemplate:(MiscMergeTemplate *)template
{
    [template popCommandBlock:commandBlock];
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    MiscMergeCommandExitType exitCode = MiscMergeCommandExitNormal;

    while (exitCode != MiscMergeCommandExitBreak && [expression evaluateAsBoolWithEngine:aMerger]) {
        exitCode = [aMerger executeCommandBlock:commandBlock];
    }

    return MiscMergeCommandExitNormal;
}

@end
