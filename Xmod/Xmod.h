#import <Cocoa/Cocoa.h>
#import <objc/objc-class.h>

@interface Xmod : NSObject {
	NSBundle *bundle;
}
+ (id)sharedXmod;
- (id)initWithBundle:(NSBundle*)bundle_;
- (IBAction)autocustomizeEntityClasses:(id)sender_;
- (void)runScriptNamed:(NSString*)scriptName_;
@end