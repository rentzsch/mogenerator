//
//  NSString+MiscAdditions.m
//    Written by Carl Lindberg Copyright 2002 by Carl Lindberg.
//                     All rights reserved.
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//	

#import "NSString+MiscAdditions.h"
#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSScanner.h>
//#import <Foundation/NSUtilities.h>
#import <Foundation/NSString.h>
#import <Foundation/NSData.h>
#import <stdlib.h>  //NULL os OSXPB


@implementation NSCharacterSet (MiscAdditions)

/*
 * NSCharacterSet's -whitespaceAndNewlineCharacterSet does not contain the
 * carriage return ('\r') character, which can cause problems on NT. The
 * returned set does not contain all Unicode whitespace characters (there are
 * more), but it at least contains everything that isspace() returns true for.
 */
+ (NSCharacterSet *)allWhitespaceCharacterSet
{
    static NSCharacterSet *whiteSet = nil;

    if (whiteSet == nil)
        whiteSet = [[NSCharacterSet characterSetWithCharactersInString:@" \t\n\r\v\f"] retain];

    return whiteSet;
}

@end


@implementation NSString (MiscAdditions)

- (NSRange)completeRange
{
    return NSMakeRange(0, [self length]);
}

- (id)stringByTrimmingLeadWhitespace
{
    NSCharacterSet *nonSpaceSet;
    NSRange validCharRange;

    nonSpaceSet = [[NSCharacterSet allWhitespaceCharacterSet] invertedSet];
    validCharRange = [self rangeOfCharacterFromSet:nonSpaceSet];

    if (validCharRange.length == 0)
        return @"";
    else
        return [self substringFromIndex:validCharRange.location];
}

- (id)stringByTrimmingTailWhitespace
{
    NSCharacterSet *nonSpaceSet;
    NSRange validCharRange;

    nonSpaceSet = [[NSCharacterSet allWhitespaceCharacterSet] invertedSet];
    validCharRange = [self rangeOfCharacterFromSet:nonSpaceSet options:NSBackwardsSearch];

    if (validCharRange.length == 0)
        return @"";
    else
        return [self substringToIndex:validCharRange.location+1];
}

- (id)stringByTrimmingWhitespace
{
    return [[self stringByTrimmingLeadWhitespace] stringByTrimmingTailWhitespace];
}

- stringBySquashingWhitespace
{
    NSCharacterSet *spaceSet = [NSCharacterSet allWhitespaceCharacterSet];
    NSCharacterSet *nonspaceSet = [spaceSet invertedSet];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableString *newString = [NSMutableString stringWithCapacity:[self length]];
    NSString *wordString;
    NSString *stringToAppend = @"";

    [scanner setCharactersToBeSkipped:spaceSet];

    while (![scanner isAtEnd])
    {
        [newString appendString:stringToAppend];

        if ([scanner scanCharactersFromSet:nonspaceSet intoString:&wordString])
        {
            [newString appendString:wordString];
            //			stringToAppend = ([wordString hasSuffix:@"."])? @"  " : @" ";
            stringToAppend = @" ";
        }
    }

    return newString;
}

- stringBySquashingWhitespace2
{
    return [[self wordArray] componentsJoinedByString:@" "];
}

- (NSString *)letterAtIndex:(unsigned)anIndex
{
    NSRange letterRange = [self rangeOfComposedCharacterSequenceAtIndex:0];
    return [self substringWithRange:letterRange];
}

- (NSString *)firstLetter
{
    return [self letterAtIndex:0];
}

- (NSUInteger)letterCount
{
    NSUInteger count = 0;
    NSUInteger selfLength = [self length];
    NSUInteger currIndex = 0;
    NSRange letterRange;

    while (currIndex < selfLength)
    {
        letterRange = [self rangeOfComposedCharacterSequenceAtIndex:currIndex];
        if (letterRange.length > 0)
        {
            currIndex = NSMaxRange(letterRange);
            count++;
        }
        else
        {
            break;
        }
    }

    return count;
}


- (NSArray *)wordArray
{
    NSCharacterSet *spaceSet = [NSCharacterSet allWhitespaceCharacterSet];
    NSCharacterSet *nonspaceSet = [spaceSet invertedSet];
    NSMutableArray *wordArray = [NSMutableArray array];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSString *aWord;

    [scanner setCharactersToBeSkipped:spaceSet];

    while (![scanner isAtEnd])
    {
        if ([scanner scanCharactersFromSet:nonspaceSet intoString:&aWord])
            [wordArray addObject:aWord];
    }

    return wordArray;
}

- (unsigned)wordCount;
{
    NSCharacterSet *spaceSet = [NSCharacterSet allWhitespaceCharacterSet];
    NSCharacterSet *nonspaceSet = [spaceSet invertedSet];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    unsigned count = 0;

    [scanner setCharactersToBeSkipped:spaceSet];

    while (![scanner isAtEnd])
    {
        if ([scanner scanCharactersFromSet:nonspaceSet intoString:NULL])
            count++;
    }

    return count;
}

