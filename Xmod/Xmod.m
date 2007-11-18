#import "Xmod.h"
#import "MethodSwizzle.h"

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
	} else {
		//	Unknown territory, exit.
		return;
	}
	NSAssert(coreDataPlugin, @"failed to load XDCoreDataModel.xdplugin");
	[coreDataPlugin load];
	
	Class persistenceDocumentController = NSClassFromString(@"XDPersistenceDocumentController");
	NSAssert(persistenceDocumentController, @"failed to load XDPersistenceDocumentController");
	
	BOOL swizzled = MethodSwizzle(persistenceDocumentController,
								  @selector(saveModelToFile:),
								  @selector(xmod_saveModelToFile:));
	NSAssert(swizzled, @"failed to swizzle -[XDPersistenceDocumentController saveModelToFile:]");
	
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
	NSDictionary *scriptInitError = nil;
	NSAppleScript *script = [[[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:scriptPath]
																	error:&scriptInitError] autorelease];
	NSAssert2(!scriptInitError, @"failed to init %@.scpt: %@", scriptName_, scriptInitError);
	if (!scriptInitError) {
		NSDictionary *scriptExecuteError = nil;
		[script executeAndReturnError:&scriptExecuteError];
		NSAssert2(!scriptInitError, @"failed to execute %@.scpt: %@", scriptName_, scriptExecuteError);
	}
}

@end
