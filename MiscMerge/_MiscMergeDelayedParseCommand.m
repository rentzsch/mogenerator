//
//  _MiscMergeDelayedParseCommand.m
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

#import "_MiscMergeDelayedParseCommand.h"
#import <Foundation/NSString.h>
#import "MiscMergeEngine.h"
#import "MiscMergeTemplate.h"
#import "MiscMergeCommand.h"

@implementation _MiscMergeDelayedParseCommand

- (void)dealloc
{
    [unparsedCommand release];
    [super dealloc];
}

- (BOOL)parseFromString:(NSString *)aString template:(MiscMergeTemplate *)template
{
    unparsedCommand = [aString copy];
    return YES;
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    MiscMergeTemplate *myTemplate = [aMerger template];
    Class templateClass = [myTemplate class];
    Class mergerClass   = [aMerger class];
    Class commandClass;
    MiscMergeTemplate *newTemplate = [[templateClass alloc] init];
    MiscMergeEngine *newEngine = [[mergerClass alloc] init];
    MiscMergeCommand *newCommand;
    NSString *result;

    [newTemplate setStartDelimiter:[myTemplate startDelimiter]
                      endDelimiter:[myTemplate endDelimiter]];
    [newTemplate parseString:unparsedCommand];

    [newEngine setTemplate:newTemplate];
    [newEngine setParentMerge:aMerger];
    [newEngine setMainObject:[aMerger mainObject]];

    result = [newEngine execute:self];

    /* Hrm. */
    commandClass = [myTemplate classForCommand:result];
    newCommand = [[commandClass alloc] init];
    [newCommand parseFromString:result template:myTemplate];
    [aMerger executeCommand:newCommand];

    [newCommand release];
    [newTemplate release];
    [newEngine release];
    return MiscMergeCommandExitNormal;
}

@end

