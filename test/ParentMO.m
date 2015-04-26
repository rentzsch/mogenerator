#import "ParentMO.h"

@interface ParentMO ()

// Private interface goes here.

@end

@implementation ParentMO

- (void)addChildren:(NSOrderedSet*)value_ {
	[self.childrenSet unionOrderedSet:value_];
}
- (void)removeChildren:(NSOrderedSet*)value_ {
	[self.childrenSet minusOrderedSet:value_];
}
- (void)addChildrenObject:(ChildMO*)value_ {
	NSLog(@"addChildrenObject");
	[self.childrenSet addObject:value_];
}
- (void)removeChildrenObject:(ChildMO*)value_ {
	[self.childrenSet removeObject:value_];
}
- (void)insertObject:(ChildMO*)value inChildrenAtIndex:(NSUInteger)idx {
	NSLog(@"insertObject:%@ inChildrenAtIndex:%lu", value, idx);
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    NSLog(@"    old: %@", tmpOrderedSet);
    [tmpOrderedSet insertObject:value atIndex:idx];
    NSLog(@"    new: %@", tmpOrderedSet);
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"children"];
}
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"children"];
}
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"children"];
}
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"children"];
}
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(NSOrderedSet*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"children"];
}
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"children"];
}

@end
