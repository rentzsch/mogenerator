#import "Xmod.h"
#import "JRSwizzle.h"

/*
Xcode 2.4
	10.4 SDK	ppc, i386
Xcode 2.5
	10.5 SDK	ppc, i386
Xcode 3.0
	10.5 SDK	ppc GC, ppc64 GC, i386 GC, x86_64 GC
Xcode 3.2
	10.6 SDK	i386 GC, x86_64 GC
*/

@interface NSObject (xmod_saveModelToFile)
@end
@implementation NSObject (xmod_saveModelToFile)
- (BOOL)xmod_saveModelToFile:(NSString*)modelPackagePath_ {
	BOOL result = [self xmod_saveModelToFile:modelPackagePath_];
	if (result)
		[[Xmod sharedXmod] performSelector:@selector(runScriptNamed:) withObject:@"Xmod" afterDelay:0.0];
	return result;
}
@end

@implementation Xmod

Xmod *gSharedXmod;

+ (void)pluginDidLoad:(NSBundle*)bundle_ {
	gSharedXmod = [[self alloc] initWithBundle:bundle_];
}

+ (id)sharedXmod {
	return gSharedXmod;
}

- (id)initWithBundle:(NSBundle*)bundle_ {
	self = [super init];
	if (self) {
		bundle = [bundle_ retain];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationDidFinishLaunching:)
													 name:NSApplicationDidFinishLaunchingNotification
												   object:nil];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification_ {
	//	Force loading of the Core Data XDesign plugin so we can find the class to swizzle its instance method.
	NSBundle *coreDataPlugin = nil;
	
	NSString *xcodeVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	NSAssert(xcodeVersion, @"failed to read Xcode version");
	if ([xcodeVersion isEqualToString:@"2.4"]) {
		coreDataPlugin = [NSBundle bundleWithPath:@"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin"];
	} else if ([xcodeVersion isEqualToString:@"2.5"]) {
		coreDataPlugin = [NSBundle bundleWithPath:@"/Xcode2.5/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin"];
	} else if ([xcodeVersion isEqualToString:@"3.0"] || [xcodeVersion hasPrefix:@"3.1"] || [xcodeVersion hasPrefix:@"3.2"]) {
		coreDataPlugin = [NSBundle bundleWithPath:@"/Developer/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin"];
	} else {
		NSLog(@"Xmod: unknown Xcode version (%@), not loading.", xcodeVersion);
		return;
	}
	NSAssert(coreDataPlugin, @"failed to load XDCoreDataModel.xdplugin");
	[coreDataPlugin load];
	
	Class persistenceDocumentController = NSClassFromString(@"XDPersistenceDocumentController");
	NSAssert(persistenceDocumentController, @"failed to load XDPersistenceDocumentController");
	
	NSError *error = nil;
	BOOL swizzled = [persistenceDocumentController jr_swizzleMethod:@selector(saveModelToFile:)
														 withMethod:@selector(xmod_saveModelToFile:)
															  error:&error];
	NSAssert1(swizzled, @"failed to swizzle -[XDPersistenceDocumentController saveModelToFile:]: %@", error);
	
	//	Install the Autocustomize menu item.
	NSMenu *designMenu = [[[NSApp mainMenu] itemWithTitle:@"Design"] submenu];
	NSMenu *dataModelMenu = [[designMenu itemWithTitle:@"Data Model"] submenu];
	
	NSMenuItem *myMenuItem = [dataModelMenu insertItemWithTitle:@"Autocustomize Entity Classes"
														 action:@selector(autocustomizeEntityClasses:)
												  keyEquivalent:@""
														atIndex:0];
	[myMenuItem setTarget:self];
}

- (IBAction)autocustomizeEntityClasses:(id)sender_ {
	[self runScriptNamed:@"Autocustomize Entity Classes"];
}

- (void)runScriptNamed:(NSString*)scriptName_ {
	NSString *scriptPath = [bundle pathForResource:scriptName_ ofType:@"scpt" inDirectory:@"Scripts"];
	NSAssert1(scriptPath, @"failed to find %@.scpt", scriptName_);
#if 1
	NSTask *osascriptTask = [[[NSTask alloc] init] autorelease];
	[osascriptTask setLaunchPath:@"/usr/bin/osascript"];
	[osascriptTask setArguments:[NSArray arrayWithObject:scriptPath]];
	[osascriptTask launch];
#else
	//  Executing an AppleScript inside Xcode's context is weird.
	//  Scripts like `tell app "Finder" to get folder of file` simply fail. I suspect rogue
	//	coercion handlers or namespace bugs. So now I just fire off an osascript invocation
	//	to give the script a clean nonweird enironment.
	NSDictionary *scriptInitError = nil;
	NSAppleScript *script = [[[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:scriptPath]
																	error:&scriptInitError] autorelease];
	NSAssert2(!scriptInitError, @"failed to init %@.scpt: %@", scriptName_, scriptInitError);
	if (!scriptInitError) {
		NSDictionary *scriptExecuteError = nil;
		[script executeAndReturnError:&scriptExecuteError];
		NSAssert2(!scriptInitError, @"failed to execute %@.scpt: %@", scriptName_, scriptExecuteError);
	}
#endif
}

@end
