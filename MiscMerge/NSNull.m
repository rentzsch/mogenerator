//
//  NSNull.m
//
//	Written by Doug McClure
//
//	Copyright 2002-2004 by Don Yacktman and Doug McClure.
//	All rights reserved.
//
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//

#import "NSNull.h"
#import <limits.h>
#import <Foundation/NSString.h>

#if !HAVE_NSNULL

static NSNull *_instance;

@implementation NSNull

+ (id)null
{
    if ( _instance == nil )
        _instance = [(id)NSAllocateObject([NSNull class], 0, NULL) init];

    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone { return [self null]; }

- (void)dealloc         {}

- (id)description       { return @"<null>"; }

- (id)retain            { return self; }
- (oneway void)release  {}
- (id)autorelease       { return self; }
- (unsigned)retainCount { return UINT_MAX; }

- (id)copyWithZone:(NSZone *)zone { return self; };
- (id)copy              { return self; };

- (void)encodeWithCoder:(NSCoder *)aCoder {}
- (id)initWithCoder:(NSCoder *)aDecoder   { return self; }

- (id)replacementObjectForCoder:(NSCoder *)aCoder { return self; }

- (id)valueForKey:(NSString *)key { return nil; }

@end
#endif
