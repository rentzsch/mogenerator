//
//  MiscMergeDriver.h
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

#import <Foundation/NSObject.h>

@class NSArray;
@class MiscMergeTemplate, MiscMergeEngine;

@interface MiscMergeDriver : NSObject
{
    MiscMergeTemplate *template;  /*" MiscMergeTemplate for merging "*/
    MiscMergeEngine   *engine;    /*" The merge engine to be used for merges "*/
    NSArray           *dataArray; /*" List of MiscDictionaries used for merges "*/
    BOOL              merging;    /*" YES if merging, NO if not "*/

    int _mergeLoopIndex;          /*" Index to #{dataArray} when merge is in progress "*/
}

/*" Accessing the template "*/
- (MiscMergeTemplate *)template;
- (void)setTemplate:(MiscMergeTemplate *)aTemplate;

/*" Accessing the data "*/
- (NSArray *)mergeData;
- (void)setMergeData:(NSArray *)aList;

/*" Performing a merge "*/
- (NSArray *)doMerge:sender;

/*" Accessing the engine "*/
- (MiscMergeEngine *)engine;
- (void)setEngine:(MiscMergeEngine *)anEngine;

@end
