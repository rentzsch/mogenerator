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

#import <Foundation/NSObject.h>

#if defined(NSFoundationVersionNumber10_0) || defined(GNUSTEP)
#define HAVE_NSNULL 1
#endif

#if HAVE_NSNULL
#import <Foundation/NSNull.h>
#else

@interface NSNull : NSObject
{
}

+ (NSNull *)null;

+ (id)allocWithZone:(NSZone *)zone;
- (void)dealloc;

- (id)description;

- (id)retain;
- (oneway void)release;
- (id)autorelease;
- (unsigned)retainCount;

- (id)copyWithZone:(NSZone *)zone;
- (id)copy;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

- (id)replacementObjectForCoder:(NSCoder *)aCoder;

- (id)valueForKey:(NSString *)key;

@end

#endif
