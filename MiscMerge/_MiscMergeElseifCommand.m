//
//  _MiscMergeElseifCommand.m
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

#import "_MiscMergeElseifCommand.h"
//#import <Foundation/NSUtilities.h>
#import <stdlib.h> //for NULL on OSXPB
#import "NSScanner+MiscMerge.h"
#import "MiscMergeCommandBlock.h"

@implementation _MiscMergeElseifCommand

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    MiscMergeCommandBlock *parentIfBlock = [template currentCommandBlock];
    _MiscMergeIfCommand *parentIfCommand = [parentIfBlock owner];

    if (![parentIfCommand isKindOfCommandClass:@"If"])
    {
        [template reportParseError:@"Mismatched elseif command"];
    }
    else
    {
        /*
         * This is a tad messy.  We are already included in the parent if's
         * "true" block, so we need to remove it from there, apply an
         * "else", then add ourselves to the "else" block.  This way
         * we convert the "elseif" to a nested "if" inside the parent's else
         * block.
         */
        [parentIfBlock removeCommand:self];
        [parentIfCommand handleElseInTemplate:template];
        [[template currentCommandBlock] addCommand:self];
    }

    /*
     * Scan past the "else", so we can treat the rest as a normal if
     * statement. A bit of a hack, but it works.
     */
    [aScanner scanString:@"else" intoString:NULL];
    return [super parseFromScanner:aScanner template:template];
}

/*
 * Override to pop our block, and pop our parent's block as well (since we
 * are nested inside another if statement).  If parent is another elseif
 * command, then the process will repeat until we get to the original if
 * command.
 */
- (void)handleEndifInTemplate:(MiscMergeTemplate *)template
{
    _MiscMergeIfCommand *parentIfCommand;

    // first pop our command block
    [super handleEndifInTemplate:template];

    // then pop our parent's block
    parentIfCommand = [[template currentCommandBlock] owner];
    if (![parentIfCommand isKindOfCommandClass:@"If"])
    {
        [template reportParseError:@"Mismatched endif command"];
    }
    else
    {
        [parentIfCommand handleEndifInTemplate:template];
    }
}

@end
