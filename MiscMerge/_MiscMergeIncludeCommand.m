//
//  _MiscMergeIncludeCommand.m
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

#import "_MiscMergeIncludeCommand.h"
#import <Foundation/NSString.h>
//#import <Foundation/NSUtilities.h>
#import "MiscMergeTemplate.h"
#import "MiscMergeCommandBlock.h"
#import "MiscMergeEngine.h"

@implementation _MiscMergeIncludeCommand

- (void)dealloc
{
    [commandBlock release];
    [super dealloc];
}

- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    NSString *filename;
    NSString *resolvedFilename;
    NSString *fileString = nil;
    NSString *startDelim = nil;
    NSString *endDelim = nil;

    [self eatKeyWord:@"include" fromScanner:aScanner isOptional:NO];
    filename = [self getArgumentStringFromScanner:aScanner toEnd:NO];
    startDelim = [self getArgumentStringFromScanner:aScanner toEnd:NO];

    if ( [startDelim length] > 0 ) {
        endDelim = [self getArgumentStringFromScanner:aScanner toEnd:NO];

        if ( [endDelim length] == 0 ) {
            [template reportParseError:@"%@: Must specify an end delimiter if specifying a start delimiter.", [self class]];
            startDelim = nil;
        }
    }

    resolvedFilename = [template resolveTemplateFilename:filename];

    NSError *error = nil;
    if ([resolvedFilename length] > 0)
        fileString = [NSString stringWithContentsOfFile:resolvedFilename encoding:NSUTF8StringEncoding error:&error];

    if (fileString)
    {
        MiscMergeTemplate *newTemplate = [[[template class] alloc] init];

        if ( startDelim != nil )
            [newTemplate setStartDelimiter:startDelim endDelimiter:endDelim];
        else
            [newTemplate setStartDelimiter:[template startDelimiter] endDelimiter:[template endDelimiter]];
        
        [newTemplate setFilename:resolvedFilename];
        [newTemplate setDelegate:[template delegate]];
        [newTemplate parseString:fileString];
        commandBlock = [[newTemplate topLevelCommandBlock] retain];
        [newTemplate release];
    }
    else
    {
        [template reportParseError:@"%@: Could not load from file '%@' because %@", [self class], resolvedFilename, [error localizedDescription]];
    }

    return YES;
}

- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    if (commandBlock)
        return [aMerger executeCommandBlock:commandBlock];
    return MiscMergeCommandExitNormal;
}

@end

