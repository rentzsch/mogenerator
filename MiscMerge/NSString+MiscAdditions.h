//
//  NSString+MiscAdditions.h
//    Written by Carl Lindberg Copyright 1998 by Carl Lindberg.
//                     All rights reserved.
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//	

#import <Foundation/NSString.h>
#import <Foundation/NSCharacterSet.h>
#import <Foundation/NSScanner.h>

@class NSArray, NSEnumerator;

/* Additional searching options for some methods */
enum
{
    MiscOverlappingSearch = 2048
};


@interface NSCharacterSet (MiscAdditions)

+ (NSCharacterSet *)allWhitespaceCharacterSet;

@end

@interface NSString (MiscAdditions)

/*" Trimming whitespace "*/
- (id)stringByTrimmingLeadWhitespace;
- (id)stringByTrimmingTailWhitespace;
- (id)stringByTrimmingWhitespace;
- (id)stringBySquashingWhitespace;

/*" "Letter" manipulation "*/
- (NSString *)letterAtIndex:(unsigned)anIndex;
- (NSString *)firstLetter;
- (NSUInteger)letterCount;

/*" Getting "words" "*/
- (NSArray *)wordArray;
- (unsigned)wordCount;
- (NSString *)wordNum:(unsigned)n;
- (NSEnumerator *)wordEnumerator;
- (NSString *)firstWord;

/*" Bulk replacing "*/
- stringByReplacingEveryOccurrenceOfString:(NSString *)aString
                                withString:(NSString *)replaceString;
- stringByReplacingEveryOccurrenceOfString:(NSString *)searchString
                                withString:(NSString *)replaceString
                                   options:(unsigned)mask;
- stringByReplacingEveryOccurrenceOfCharactersFromSet:(NSCharacterSet *)aSet
                                           withString:(NSString *)replaceString;
- stringByReplacingEverySeriesOfCharactersFromSet:(NSCharacterSet *)aSet
                                       withString:(NSString *)replaceString;

- (unsigned)numOfString:(NSString *)aString;
- (unsigned)numOfString:(NSString *)aString options:(unsigned)mask;
- (unsigned)numOfString:(NSString *)aString range:(NSRange)range;
- (unsigned)numOfString:(NSString *)aString options:(unsigned)mask range:(NSRange)range;
- (unsigned)numOfCharactersFromSet:(NSCharacterSet *)aSet;
- (unsigned)numOfCharactersFromSet:(NSCharacterSet *)aSet range:(NSRange)range;

- (NSRange)rangeOfString:(NSString *)aString occurrenceNum:(int)n;
- (NSRange)rangeOfString:(NSString *)aString options:(unsigned)mask occurrenceNum:(int)n;
- (NSRange)rangeOfString:(NSString *)aString occurrenceNum:(int)n range:(NSRange)range;
- (NSRange)rangeOfString:(NSString *)aString options:(unsigned)mask occurrenceNum:(int)n range:(NSRange)range;

/*" Dividing strings into pieces "*/
- (NSArray *)componentsSeparatedByCharactersFromSet:(NSCharacterSet *)aSet;
- (NSArray *)componentsSeparatedBySeriesOfCharactersFromSet:(NSCharacterSet *)aSet;
- (NSString *)substringToString:(NSString *)aString;
- (NSString *)substringFromEndOfString:(NSString *)aString;

/*" Adding the options mask (mainly for NSCaseInsensitiveSearch) "*/
- (BOOL)containsString:(NSString *)aString;
- (BOOL)containsString:(NSString *)aString options:(unsigned)mask;
- (BOOL)hasPrefix:(NSString *)aString options:(unsigned)mask;
- (BOOL)hasSuffix:(NSString *)aString options:(unsigned)mask;

- (BOOL)isBlank;

@end


@interface NSMutableString (MiscAdditions)

/*" Bulk replacing "*/
- (void)replaceEveryOccurrenceOfString:(NSString *)string withString:(NSString *)replaceString;
- (void)replaceEveryOccurrenceOfString:(NSString *)string
                            withString:(NSString *)replaceString
                               options:(unsigned)mask;
- (void)replaceEveryOccurrenceOfCharactersFromSet:(NSCharacterSet *)aSet
                                       withString:(NSString *)replaceString;
- (void)replaceEverySeriesOfCharactersFromSet:(NSCharacterSet *)aSet
                                   withString:(NSString *)replaceString;

@end
