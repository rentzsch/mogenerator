//
//  _MiscMergeEndloopCommand.m
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

#import "_MiscMergeEndloopCommand.h"
//#import <Foundation/NSUtilities.h>
#import <Foundation/NSString.h>
#import "_MiscMergeLoopCommand.h"
#import "MiscMergeCommandBlock.h"

@implementation _MiscMergeEndloopCommand

- (void)dealloc
{
    [loopName release];
    [super dealloc];
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    _MiscMergeLoopCommand *loopCommand = [[template currentCommandBlock] owner];

    [self eatKeyWord:@"endloop" fromScanner:aScanner isOptional:NO];
    loopName = [[self getArgumentStringFromScanner:aScanner toEnd:NO] retain];

    if (![loopCommand isKindOfCommandClass:@"Loop"] ||
        ([loopName length] > 0 && [[loopCommand loopName] length] > 0 &&
         ![loopName isEqualToString:[loopCommand loopName]]))
    {
        [template reportParseError:@"Mismatched endloop command"];
    }
    else
    {
        [loopCommand handleEndLoopInTemplate:template];
    }

    return YES;
}

@end
