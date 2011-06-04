/* FoundationAdditions.h created by lindberg on Mon 20-Dec-1999 */

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import <Foundation/NSFileManager.h>

extern void ErrVPrintf(NSString *format, va_list arguments);
extern void ErrPrintf(NSString *format, ...);
extern void VPrintf(NSString *format, va_list arguments);
extern void Printf(NSString *format, ...);

/* Various Foundation methods for use by templates and/or EOGenerator */

@interface NSArray (FoundationAdditions)

- (NSArray *)reversedArray;

// Key-value additions (i.e. @reversedArray, @sortedNameArray, etc. keys)
- (id)computeReversedArrayForKey:(NSString *)key;
- (id)computeSortedNameArrayForKey:(NSString *)key;
- (id)computeSortedStringArrayForKey:(NSString *)key;

- (NSArray *)arrayByMakingObjectsPerformSelector:(SEL)aSelector;
- (NSArray *)arrayByMakingObjectsPerformSelector:(SEL)aSelector withObject:anObject;
- (NSArray *)arrayByMakingObjectsPerformSelector:(SEL)aSelector withObject:anObject withObject:anObject2;

@end

@interface NSString (FoundationAdditions)

- (NSString *)initialCapitalString;
- (NSString *)beautifyString;

@end

@interface NSFileManager (FoundationAdditions)

- (BOOL)directoryExistsAtPath:(NSString *)path;
- (BOOL)regularFileExistsAtPath:(NSString *)path;
- (NSString *)findFile:(NSString *)filename inSearchPath:(NSArray *)paths;
- (void)touchPath:(NSString *)filePath;

@end
