#import "HumanMO.h"

@implementation HumanMO

- (NSColor*)hairColor {
	return [NSUnarchiver unarchiveObjectWithData:[self hairColorStorage]];
}

- (void)setHairColor:(NSColor*)value_ {
	[self setHairColorStorage:[NSArchiver archivedDataWithRootObject:value_]];
}

@end
