//
//  _MiscMergeBreakCommand.h
//
//	Written by Doug McClure
//
//	Copyright 2002-2004 by Don Yacktman and Doug McClure.
//	All rights reserved.
//
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//

#import "_MiscMergeBreakCommand.h"

@implementation _MiscMergeBreakCommand

- (BOOL)parseFromString:(NSString *)aString template:(MiscMergeTemplate *)template {
    return YES;
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger {
    return MiscMergeCommandExitBreak;
}

@end
