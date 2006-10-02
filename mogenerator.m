#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MiscMergeTemplate.h"
#import "MiscMergeCommandBlock.h"
#import "MiscMergeEngine.h"
#import "FoundationAdditions.h"
#import "nsenumerate.h"

#include <getopt.h>

NSString	*gCustomBaseClass;
@interface NSEntityDescription (customBaseClass)
- (BOOL)hasCustomBaseClass;
- (NSString*)customSuperentity;
@end
@implementation NSEntityDescription (customBaseClass)
- (BOOL)hasCustomBaseClass {
	return gCustomBaseClass ? YES : NO;
}
- (NSString*)customSuperentity {
	NSEntityDescription *superentity = [self superentity];
	if (superentity) {
		return [superentity managedObjectClassName];
	} else {
		return gCustomBaseClass ? gCustomBaseClass : @"NSManagedObject";
	}
}
@end

static MiscMergeEngine* engineWithTemplatePath(NSString *templatePath_) {
	MiscMergeTemplate *template = [[[MiscMergeTemplate alloc] init] autorelease];
	[template setStartDelimiter:@"<$" endDelimiter:@"$>"];
	[template parseContentsOfFile:templatePath_];
	
	return [[[MiscMergeEngine alloc] initWithTemplate:template] autorelease];
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSManagedObjectModel *model = nil;
	NSString	*tempMOMPath = nil;
	
	static struct option longopts[] = {
	{ "help",			no_argument,		NULL,	'h' },
	{ "version",		no_argument,		NULL,	'w' },
	{ "model",			required_argument,	NULL,	'm' },
	{ "baseClass",		required_argument,	NULL,	'b' },
	{ NULL,				0,					NULL,	0 },
	};
	int opt_char;
	while ((opt_char = getopt_long_only(argc, (char* const*)argv, "m:", longopts, NULL)) != -1) {
		switch (opt_char) {
			case 'm':
				assert(!model); // Currently we only can load one model.
				NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:optarg length:strlen(optarg)];
				if ([[path pathExtension] isEqualToString:@"xcdatamodel"]) {
					//	We've been handed a .xcdatamodel data model, transparently compile it into a .mom managed object model.
					tempMOMPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:[(id)CFUUIDCreateString(kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault)) autorelease]] stringByAppendingPathExtension:@"mom"];
					NSString *momc = [NSString stringWithFormat:@"\"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc\" %@ %@", path, tempMOMPath];
					system([momc UTF8String]); // Ignored system's result -- momc doesn't return any relevent error codes.
					path = tempMOMPath;
				}
				model = [[[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]] autorelease];
				assert(model);
				break;
			case 'b':
				gCustomBaseClass = [[NSString stringWithUTF8String:optarg] retain];
				break;
			case 'w':
				printf("mogenerator 1.0. By Jonathan 'Wolf' Rentzsch.\n");
				break;
			case 'h':
			default:
				printf("mogenerator [-model /path/to/file.xcdatamodel] [-version] [-help]\n");
				printf("Implements generation gap codegen pattern for Core Data. Inspired by eogenerator.\n");
		}
	}
	argc -= optind;
	argv += optind;
	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	if (model) {
		NSArray *appSupportFolders = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
		assert(appSupportFolders);
		assert([appSupportFolders count] == 1);
		NSString *mogeneratorAppSupportFolder = [[appSupportFolders objectAtIndex:0] stringByAppendingPathComponent:@"mogenerator"];
		
		MiscMergeEngine *machineH = engineWithTemplatePath([mogeneratorAppSupportFolder stringByAppendingPathComponent:@"machine.h.motemplate"]);
		MiscMergeEngine *machineM = engineWithTemplatePath([mogeneratorAppSupportFolder stringByAppendingPathComponent:@"machine.M.motemplate"]);
		MiscMergeEngine *humanH = engineWithTemplatePath([mogeneratorAppSupportFolder stringByAppendingPathComponent:@"human.h.motemplate"]);
		MiscMergeEngine *humanM = engineWithTemplatePath([mogeneratorAppSupportFolder stringByAppendingPathComponent:@"human.M.motemplate"]);
		
		nsenumerate ([model entities], NSEntityDescription, entity) {
			NSString *generatedMachineH = [machineH executeWithObject:entity sender:nil];
			NSString *generatedMachineM = [machineM executeWithObject:entity sender:nil];
			NSString *generatedHumanH = [humanH executeWithObject:entity sender:nil];
			NSString *generatedHumanM = [humanM executeWithObject:entity sender:nil];
			
			BOOL machineDirtied = NO;
			
			NSString *machineHFileName = [NSString stringWithFormat:@"_%@.h", [entity name]];
			if (![fm regularFileExistsAtPath:machineHFileName] || ![generatedMachineH isEqualToString:[NSString stringWithContentsOfFile:machineHFileName]]) {
				//	If the file doesn't exist or is different than what we just generated, write it out.
				[generatedMachineH writeToFile:machineHFileName atomically:NO];
				machineDirtied = YES;
			}
			NSString *machineMFileName = [NSString stringWithFormat:@"_%@.m", [entity name]];
			if (![fm regularFileExistsAtPath:machineMFileName] || ![generatedMachineM isEqualToString:[NSString stringWithContentsOfFile:machineMFileName]]) {
				//	If the file doesn't exist or is different than what we just generated, write it out.
				[generatedMachineM writeToFile:machineMFileName atomically:NO];
				machineDirtied = YES;
			}
			NSString *humanHFileName = [NSString stringWithFormat:@"%@.h", [entity name]];
			if ([fm regularFileExistsAtPath:humanHFileName]) {
				if (machineDirtied)
					[fm touchPath:humanHFileName];
			} else {
				[generatedHumanH writeToFile:humanHFileName atomically:NO];
			}
			NSString *humanMFileName = [NSString stringWithFormat:@"%@.m", [entity name]];
			if ([fm regularFileExistsAtPath:humanMFileName]) {
				if (machineDirtied)
					[fm touchPath:humanMFileName];
			} else {
				[generatedHumanM writeToFile:humanMFileName atomically:NO];
			}
		}
	}
	
	if (tempMOMPath) {
		[fm removeFileAtPath:tempMOMPath handler:nil];
	}
	
    [pool release];
    return 0;
}

	