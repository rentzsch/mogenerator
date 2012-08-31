#import <Cocoa/Cocoa.h>

@interface MyBaseClass : NSManagedObject {
	double ivar;
}

- (double)ivar;
- (void)setIvar:(double)ivar_;

@end
