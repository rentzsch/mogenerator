//
//  _MiscMergeEndforeachCommand.m
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

#import "_MiscMergeEndforeachCommand.h"
//#import <Foundation/NSUtilities.h>
#import <Foundation/NSString.h>
#import "_MiscMergeForeachCommand.h"
#import "MiscMergeCommandBlock.h"

@implementation _MiscMergeEndforeachCommand

- (void)dealloc
{
    [loopName release];
    [super dealloc];
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    _MiscMergeForeachCommand *foreachCommand = [[template currentCommandBlock] owner];

    [self eatKeyWord:@"endforeach" fromScanner:aScanner isOptional:NO];
    loopName = [[self getArgumentStringFromScanner:aScanner toEnd:NO] retain];

    if (![foreachCommand isKindOfCommandClass:@"Foreach"] ||
        ([loopName length] > 0 && [[foreachCommand loopName] length] > 0 &&
         ![loopName isEqualToString:[foreachCommand loopName]]))
    {
        [template reportParseError:@"Mismatched endforeach command"];
    }
    else
    {
        [foreachCommand handleEndForeachInTemplate:template];
    }

    return YES;
}

@end
