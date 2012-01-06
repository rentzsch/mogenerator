//
//  MiscMergeFunctions.m
//
//	Written by Doug McClure and Carl Lindberg
//
//	Copyright 2002-2004 by Don Yacktman, Doug McClure, and Carl Lindberg.
//	All rights reserved.
//
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//

#import "MiscMergeFunctions.h"
#import <Foundation/NSValue.h>
#import "NSString+MiscAdditions.h"

BOOL MMBoolValueOfObject(id anObject)
{
    if ( MMIsObjectANumber(anObject) )
        return MMDoubleValueForObject(anObject) != 0;
    else if ( MMIsObjectAString(anObject) )
        return ([anObject length] > 0);
    else
        return (anObject != nil);
}

int MMIntegerValueOfObject(id anObject)
{
    if ([anObject isKindOfClass:[NSNumber class]])
        return [anObject intValue];
    
    if ([anObject isKindOfClass:[NSString class]]) {
        NSScanner *scanner = [NSScanner scannerWithString:anObject];
        int intValue;
        [scanner scanInt:&intValue];
        return intValue;
    }

    return 0;
}

double MMDoubleValueForObject(id anObject)
{
    if ( MMIsObjectANumber(anObject) )
        return [anObject doubleValue];
    else if ( MMIsObjectAString(anObject) )
        return (double)([anObject length] > 0);
    else
        return (double)(anObject != nil);
}

BOOL MMIsObjectANumber(id anObject)
{
    if ([anObject isKindOfClass:[NSNumber class]])
        return YES;
    
    if ([anObject isKindOfClass:[NSString class]]) {
        NSScanner *scanner = [NSScanner scannerWithString:anObject];
        float  floatValue;
        return [scanner scanFloat:&floatValue];
    }

    return NO;
}

BOOL MMIsObjectAString(id anObject)
{
    return [anObject isKindOfClass:[NSString class]];
}

BOOL MMIsBooleanTrueString(NSString *anObject)
{
    return ([anObject compare:@"yes"  options:NSCaseInsensitiveSearch] == 0 ||
            [anObject compare:@"true" options:NSCaseInsensitiveSearch] == 0);
}


NSComparisonResult MMCompareFloats(float num1, float num2)
{
    if (num1 < num2) return NSOrderedAscending;
    if (num1 > num2) return NSOrderedDescending;
    return NSOrderedSame;
}


Class MMCommonAnscestorClass(id obj1, id obj2)
{
    Class currSuperclass = [obj1 class];

    for (; currSuperclass != nil; currSuperclass = [currSuperclass superclass]) {
        Class currTestClass = [obj2 class];
        
        for (; currTestClass != nil; currTestClass = [currTestClass superclass]) {
            if (currTestClass == currSuperclass)
                return currSuperclass;
        }
    }

    return nil;
}


NSString *MMStringByTrimmingCommandSpace(NSString *string)
{
    if ( [string isBlank] ) {
        return @"";
    }
    else {
        NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
        NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
        NSInteger start = 0, end = [string length]-1;
        NSInteger i;

        for ( i = 0; i <= end; i++ ) {
            unichar character = [string characterAtIndex:i];

            if ( ![whitespaceSet characterIsMember:character] ) {
                if ( [newlineSet characterIsMember:character] )
                    start = i+1;
                break;
            }
        }

        for ( i = end; i >= start; i-- ) {
            unichar character = [string characterAtIndex:i];

            if ( ![whitespaceSet characterIsMember:character] ) {
                if ( [newlineSet characterIsMember:character] )
                    end = i;
                break;
            }
        }

        return [string substringWithRange:NSMakeRange(start, end - start + 1)];
    }
}
