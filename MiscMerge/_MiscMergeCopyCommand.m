//
//  _MiscMergeCopyCommand.m
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

#import "_MiscMergeCopyCommand.h"
#import "NSString+MiscAdditions.h"
#import "NSScanner+MiscMerge.h"

@implementation _MiscMergeCopyCommand

- (void)dealloc
{
    [theText release];
    [super dealloc];
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    if (![self eatKeyWord:@"copy" fromScanner:aScanner isOptional:NO]) return NO;

    theText = [[[aScanner remainingString] stringByTrimmingLeadWhitespace] retain];

    return YES;
}

/*" Special method used by the template "*/
- (void)parseFromRawString:(NSString *)aString
{
    theText = [aString retain];
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    [aMerger appendToOutput:theText];
    return MiscMergeCommandExitNormal;
}

@end
