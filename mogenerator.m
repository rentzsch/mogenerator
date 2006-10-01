#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MiscMergeTemplate.h"
#import "MiscMergeCommandBlock.h"
#import "MiscMergeEngine.h"
#import "FoundationAdditions.h"
#import "nsenumerate.h"

#include <getopt.h>

static MiscMergeEngine* engineWithTemplatePath(NSString *templatePath_) {
	MiscMergeTemplate *template = [[[MiscMergeTemplate alloc] init] autorelease];
	[template setStartDelimiter:@"<$" endDelimiter:@"$>"];
	[template parseContentsOfFile:templatePath_];
	
	return [[[MiscMergeEngine alloc] initWithTemplate:template] autorelease];
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSManagedObjectModel *model = nil;
	
	static struct option longopts[] = {
	{ "model",			required_argument,	NULL,	'm' },
	{ NULL,				0,					NULL,	0 },
	};
	int opt_char;
	while ((opt_char = getopt_long_only(argc, (char* const*)argv, "m:", longopts, NULL)) != -1) {
		switch (opt_char) {
			case 'm':
				assert(!model); // Currently we only can load one model.
				NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:optarg length:strlen(optarg)];
				model = [[[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]] autorelease];
				assert(model);
				break;
			default:
				printf("USAGE\n");
		}
	}
	argc -= optind;
	argv += optind;
	
	if (model) {
		NSArray *appSupportFolders = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
		assert(appSupportFolders);
		assert([appSupportFolders count] == 1);
		NSString *mogeneratorAppSupportFolder = [[appSupportFolders objectAtIndex:0] stringByAppendingPathComponent:@"mogenerator"];
		
		MiscMergeEngine *machineH = engineWithTemplatePath([mogeneratorAppSupportFolder stringByAppendingPathComponent:@"machine.h.motemplate"]);
		MiscMergeEngine *machineM = engineWithTemplatePath([mogeneratorAppSupportFolder stringByAppendingPathComponent:@"machine.M.motemplate"]);
		MiscMergeEngine *humanH = engineWithTemplatePath([mogeneratorAppSupportFolder stringByAppendingPathComponent:@"human.h.motemplate"]);
		MiscMergeEngine *humanM = engineWithTemplatePath([mogeneratorAppSupportFolder stringByAppendingPathComponent:@"human.M.motemplate"]);
		
		NSFileManager *fm = [NSFileManager defaultManager];
		
		nsenumerate ([model entities], NSEntityDescription, entity) {
			NSString *generatedMachineH = [machineH executeWithObject:entity sender:nil];
			NSString *generatedMachineM = [machineM executeWithObject:entity sender:nil];
			NSString *generatedHumanH = [humanH executeWithObject:entity sender:nil];
			NSString *generatedHumanM = [humanM executeWithObject:entity sender:nil];
			
			NSString *machineHFileName = [NSString stringWithFormat:@"_%@.h", [entity name]];
			if (![fm regularFileExistsAtPath:machineHFileName] || ![generatedMachineH isEqualToString:[NSString stringWithContentsOfFile:machineHFileName]]) {
				//	If the file doesn't exist or is different than what we just generated, write it out.
				[generatedMachineH writeToFile:machineHFileName atomically:NO];
			}
			NSString *machineMFileName = [NSString stringWithFormat:@"_%@.m", [entity name]];
			if (![fm regularFileExistsAtPath:machineMFileName] || ![generatedMachineM isEqualToString:[NSString stringWithContentsOfFile:machineMFileName]]) {
				//	If the file doesn't exist or is different than what we just generated, write it out.
				[generatedMachineM writeToFile:machineMFileName atomically:NO];
			}
			NSString *humanHFileName = [NSString stringWithFormat:@"%@.h", [entity name]];
			if (![fm regularFileExistsAtPath:humanHFileName]) {
				[generatedHumanH writeToFile:humanHFileName atomically:NO];
			}
			NSString *humanMFileName = [NSString stringWithFormat:@"%@.m", [entity name]];
			if (![fm regularFileExistsAtPath:humanMFileName]) {
				[generatedHumanM writeToFile:humanMFileName atomically:NO];
			}
		}
	}
	
    [pool release];
    return 0;
}

	