- (NSString *)wordNum:(unsigned)n
{
    NSCharacterSet *spaceSet = [NSCharacterSet allWhitespaceCharacterSet];
    NSCharacterSet *nonspaceSet = [spaceSet invertedSet];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSString *aWord;
    int count = 0;

    [scanner setCharactersToBeSkipped:spaceSet];

    while (![scanner isAtEnd])
    {
        if ([scanner scanCharactersFromSet:nonspaceSet intoString:&aWord])
        {
            if (n == count) return aWord;
        }

        count++;
    }

    return nil;
}

- (NSEnumerator *)wordEnumerator
{
    return [[self wordArray] objectEnumerator];
}

- (NSString *)firstWord
{
    return [self wordNum:0];
}

- stringByReplacingEveryOccurrenceOfString:(NSString *)searchString
                                withString:(NSString *)replaceString
{
    return [self stringByReplacingEveryOccurrenceOfString:searchString
                                               withString:replaceString
                                                  options:0];
}

static NSRange _nextSearchRange(NSString *string, unsigned mask,
                                NSRange *foundRange, NSUInteger lastIndex, NSUInteger firstIndex)
{
    /*
     * The char range stuff is if we want to use
     * -rangeOfComposedCharacterSequenceAtIndex: instead of assuming characters
     * are one index apart.  It may not matter, provided that NeXT's
     * -rangeOfString: routines adjust appropriately if we give it an index in
     * the middle of a composed character sequence.
     */
    //	NSRange	charRange;
    NSRange nextRange;

    if (mask & NSBackwardsSearch)
    {
        NSUInteger endLocation;

        if (mask & MiscOverlappingSearch)
        {
            endLocation = foundRange->location - 1;
            // charRange = [string rangeOfComposedCharacterSequenceAtIndex:endLocation];
            // endLocation = charRange.location;
        }
        else
        {
            endLocation = foundRange->location - foundRange->length;
        }
        nextRange.location = firstIndex;
        nextRange.length = endLocation - nextRange.location;
    }
    else
    {
        if (mask & MiscOverlappingSearch)
        {
            // charRange = [string rangeOfComposedCharacterSequenceAtIndex:foundRange->location];
            // nextRange.location = NSMaxRange(charRange);
            nextRange.location = foundRange->location+1;
        }
        else
        {
            nextRange.location = NSMaxRange(*foundRange);
        }
        nextRange.length = lastIndex - nextRange.location;
    }

    return nextRange;
}

- stringByReplacingEveryOccurrenceOfString:(NSString *)searchString
                                withString:(NSString *)replaceString
                                   options:(unsigned)mask
{
    NSRange searchRange;
    NSRange foundRange;
    NSRange betweenRange;
    unsigned searchOptions = (mask & (NSCaseInsensitiveSearch|NSLiteralSearch));
    NSUInteger selfLength = [self length];
    NSMutableString *newString = [NSMutableString stringWithCapacity:selfLength];

    mask &= ~NSBackwardsSearch;
    betweenRange.location = 0;
    searchRange = NSMakeRange (0, selfLength);
    foundRange  = [self rangeOfString:searchString options:searchOptions range:searchRange];

    while (foundRange.length > 0)
    {
        if (foundRange.location > betweenRange.location)
        {
            betweenRange.length = foundRange.location - betweenRange.location;
            [newString appendString: [self substringWithRange:betweenRange]];
        }
        [newString appendString: replaceString];

        betweenRange.location = NSMaxRange(foundRange);

        searchRange = _nextSearchRange(self, mask, &foundRange, selfLength, 0);
        foundRange = [self rangeOfString:searchString options:searchOptions range:searchRange];
    }

    [newString appendString:[self substringFromIndex:betweenRange.location]];

    return newString;
}

- stringByReplacingEverySeriesOfCharactersFromSet:(NSCharacterSet *)aSet
                                       withString:(NSString *)replaceString
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableString *newString = [NSMutableString stringWithCapacity:[self length]];
    NSString *betweenString;

    [scanner setCharactersToBeSkipped:nil];

    while (![scanner isAtEnd])
    {
        if ([scanner scanUpToCharactersFromSet:aSet intoString:&betweenString])
            [newString appendString:betweenString];

        if ([scanner scanCharactersFromSet:aSet intoString:NULL])
            [newString appendString:replaceString];
    }

    return newString;
}

