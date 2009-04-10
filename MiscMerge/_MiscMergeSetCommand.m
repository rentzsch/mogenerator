//
//  _MiscMergeSetCommand.m
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

#import "_MiscMergeSetCommand.h"
#import "MiscMergeExpression.h"
#import "NSString+MiscAdditions.h"

@implementation _MiscMergeSetCommand

- (void)dealloc
{
    [field1 release];
    [expression release];
    [super dealloc];
}

// Override this to set what the command string should be
- (NSString *)commandString
{
    return @"set";
}

// Override this to provide the correct set method for the generated value
- (void)setValue:(id)value forMerge:(MiscMergeEngine *)aMerger
{
    [aMerger setGlobalValue:value forKey:field1];
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template;
{
    [self eatKeyWord:[self commandString] fromScanner:aScanner isOptional:NO];

    field1 = [self getArgumentStringFromScanner:aScanner toEnd:NO];
    field1 = [[field1 stringByTrimmingWhitespace] retain];

    if ( ![self eatKeyWord:@"=" fromScanner:aScanner isOptional:YES] )
        [self error_conditional:[NSString stringWithFormat:@"%@ requires operator to be an =.", [self commandString]]];

    expression = [[self getExpressionFromScanner:aScanner] retain];

    return YES;
}


- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    id value;
    
    if ( [expression isKindOfClass:[MiscMergeListExpression class]] )
        value = [(MiscMergeListExpression *)expression evaluateAsListWithEngine:aMerger];
    else
        value = [expression evaluateWithEngine:aMerger];

    [self setValue:value forMerge:aMerger];
    return MiscMergeCommandExitNormal;
}

@end


@implementation _MiscMergeSetglobalCommand

- (NSString *)commandString
{
    return @"setglobal";
}

@end


@implementation _MiscMergeSetengineCommand

- (NSString *)commandString
{
    return @"setengine";
}

- (void)setValue:(id)value forMerge:(MiscMergeEngine *)aMerger
{
    [aMerger setEngineValue:value forKey:field1];
}

@end


@implementation _MiscMergeSetmergeCommand

- (NSString *)commandString
{
    return @"setmerge";
}

- (void)setValue:(id)value forMerge:(MiscMergeEngine *)aMerger
{
    [aMerger setMergeValue:value forKey:field1];
}

@end


@implementation _MiscMergeSetlocalCommand

- (NSString *)commandString
{
    return @"setlocal";
}

- (void)setValue:(id)value forMerge:(MiscMergeEngine *)aMerger
{
    [aMerger setLocalValue:value forKey:field1];
}

@end


///{-wolf
#if 0
@interface _MiscMergeIdentifyCommand : _MiscMergeSetCommand
@end

@implementation _MiscMergeIdentifyCommand

- (NSString *)commandString
{
    return @"identify";
}

@end
#endif
///}wolf

