#import "Xmod.h"
#import "MethodSwizzle.h"

@interface NSObject (mogenerator_saveModelToFile)
@end
@implementation NSObject (mogenerator_saveModelToFile)

- (BOOL)mogenerator_saveModelToFile:(NSString*)modelPackagePath_ {
	BOOL result = [self mogenerator_saveModelToFile:modelPackagePath_];
	if (result) {
		NSString *modelPackageFolderPath = [modelPackagePath_ stringByDeletingLastPathComponent];
		NSString *mosFolderPath = [modelPackageFolderPath stringByAppendingPathComponent:@"MOs"];
		
		BOOL isDirectory;
		if ([[NSFileManager defaultManager] fileExistsAtPath:mosFolderPath isDirectory:&isDirectory] && isDirectory) {
			NSTask *mogenerator = [[[NSTask alloc] init] autorelease];
			[mogenerator setLaunchPath:@"/usr/bin/mogenerator"];
			[mogenerator setCurrentDirectoryPath:mosFolderPath];
			// -model ../MyDocument.xcdatamodel -includem include.mm
			[mogenerator setArguments:[NSArray arrayWithObjects:
				@"-model", modelPackagePath_,
				@"-includem", @"include.m",
				nil]];
			[mogenerator launch];
		}
	}
	return result;
}

@end

@implementation Xmod

+ (void)pluginDidLoad:(NSBundle*)bundle_ {
	//	Force loading of the Core Data XDesign plugin so we can find the class to swizzle its instance method.
	NSBundle *coreDataPlugin = [NSBundle bundleWithPath:@"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin"];
	NSAssert(coreDataPlugin, @"failed to load XDCoreDataModel.xdplugin");
	[coreDataPlugin load];
	
	Class persistenceDocumentController = NSClassFromString(@"XDPersistenceDocumentController");
	NSAssert(persistenceDocumentController, @"failed to load XDPersistenceDocumentController");
	
	BOOL swizzled = MethodSwizzle(persistenceDocumentController,
								  @selector(saveModelToFile:),
								  @selector(mogenerator_saveModelToFile:));
	NSAssert(swizzled, @"failed to swizzle -[XDPersistenceDocumentController saveModelToFile:]");
}

@end
