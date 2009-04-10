//
//  _MiscMergeForeachCommand.m
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

#import "_MiscMergeForeachCommand.h"
//#import <Foundation/NSUtilities.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSValue.h>
#import "MiscMergeCommandBlock.h"
#import "MiscMergeEngine.h"
#import "MiscMergeExpression.h"

@implementation _MiscMergeForeachCommand

- init
{
    [super init];
    commandBlock = [[MiscMergeCommandBlock alloc] initWithOwner:self];
    return self;
}

- (void)dealloc
{
    [itemName release];
    [arrayField release];
    [arrayExpression release];
    [loopName release];
    [commandBlock release];
    [super dealloc];
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    [self eatKeyWord:@"foreach" fromScanner:aScanner isOptional:NO];

    itemName = [[self getArgumentStringFromScanner:aScanner toEnd:NO] retain];
    //arrayField = [[self getArgumentStringFromScanner:aScanner toEnd:NO quotes:&arrayQuote] retain];
    arrayExpression = [[self getExpressionFromScanner:aScanner] retain];
    loopName = [[self getArgumentStringFromScanner:aScanner toEnd:NO] retain];

    [template pushCommandBlock:commandBlock];

    return YES;
}

- (NSString *)loopName
{
    return loopName;
}

- (void)handleEndForeachInTemplate:(MiscMergeTemplate *)template
{
    [template popCommandBlock:commandBlock];
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    //id itemArray = [aMerger valueForField:arrayField quoted:arrayQuote];
    id itemArray;

    if ( [arrayExpression isKindOfClass:[MiscMergeListExpression class]] )
        itemArray = [(MiscMergeListExpression *)arrayExpression evaluateAsListWithEngine:aMerger];
    else
        itemArray = [arrayExpression evaluateWithEngine:aMerger];

    // If the itemArray is a dictionary we are going to process it just bit differently
    // setting variable name <itemName>Key that has the key of the item we are printing out
    if ([itemArray isKindOfClass:[NSDictionary class]])
    {
        NSString *indexName = [NSString stringWithFormat:@"%@Index", itemName];
        NSString *keyName = [NSString stringWithFormat:@"%@Key", itemName];
        int loopIndex = 0;
        NSMutableDictionary *loopContext = [NSMutableDictionary dictionary];
        NSEnumerator *itemEnum = [itemArray keyEnumerator];
        id currObject;
        MiscMergeCommandExitType exitCode = MiscMergeCommandExitNormal;

        [aMerger addContextObject:loopContext];
        while ((exitCode != MiscMergeCommandExitBreak) && (currObject = [itemEnum nextObject]))
        {
            // maybe index should be a string
            [loopContext setObject:[itemArray objectForKey:currObject] forKey:itemName];
            [loopContext setObject:currObject forKey:keyName];
            [loopContext setObject:[NSNumber numberWithInt:loopIndex] forKey:indexName];
            exitCode = [aMerger executeCommandBlock:commandBlock];
            loopIndex++;
        }
        [aMerger removeContextObject:loopContext];
    }
    else if ([itemArray respondsToSelector:@selector(objectEnumerator)])
    {
        NSString *indexName = [NSString stringWithFormat:@"%@Index", itemName];
        int loopIndex = 0;
        NSMutableDictionary *loopContext = [NSMutableDictionary dictionary];
        NSEnumerator *itemEnum = [itemArray objectEnumerator];
        id currObject;
        MiscMergeCommandExitType exitCode = MiscMergeCommandExitNormal;

        [aMerger addContextObject:loopContext];
        while ((exitCode != MiscMergeCommandExitBreak) && (currObject = [itemEnum nextObject]))
        {
            // maybe index should be a string
            [loopContext setObject:currObject forKey:itemName];
            [loopContext setObject:[NSNumber numberWithInt:loopIndex] forKey:indexName];
            exitCode = [aMerger executeCommandBlock:commandBlock];
            loopIndex++;
        }
        [aMerger removeContextObject:loopContext];
    }

    return MiscMergeCommandExitNormal;
}

@end

