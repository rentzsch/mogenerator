//
//  _MiscMergeElseCommand.m
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

#import "_MiscMergeElseCommand.h"
//#import <Foundation/NSUtilities.h>
#import "_MiscMergeIfCommand.h"
#import "MiscMergeCommandBlock.h"

@implementation _MiscMergeElseCommand

- (BOOL)parseFromString:(NSString *)aString template:(MiscMergeTemplate *)template
{
    _MiscMergeIfCommand *ifCommand = [[template currentCommandBlock] owner];

    if (![ifCommand isKindOfCommandClass:@"If"])
    {
        [template reportParseError:@"Mismatched else command"];
    }
    else
    {
        [ifCommand handleElseInTemplate:template];
    }

    return YES;
}

@end