- stringByReplacingEveryOccurrenceOfCharactersFromSet:(NSCharacterSet *)aSet
                                           withString:(NSString *)replaceString
{
    NSScanner		*scanner = [NSScanner scannerWithString:self];
    NSMutableString	*newString = [NSMutableString stringWithCapacity:[self length]];
    NSString		*betweenString;

    [scanner setCharactersToBeSkipped:nil];

    while (![scanner isAtEnd])
    {
        if ([scanner scanUpToCharactersFromSet:aSet intoString:&betweenString])
            [newString appendString:betweenString];

        if ([scanner scanCharactersFromSet:aSet intoString:&betweenString])
        {
            NSInteger i, count = [betweenString length];
            //			int i, count = [betweenString letterCount];

            for (i=0;i<count;i++)
                [newString appendString:replaceString];
        }
    }

    return newString;
}

/* Is this (using array then componentsJoinedWithString) any faster/slower? */
- stringByReplacingEveryOccurrenceOfCharactersFromSet:(NSCharacterSet *)aSet
                                          withString2:(NSString *)replaceString
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableArray *stringArray = [NSMutableArray array];
    NSString *betweenString;

    [scanner setCharactersToBeSkipped:nil];

    while (![scanner isAtEnd])
    {
        if ([scanner scanUpToCharactersFromSet:aSet intoString:&betweenString])
            [stringArray addObject:betweenString];

        if ([scanner scanCharactersFromSet:aSet intoString:&betweenString])
        {
            // int i, count = [betweenString length];
            NSInteger i, count = [betweenString letterCount];

            for (i=0;i<count;i++)
                [stringArray addObject:replaceString];
        }
    }

    return [stringArray componentsJoinedByString:@""];
}

- (unsigned)numOfString:(NSString *)aString
{
    return [self numOfString:aString options:0 range:[self completeRange]];
}

- (unsigned)numOfString:(NSString *)aString options:(unsigned)mask
{
    return [self numOfString:aString options:mask range:[self completeRange]];
}

- (unsigned)numOfString:(NSString *)aString range:(NSRange)range
{
    return [self numOfString:aString options:0 range:range];
}

- (unsigned)numOfString:(NSString *)aString options:(unsigned)mask range:(NSRange)range
{
    NSUInteger lastIndex = NSMaxRange(range);
    unsigned stringCount = 0;
    unsigned searchOptions = (mask & (NSCaseInsensitiveSearch|NSLiteralSearch));
    NSRange searchRange;
    NSRange foundRange;

    mask &= ~NSBackwardsSearch;
    foundRange = [self rangeOfString:aString options:searchOptions range:range];

    while (foundRange.length > 0)
    {
        stringCount++;
        searchRange = _nextSearchRange(self, mask, &foundRange, lastIndex, range.location);
        foundRange  = [self rangeOfString:aString options:searchOptions range:searchRange];
    }

    return stringCount;
}

- (NSRange)rangeOfString:(NSString *)aString occurrenceNum:(int)n
{
    return [self rangeOfString:aString options:0 occurrenceNum:n range:[self completeRange]];
}

- (NSRange)rangeOfString:(NSString *)aString options:(unsigned)mask occurrenceNum:(int)n
{
    return [self rangeOfString:aString options:mask occurrenceNum:n
                                                            range:[self completeRange]];
}

- (NSRange)rangeOfString:(NSString *)aString occurrenceNum:(int)n range:(NSRange)range
{
    return [self rangeOfString:aString options:0 occurrenceNum:n range:range];
}

- (NSRange)rangeOfString:(NSString *)aString options:(unsigned)mask
                                       occurrenceNum:(int)n range:(NSRange)range
{
    NSUInteger lastIndex = NSMaxRange(range);
    unsigned count = 0;
    unsigned searchOptions = (mask & (~NSAnchoredSearch));
    NSRange searchRange;
    NSRange foundRange;

    foundRange = [self rangeOfString:aString options:searchOptions range:range];

    while (foundRange.length > 0)
    {
        if (count == n) return foundRange;
        searchRange = _nextSearchRange(self, mask, &foundRange, lastIndex, range.location);
        foundRange = [self rangeOfString:aString options:searchOptions range:searchRange];
        count++;
    }

    return NSMakeRange(NSNotFound, 0);
}

- (unsigned)numOfCharactersFromSet:(NSCharacterSet *)aSet
{
    return [self numOfCharactersFromSet:(NSCharacterSet *)aSet range:[self completeRange]];
}

- (unsigned)numOfCharactersFromSet:(NSCharacterSet *)aSet range:(NSRange)range
{
    NSUInteger lastIndex = NSMaxRange(range);
    NSRange searchRange = {range.location, lastIndex};
    NSRange foundRange;
    unsigned characterCount = 0;

    foundRange = [self rangeOfCharacterFromSet:aSet options:0 range:searchRange];

    while (foundRange.length > 0)
    {
        characterCount++;
        searchRange.location = NSMaxRange(foundRange);
        searchRange.length = lastIndex - searchRange.location;
        foundRange = [self rangeOfCharacterFromSet:aSet options:0 range:searchRange];
    }

    return characterCount;
}

