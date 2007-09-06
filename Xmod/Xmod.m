#import "Xmod.h"
#import "MethodSwizzle.h"

NSBundle *selfBundle;

@interface NSObject (xmod_saveModelToFile)
@end
@implementation NSObject (xmod_saveModelToFile)

- (BOOL)xmod_saveModelToFile:(NSString*)modelPackagePath_ {
	BOOL result = [self xmod_saveModelToFile:modelPackagePath_];
	if (result) {
		NSString *scriptPath = [selfBundle pathForResource:@"Xmod" ofType:@"scpt" inDirectory:@"Scripts"];
		NSAssert(scriptPath, @"failed to find Xmod.scpt");
		NSDictionary *scriptInitError = nil;
		NSAppleScript *script = [[[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:scriptPath]
																		error:&scriptInitError] autorelease];
		NSAssert1(!scriptInitError, @"failed to init Xmod.scpt: %@", scriptInitError);
		if (!scriptInitError) {
			NSDictionary *scriptExecuteError = nil;
			[script executeAndReturnError:&scriptExecuteError];
			NSAssert1(!scriptInitError, @"failed to execute Xmod.scpt: %@", scriptExecuteError);
		}
	}
	return result;
}

@end

@implementation Xmod

+ (void)pluginDidLoad:(NSBundle*)bundle_ {
	selfBundle = bundle_;
	
	//	Force loading of the Core Data XDesign plugin so we can find the class to swizzle its instance method.
	NSBundle *coreDataPlugin = [NSBundle bundleWithPath:@"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin"];
	NSAssert(coreDataPlugin, @"failed to load XDCoreDataModel.xdplugin");
	[coreDataPlugin load];
	
	Class persistenceDocumentController = NSClassFromString(@"XDPersistenceDocumentController");
	NSAssert(persistenceDocumentController, @"failed to load XDPersistenceDocumentController");
	
	BOOL swizzled = MethodSwizzle(persistenceDocumentController,
								  @selector(saveModelToFile:),
								  @selector(xmod_saveModelToFile:));
	NSAssert(swizzled, @"failed to swizzle -[XDPersistenceDocumentController saveModelToFile:]");
}

@end
