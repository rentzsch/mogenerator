//
//  KeyValue+MiscMerge.m
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

#import "KeyValue+MiscMerge.h"
#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import <Foundation/NSCharacterSet.h>
#import <stdlib.h> // for NULL os OSX
#if GNU_RUNTIME
#import <objc/objc-api.h>
static Ivar_t class_getInstanceVariable(Class aClass, const char *name);
#else
#import <objc/objc-runtime.h>
#endif

@interface NSObject (WarningAvoidance)
+ (BOOL)accessInstanceVariablesDirectly;
@end

@implementation NSObject (MiscMergeHasKey)

- (BOOL)hasMiscMergeKeyPath:(NSString *)keyPath
{
    static NSCharacterSet *dotSet;

    NSString *key = keyPath;
    NSRange dotRange;

    if ( dotSet == nil ) {
        dotSet = [[NSCharacterSet characterSetWithRange:NSMakeRange((unsigned int)'.', 1)] retain];
    }

    dotRange = [keyPath rangeOfCharacterFromSet:dotSet];

    if (dotRange.length > 0)
    {
        key = [keyPath substringToIndex:dotRange.location];
    }

    return [self hasMiscMergeKey:key];
}

- (BOOL)hasMiscMergeKey:(NSString *)key
{
    SEL keySelector;

    if ([key length] == 0) return NO;

    keySelector = NSSelectorFromString(key);

    return (keySelector != NULL && [self respondsToSelector:keySelector]) ||
        ([[self class] accessInstanceVariablesDirectly] &&
         class_getInstanceVariable([self class], [key cStringUsingEncoding:NSUTF8StringEncoding]));
}

@end

@implementation NSDictionary (MiscMergeHasKey)

- (BOOL)hasMiscMergeKey:(NSString *)key
{
    return ([self objectForKey:key] != nil)? YES : NO;
}

@end

@implementation NSArray (MiscMergeHasKey)

- (BOOL)hasMiscMergeKey:(NSString *)key
{
    if ([key isEqualToString:@"count"]) return YES;
    if ([key hasPrefix:@"@"]) return YES;
    if ([self count] == 0) return YES; //Hmm
    return [[self objectAtIndex:0] hasMiscMergeKey:key];
}

@end

#if GNU_RUNTIME

static Ivar_t class_getInstanceVariable(Class aClass, const char *name)
{
    Class currClass;

    if (name == NULL) return NULL;

    for (currClass = aClass; currClass != Nil; currClass = currClass->super_class)
    {
        struct objc_ivar_list *ivars = aClass->ivars;
        int pos;

        for (pos = 0; pos < ivars->ivar_count; pos++)
        {
            Ivar_t currIvar = &(ivars->ivar_list[pos]);

            if (strcmp(currIvar->ivar_name, name) == 0) {
                return currIvar;
            }
        }
    }

    return NULL;
}

#endif
