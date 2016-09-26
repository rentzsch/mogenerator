//
//  _MiscMergeCallCommand.m
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

#import "_MiscMergeCallCommand.h"
//#import <Foundation/NSUtilities.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSString.h>
#import "MiscMergeEngine.h"
#import "_MiscMergeProcedureCommand.h"
#import "NSNull.h"

@implementation _MiscMergeCallCommand

- init
{
    [super init];
    argumentArray = [[NSMutableArray alloc] init];
    quotedArray = [[NSMutableArray alloc] init];
    return self;
}

- (void)dealloc
{
    [procedureName release];
    [argumentArray release];
    [quotedArray release];
    [super dealloc];
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    NSString *argName;
    int quotes;

    [self eatKeyWord:@"call" fromScanner:aScanner isOptional:NO];
    procedureName = [[self getArgumentStringFromScanner:aScanner toEnd:NO] retain];

    while ((argName = [self getArgumentStringFromScanner:aScanner toEnd:NO quotes:&quotes]))
    {
        [argumentArray addObject:argName];
        [quotedArray addObject:[NSNumber numberWithInt:quotes]];
    }

    return YES;
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    NSString *symbolName = [NSString stringWithFormat:@"_MiscMergeProcedure%@", procedureName];
    _MiscMergeProcedureCommand *procCommand = [[aMerger userInfo] objectForKey:symbolName];
    NSInteger i, count = [argumentArray count];
    NSMutableArray *realArgArray = [NSMutableArray arrayWithCapacity:count];

    if (procCommand == nil)
    {
        if ( !alreadyWarned ) {
            NSLog(@"%@: Error -- procedure %@ not found.", [self class], procedureName);
            alreadyWarned = YES;
        }
        return MiscMergeCommandExitNormal;
    }

    for (i=0; i<count; i++)
    {
        NSString *argument = [argumentArray objectAtIndex:i];
        id value = nil;
        int quote = [[quotedArray objectAtIndex:i] intValue];

        if ( quote == 1 )
            value = argument;
        else {
            value = [aMerger valueForField:argument quoted:quote];
            if (value == nil) value = [NSNull null];
        }

        if ( value != nil )
            [realArgArray addObject:value];
    }

    [procCommand executeForMerge:aMerger arguments:realArgArray];
    return MiscMergeCommandExitNormal;
}

@end

