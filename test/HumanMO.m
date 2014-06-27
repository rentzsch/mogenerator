#import "HumanMO.h"

@implementation HumanMO

- (NSColor*)hairColor {
	NSData *storage = [self hairColorStorage];
	return storage ? [NSUnarchiver unarchiveObjectWithData:storage] : nil;
}

- (void)setHairColor:(NSColor*)value_ {
	NSData *storage = value_ ? [NSArchiver archivedDataWithRootObject:value_] : nil;
	[self setHairColorStorage:storage];
}

@end
