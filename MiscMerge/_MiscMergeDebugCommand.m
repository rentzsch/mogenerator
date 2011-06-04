//
//  _MiscMergeDebugCommand.m
//
//	Written by Doug McClure
//
//	Copyright 2001-2004 by Don Yacktman and Doug McClure.
//	All rights reserved.
//
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//

#import "_MiscMergeDebugCommand.h"
#import <Foundation/Foundation.h>
#import "NSString+MiscAdditions.h"
#import "NSScanner+MiscMerge.h"

@implementation _MiscMergeDebugCommand

- (void)dealloc
{
    [theText release];
    [super dealloc];
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    if (![self eatKeyWord:@"debug" fromScanner:aScanner isOptional:NO]) return NO;

    theText = [[[aScanner remainingString] stringByTrimmingLeadWhitespace] retain];

    return YES;
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    fwrite([theText cStringUsingEncoding:NSUTF8StringEncoding], 1, [theText lengthOfBytesUsingEncoding:NSUTF8StringEncoding], stderr);
    if (![theText hasSuffix:@"\n"])
        fputc('\n', stderr);

    return MiscMergeCommandExitNormal;
}

@end
