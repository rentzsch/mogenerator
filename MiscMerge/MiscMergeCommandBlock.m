//
//  MiscMergeCommandBlock.m
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

#import "MiscMergeCommandBlock.h"
#import <Foundation/NSArray.h>
#import "MiscMergeCommand.h"

@implementation MiscMergeCommandBlock
/*"
 * A MiscMergeCommandBlock is a wrapper around an NSArray of
 * MiscMergeCommands.  A MiscMergeTemplate has a top-level command block,
 * and MiscMergeCommand subclasses that perform logic surrounding arbitrary
 * command sequences (such as 'if' statements and loops) can have their own
 * MiscMergeCommandBlocks that can be substituted as the "current" block in
 * a MiscMergeTemplate during parsing.
 *
 * An "owner" can be set so that the MiscMergeCommand representing the
 * current block can be derived if necessary.
 *
 * During execution, commands should use the MiscMergeEngine method
 * -#executeCommandBlock: to execute the commands contained in the block.
"*/

/*"
 * The designated initializer.  anOwner is not retained.
"*/
- initWithOwner:(id)anOwner
{
    commandArray = [[NSMutableArray alloc] init];
    owner = anOwner;
    return self;
}

- init
{
    return [self initWithOwner:nil];
}

- (void)dealloc
{
    [commandArray release];
    [super dealloc];
}

/*" Returns the NSArray of MiscMergeCommands "*/
- (NSArray *)commandArray
{
    return commandArray;
}

/*"
 * Returns the "owner" (usually a MiscMergeCommand subclass) set by
 * -#initWithOwner:.
"*/
- (id)owner
{
    return owner;
}

/*" Adds a MiscMergeCommand to the block. "*/
- (void)addCommand:(MiscMergeCommand *)command
{
    [commandArray addObject:command];
}

/*"
 * Removes command from the internal commandArray.  This method should only
 * be used in rare circumstances, such as when it's necessary to move a
 * command from one block to another.
"*/
- (void)removeCommand:(MiscMergeCommand *)command
{
    [commandArray removeObjectIdenticalTo:command];
}

@end
