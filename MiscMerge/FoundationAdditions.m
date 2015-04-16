/* FoundationAdditions.m created by lindberg on Mon 20-Dec-1999 */
/*-
* Copyright (c) 2002 Carl Lindberg and Mike Gentry
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION, HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/* NOTE: Do not put any code dealing with anything other than Foundation in here.
 * This class is used by TGen also. So has to be pure Foundation.
 */

#import "FoundationAdditions.h"
#import <Foundation/Foundation.h>
#import "NSString+MiscAdditions.h"


/* Writes to stderr */
void ErrVPrintf(NSString *format, va_list arguments)
{
    NSString *logString = [[NSString alloc] initWithFormat:format arguments:arguments];
    fwrite([logString cStringUsingEncoding:NSUTF8StringEncoding], 1, [logString lengthOfBytesUsingEncoding:NSUTF8StringEncoding], stderr);
    if (![logString hasSuffix:@"\n"]) fputc('\n', stdout);
    [logString release];
}

void ErrPrintf(NSString *format, ...)
{
    va_list arguments;

    va_start(arguments, format);
    ErrVPrintf(format, arguments);
    va_end(arguments);
}

void VPrintf(NSString *format, va_list arguments)
{
    NSString *logString = [[NSString alloc] initWithFormat:format arguments:arguments];
    fwrite([logString cStringUsingEncoding:NSUTF8StringEncoding], 1, [logString lengthOfBytesUsingEncoding:NSUTF8StringEncoding], stdout);
    if (![logString hasSuffix:@"\n"]) fputc('\n', stdout);
    [logString release];
}

void Printf(NSString *format, ...)
{
    va_list arguments;

    va_start(arguments, format);
    VPrintf(format, arguments);
    va_end(arguments);
}


@interface NSObject (WarningAvoidance)
- (NSString *)name;  // method on EOAttribute/EOEntity etc.
- (id)valueForKey:(NSString *)key;
- (id)valueForKeyPath:(NSString *)keyPath;
@end

@implementation NSArray (FoundationAdditions)

- (NSArray *)reversedArray
{
    return [[self reverseObjectEnumerator] allObjects];
}

// does an @reversedArray KeyValue key
- (id)computeReversedArrayForKey:(NSString *) key
{
    if ([key length] == 0)
        return [self reversedArray];
    else
        return [[self reversedArray] valueForKeyPath:key];
}

static NSInteger sortByName(id obj1, id obj2, void *context)
{
    return [(NSString *)[obj1 valueForKey:@"name"] compare:[obj2 valueForKey:@"name"]];
}

// does an @sortedNameArray KeyValue key
- (id)computeSortedNameArrayForKey:(NSString *)key
{
    if ([key length] == 0)
        return [self sortedArrayUsingFunction:sortByName context:NULL];
    else
        return [[self sortedArrayUsingFunction:sortByName context:NULL] valueForKeyPath:key];
}

// does an @sortedStringArray KeyValue key
- (id)computeSortedStringArrayForKey:(NSString *)key
{
    if ([key length] == 0)
        return [self sortedArrayUsingSelector:@selector(compare:)];
    else
        return [[self sortedArrayUsingSelector:@selector(compare:)] valueForKeyPath:key];
}

/*"
 * Calls -#performSelector: on each object in the receiver, and returns an
 * array of the return values from the method calls.  If a result is nil,
 * it is not added to the array.
"*/
- (NSArray *)arrayByMakingObjectsPerformSelector:(SEL)aSelector
{
    return [self arrayByMakingObjectsPerformSelector:aSelector withObject:nil withObject:nil];
}

/*"
 * Calls -#performSelector:withObject: on each object in the receiver, and
 * returns an array of the return values from the method calls.  If a
 * result is nil, it is not added to the array.
"*/
- (NSArray *)arrayByMakingObjectsPerformSelector:(SEL)aSelector withObject:anObject
{
    return [self arrayByMakingObjectsPerformSelector:aSelector withObject:anObject withObject:nil];
}

/*"
 * Calls -#performSelector:withObject:withObject: on each object in the
 * receiver, and returns an array of the return values from the method
 * calls.  If a result is nil, it is not added to the array.
"*/
- (NSArray *)arrayByMakingObjectsPerformSelector:(SEL)aSelector withObject:anObject
                                      withObject:anObject2
{
    NSUInteger		i, count = [self count];
    NSMutableArray	*array = [NSMutableArray arrayWithCapacity:count];

    for(i=0; i<count; i++)
    {
        id object = [self objectAtIndex:i];
        id value = [object performSelector:aSelector withObject:anObject withObject:anObject2];

        if (value != nil) {
            [array addObject:value];
        }
    }

    return array;
}

@end

@implementation NSString (FoundationAdditions)

- (NSString *)initialCapitalString
{
    NSRange  firstLetterRange;
    NSString *firstLetterString;
    NSString *restOfString;

    if ([self length] == 0) return self;

    firstLetterRange  = [self rangeOfComposedCharacterSequenceAtIndex:0];
    firstLetterString = [[self substringWithRange:firstLetterRange] uppercaseString];
    restOfString      = [self substringFromIndex:NSMaxRange(firstLetterRange)];

    return [firstLetterString stringByAppendingString:restOfString];
}

- (NSString *)beautifyString
{
    NSString *newString;
    NSCharacterSet *invalidSet;
    NSMutableCharacterSet *validSet = [[[NSCharacterSet letterCharacterSet] mutableCopy] autorelease];
    [validSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [validSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    invalidSet = [[[validSet copy] autorelease] invertedSet];

    newString = [self stringByReplacingEveryOccurrenceOfCharactersFromSet:invalidSet withString:@" "];

    if ( [newString rangeOfString:@" "].location != NSNotFound ) {
        newString = [newString stringByTrimmingWhitespace];
        newString = [newString stringBySquashingWhitespace];

        if ( [newString rangeOfString:@" "].location != NSNotFound ) {
            NSArray *components = [newString componentsSeparatedByString:@" "];
            components = [components arrayByMakingObjectsPerformSelector:@selector(initialCapitalString)];
            newString = [components componentsJoinedByString:@""];
        }
    }

    return [newString initialCapitalString];
}

@end

@implementation NSFileManager (FoundationAdditions)

- (BOOL)directoryExistsAtPath:(NSString *)path
{
    BOOL isDir = NO;
    BOOL isFile = [self fileExistsAtPath:path isDirectory:&isDir];
    return (isFile && isDir);
}

- (BOOL)regularFileExistsAtPath:(NSString *)path
{
    BOOL isDir = NO;
    BOOL isFile = [self fileExistsAtPath:path isDirectory:&isDir];
    return (isFile && !isDir);
}

- (NSString *)findFile:(NSString *)filename inSearchPath:(NSArray *)paths
{
    NSInteger i, count = [paths count];

    for (i=0; i<count; i++)
    {
        NSString *currPath = [paths objectAtIndex:i];
        NSString *fullPath = [currPath stringByAppendingPathComponent:filename];

        if ([self regularFileExistsAtPath:fullPath])
            return fullPath;
    }

    return nil;
}

- (void)touchPath:(NSString *)filePath
{
    NSMutableDictionary *attributes;

    attributes = [[NSMutableDictionary alloc] initWithCapacity:1];
    [attributes setObject:[NSDate date] forKey:NSFileModificationDate];
    [self setAttributes:attributes ofItemAtPath:filePath error:nil];
    [attributes release];
}

@end
