//
//  _MiscMergeIfCommand.m
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

#import "_MiscMergeIfCommand.h"
//#import <Foundation/NSUtilities.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSScanner.h>
#import "MiscMergeCommandBlock.h"
#import "MiscMergeExpression.h"

@implementation _MiscMergeIfCommand

- (id)init
{
    [super init];
    trueBlock = [[MiscMergeCommandBlock alloc] initWithOwner:self];
    return self;
}

- (void)dealloc
{
    [trueBlock release];
    [elseBlock release];
    [expression release];
    [super dealloc];
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    [self eatKeyWord:@"if" fromScanner:aScanner isOptional:NO];
    expression = [[self getExpressionFromScanner:aScanner] retain];
    [template pushCommandBlock:trueBlock];
    return YES;
}

- (void)handleElseInTemplate:(MiscMergeTemplate *)template
{
    if (elseBlock == nil)
        elseBlock = [[MiscMergeCommandBlock alloc] initWithOwner:self];
    [template popCommandBlock:trueBlock];
    [template pushCommandBlock:elseBlock];
}

- (void)handleEndifInTemplate:(MiscMergeTemplate *)template
{
    [template popCommandBlock];
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    if ([self evaluateExpressionInMerger:aMerger])
        return [aMerger executeCommandBlock:trueBlock];
    else if (elseBlock)
        return [aMerger executeCommandBlock:elseBlock];
    return MiscMergeCommandExitNormal;
}


- (BOOL)evaluateExpressionInMerger:(MiscMergeEngine *)anEngine
{
    return [expression evaluateAsBoolWithEngine:anEngine];
}

@end

