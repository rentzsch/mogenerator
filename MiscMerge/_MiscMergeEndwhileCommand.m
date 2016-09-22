//
//    _MiscMergeEndwhileCommand.m
//
//	Written by Carl Lindberg
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

#import "_MiscMergeEndwhileCommand.h"
#import <Foundation/NSString.h>
#import "_MiscMergeWhileCommand.h"
#import "MiscMergeCommandBlock.h"

@implementation _MiscMergeEndwhileCommand

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    _MiscMergeWhileCommand *whileCommand = [[template currentCommandBlock] owner];

    [self eatKeyWord:@"endwhile" fromScanner:aScanner isOptional:NO];

    if (![whileCommand isKindOfCommandClass:@"While"])
    {
        [template reportParseError:@"Mismatched endwhile command"];
    }
    else
    {
        [whileCommand handleEndWhileInTemplate:template];
    }

    return YES;
}

@end
