//
//  NSScanner+MiscMerge.m
//            Written by Don Yacktman and Carl Lindberg
//        Copyright 2002-2004 by Don Yacktman and Carl Lindberg.
//                     All rights reserved.
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//

#import "NSScanner+MiscMerge.h"
#import <Foundation/NSCharacterSet.h>
#import "NSString+MiscAdditions.h"
#import <stdlib.h> // NULL on OSX

@implementation NSScanner (MiscMerge)

- (BOOL)scanLetterIntoString:(NSString **)aString
{
    NSRange letterRange;

    if ([self isAtEnd]) return NO;

    //	[self skipPastSkipCharacters];
    letterRange = [[self string] rangeOfComposedCharacterSequenceAtIndex:[self scanLocation]];

    if (letterRange.length == 0)
    {
        return NO;
    }
    else
    {
        [self setScanLocation:NSMaxRange(letterRange)];
        if (aString) *aString = [[self string] substringWithRange:letterRange];
        return YES;
    }
}

- (BOOL)scanString:(NSString *)aString
{
    return [self scanString:aString intoString:NULL];
}

/*"
 * Returns the range of the string being scanned from the current
 * scanLocation to the end.  This method does not skip past the skip
 * characters first.
"*/
- (NSRange)remainingRange
{
    NSUInteger location = [self scanLocation];
    return NSMakeRange(location, [[self string] length] - location);
}

/*"
 * This method does the same thing as NeXT's private -skipCharacters method
 * does -- skip past any charactersToBeSkipped at the current scan location
 * and update the scanLocation accordingly.  This is not a general use
 * method; it is meant to be used by other NSScanner methods to skip past
 * skip characters before doing other work the way other NSScanner methods
 * do.
"*/
- (void)skipPastSkipCharacters
{
    NSCharacterSet *nonskipSet = [[self charactersToBeSkipped] invertedSet];
    NSRange skipRange;

    if (nonskipSet == nil) return;

    skipRange = [[self string] rangeOfCharacterFromSet:nonskipSet options:0
                                                 range:[self remainingRange]];
    if (skipRange.length > 0)
    {
        [self setScanLocation:skipRange.location];
    }
    else
    {
        [self setScanLocation:[[self string] length]];
    }
}

- (BOOL)scanCharacter:(unichar)targetCharacter
{
    NSUInteger scanLocation = [self scanLocation];
    NSString *myString = [self string];

    [self skipPastSkipCharacters];
    scanLocation = [self scanLocation];
    myString     = [self string];

    if ([myString length] == scanLocation) return NO;

    if ([myString characterAtIndex:scanLocation] == targetCharacter)
    {
        [self setScanLocation:scanLocation+1];
        return YES;
    }

    return NO;
}

- (unichar)peekNextCharacter
{
    NSUInteger scanLocation;
    NSString *myString;

    [self skipPastSkipCharacters];
    scanLocation = [self scanLocation];
    myString     = [self string];

    if ([myString length] == scanLocation) return 0;

    return [myString characterAtIndex:scanLocation];
}

// NeXT has a method called this, at least in 3.3...
- (NSString *)remainingString
{
    return [[self string] substringFromIndex:[self scanLocation]];
}

@end