- (NSArray *)componentsSeparatedByCharactersFromSet:(NSCharacterSet *)aSet
{
    NSUInteger selfLength = [self length];
    NSRange searchRange = {0, selfLength};
    NSRange betweenRange = {0, 0};
    NSRange foundRange;
    NSMutableArray *stringArray = [NSMutableArray array];

    foundRange = [self rangeOfCharacterFromSet:aSet options:0 range:searchRange];

    while (foundRange.length > 0)
    {
        betweenRange.length = foundRange.location - betweenRange.location;
        [stringArray addObject:[self substringWithRange:betweenRange]];

        betweenRange.location = searchRange.location = NSMaxRange(foundRange);
        searchRange.length = selfLength - searchRange.location;
        foundRange = [self rangeOfCharacterFromSet:aSet options:0 range:searchRange];
    }

    betweenRange.length = selfLength - betweenRange.location;
    [stringArray addObject:[self substringWithRange:betweenRange]];
    return stringArray;
}


- (NSArray *)componentsSeparatedBySeriesOfCharactersFromSet:(NSCharacterSet *)aSet
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableArray *stringArray = [NSMutableArray array];
    NSString *betweenString;

    [scanner setCharactersToBeSkipped:nil];

    while (![scanner isAtEnd])
    {
        if ([scanner scanUpToCharactersFromSet:aSet intoString:&betweenString])
            [stringArray addObject:betweenString];
        else
            [stringArray addObject:@""];  // can only happen first time

        if ([scanner scanCharactersFromSet:aSet intoString:NULL])
        {
            if ([scanner isAtEnd])
                [stringArray addObject:@""];  // can only happen last time
        }
    }

    return stringArray;
}


- (NSString *)substringFromEndOfString:(NSString *)aString
{
    NSRange stringRange = [self rangeOfString:aString options:0];

    if (stringRange.length > 0)
        return [self substringFromIndex:NSMaxRange(stringRange)];
    else
        return nil;  // return @""? return self?
}


- (NSString *)substringToString:(NSString *)aString
{
    NSRange stringRange = [self rangeOfString:aString options:0];

    if (stringRange.length > 0)
        return [self substringToIndex:stringRange.location];
    else
        return nil;  // return @""? return self?
}

- (BOOL)containsString:(NSString *)aString
{
    return [self containsString:aString options:0];
}

- (BOOL)containsString:(NSString *)aString options:(unsigned)mask
{
    NSRange range = [self rangeOfString:aString options:(mask & (~NSAnchoredSearch))];
    return (range.length > 0)? YES : NO;
}

- (BOOL)hasPrefix:(NSString *)aString options:(unsigned)mask
{
    NSRange range;

    mask |= NSAnchoredSearch;
    mask &= (~NSBackwardsSearch);
    range = [self rangeOfString:aString options:mask];

    return (range.length > 0 && range.location == 0)? YES : NO;
}

- (BOOL)hasSuffix:(NSString *)aString options:(unsigned)mask
{
    NSRange range;

    mask |= (NSAnchoredSearch|NSBackwardsSearch);
    range = [self rangeOfString:aString options:mask];

    return ((range.length > 0) && (NSMaxRange(range) == [self length]))? YES : NO;
}


- (BOOL)isBlank
{
    NSRange spaceRange = [self rangeOfCharacterFromSet:[[NSCharacterSet allWhitespaceCharacterSet] invertedSet]];
    return (spaceRange.length == 0)? YES : NO;
}

@end

@implementation NSMutableString (MiscAdditions)

- (void)replaceEveryOccurrenceOfString:(NSString *)string withString:(NSString *)replaceString
{
    [self replaceEveryOccurrenceOfString:string withString:replaceString options:0];
}

- (void)replaceEveryOccurrenceOfString:(NSString *)string withString:(NSString *)replaceString options:(unsigned)mask
{
    NSString *newString = [self stringByReplacingEveryOccurrenceOfString:string withString:replaceString options:mask];
    [self setString:newString];
}

- (void)replaceEveryOccurrenceOfCharactersFromSet:(NSCharacterSet *)aSet withString:(NSString *)replaceString
{
    NSString *newString = [self stringByReplacingEveryOccurrenceOfCharactersFromSet:aSet withString:replaceString];
    [self setString:newString];
}

- (void)replaceEverySeriesOfCharactersFromSet:(NSCharacterSet *)aSet withString:(NSString *)replaceString
{
    NSString *newString = [self stringByReplacingEverySeriesOfCharactersFromSet:aSet withString:replaceString];
    [self setString:newString];
}

- (void)setStringValue:(NSString *)aString
{
    [self setString:aString];
}

@end
