#import "Xmod.h"
#import "MethodSwizzle.h"

NSBundle *selfBundle;

static void runScriptNamed(NSString *scriptName) {
	NSString *scriptPath = [selfBundle pathForResource:scriptName ofType:@"scpt" inDirectory:@"Scripts"];
	NSCAssert1(scriptPath, @"failed to find %@.scpt", scriptName);
	NSDictionary *scriptInitError = nil;
	NSAppleScript *script = [[[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:scriptPath]
																	error:&scriptInitError] autorelease];
	NSCAssert2(!scriptInitError, @"failed to init %@.scpt: %@", scriptName, scriptInitError);
	if (!scriptInitError) {
		NSDictionary *scriptExecuteError = nil;
		[script executeAndReturnError:&scriptExecuteError];
		NSCAssert2(!scriptInitError, @"failed to execute %@.scpt: %@", scriptName, scriptExecuteError);
	}
}

@interface NSObject (xmod_saveModelToFile)
@end
@implementation NSObject (xmod_saveModelToFile)
- (BOOL)xmod_saveModelToFile:(NSString*)modelPackagePath_ {
	BOOL result = [self xmod_saveModelToFile:modelPackagePath_];
	if (result) {
		runScriptNamed(@"Xmod");
	}
	return result;
}
@end

@implementation Xmod

+ (void)pluginDidLoad:(NSBundle*)bundle_ {
	selfBundle = bundle_;
	[[self alloc] init];
	
	//	Force loading of the Core Data XDesign plugin so we can find the class to swizzle its instance method.
#define Xcode24_XDCoreDataModelPlugin @"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin"
#define Xcode25_XDCoreDataModelPlugin @"/Xcode2.5/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin"
	
	NSBundle *coreDataPlugin = nil;
	if ([[NSFileManager defaultManager] fileExistsAtPath:Xcode25_XDCoreDataModelPlugin]) {
		coreDataPlugin = [NSBundle bundleWithPath:Xcode25_XDCoreDataModelPlugin];
	} else {
		coreDataPlugin = [NSBundle bundleWithPath:Xcode24_XDCoreDataModelPlugin];
	}	
	NSAssert(coreDataPlugin, @"failed to load XDCoreDataModel.xdplugin");
	[coreDataPlugin load];
	
	Class persistenceDocumentController = NSClassFromString(@"XDPersistenceDocumentController");
	NSAssert(persistenceDocumentController, @"failed to load XDPersistenceDocumentController");
	
	BOOL swizzled = MethodSwizzle(persistenceDocumentController,
								  @selector(saveModelToFile:),
								  @selector(xmod_saveModelToFile:));
	NSAssert(swizzled, @"failed to swizzle -[XDPersistenceDocumentController saveModelToFile:]");
}

- (id)init {
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationDidFinishLaunching:)
													 name:NSApplicationDidFinishLaunchingNotification
												   object:nil];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification_ {
	NSMenu *designMenu = [[[NSApp mainMenu] itemWithTitle:@"Design"] submenu];
	NSMenu *dataModelMenu = [[designMenu itemWithTitle:@"Data Model"] submenu];
	
	NSMenuItem *myMenuItem = [dataModelMenu insertItemWithTitle:@"Autocustomize Entity Classes"
														 action:@selector(autocustomizeEntityClasses:)
												  keyEquivalent:@""
														atIndex:0];
	[myMenuItem setTarget:self];
}

- (IBAction)autocustomizeEntityClasses:(id)sender_ {
	runScriptNamed(@"Autocustomize Entity Classes");
}

@end
