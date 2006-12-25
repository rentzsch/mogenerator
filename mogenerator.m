#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MiscMergeTemplate.h"
#import "MiscMergeCommandBlock.h"
#import "MiscMergeEngine.h"
#import "FoundationAdditions.h"
#import "nsenumerate.h"
#import "NSString+MiscAdditions.h"

#include <getopt.h>

NSString	*gCustomBaseClass;

@interface NSEntityDescription (customBaseClass)
- (BOOL)hasCustomSuperentity;
- (NSString*)customSuperentity;
@end
@implementation NSEntityDescription (customBaseClass)
- (BOOL)hasCustomSuperentity {
	NSEntityDescription *superentity = [self superentity];
	if (superentity) {
		return YES;
	} else {
		return gCustomBaseClass ? YES : NO;
	}
}
- (NSString*)customSuperentity {
	NSEntityDescription *superentity = [self superentity];
	if (superentity) {
		return [superentity managedObjectClassName];
	} else {
		return gCustomBaseClass ? gCustomBaseClass : @"NSManagedObject";
	}
}
/** @TypeInfo NSAttributeDescription */
- (NSArray*)noninheritedAttributes {
	NSEntityDescription *superentity = [self superentity];
	if (superentity) {
		NSMutableArray *result = [[[[self attributesByName] allValues] mutableCopy] autorelease];
		[result removeObjectsInArray:[[superentity attributesByName] allValues]];
		return result;
	} else {
		return [[self attributesByName] allValues];
	}
}
/** @TypeInfo NSAttributeDescription */
- (NSArray*)noninheritedRelationships {
	NSEntityDescription *superentity = [self superentity];
	if (superentity) {
		NSMutableArray *result = [[[[self relationshipsByName] allValues] mutableCopy] autorelease];
		[result removeObjectsInArray:[[superentity relationshipsByName] allValues]];
		return result;
	} else {
		return [[self relationshipsByName] allValues];
	}
}
@end
@interface NSAttributeDescription (scalarAttributeType)
- (BOOL)hasScalarAttributeType;
- (NSString*)scalarAttributeType;
- (BOOL)hasDefinedAttributeType;
@end
@implementation NSAttributeDescription (scalarAttributeType)
- (BOOL)hasScalarAttributeType {
	switch ([self attributeType]) {
		case NSInteger16AttributeType:
		case NSInteger32AttributeType:
		case NSInteger64AttributeType:
		case NSDoubleAttributeType:
		case NSFloatAttributeType:
		case NSBooleanAttributeType:
			return YES;
			break;
		default:
			return NO;
	}
}
- (NSString*)scalarAttributeType {
	switch ([self attributeType]) {
		case NSInteger16AttributeType:
			return @"short";
			break;
		case NSInteger32AttributeType:
			return @"long";
			break;
		case NSInteger64AttributeType:
			return @"long long";
			break;
		case NSDoubleAttributeType:
			return @"double";
			break;
		case NSFloatAttributeType:
			return @"float";
			break;
		case NSBooleanAttributeType:
			return @"BOOL";
			break;
		default:
			return nil;
	}
}
- (BOOL)hasDefinedAttributeType {
	return [self attributeType] != NSUndefinedAttributeType;
}
@end
@interface NSString (camelCaseString)
- (NSString*)camelCaseString;
@end
@implementation NSString (camelCaseString)
- (NSString*)camelCaseString {
	NSArray *lowerCasedWordArray = [[self wordArray] arrayByMakingObjectsPerformSelector:@selector(lowercaseString)];
	unsigned wordIndex = 1, wordCount = [lowerCasedWordArray count];
	NSMutableArray *camelCasedWordArray = [NSMutableArray arrayWithCapacity:wordCount];
	if (wordCount)
		[camelCasedWordArray addObject:[lowerCasedWordArray objectAtIndex:0]];
	for (; wordIndex < wordCount; wordIndex++) {
		[camelCasedWordArray addObject:[[lowerCasedWordArray objectAtIndex:wordIndex] initialCapitalString]];
	}
	return [camelCasedWordArray componentsJoinedByString:@""];
}
@end

static MiscMergeEngine* engineWithTemplatePath(NSString *templatePath_) {
	MiscMergeTemplate *template = [[[MiscMergeTemplate alloc] init] autorelease];
	[template setStartDelimiter:@"<$" endDelimiter:@"$>"];
	[template parseContentsOfFile:templatePath_];
	
	return [[[MiscMergeEngine alloc] initWithTemplate:template] autorelease];
}

#define DEOPT_(OPTION_NAME) OPTION_NAME+(sizeof("opt_")-1)
#define LONG_OPT(OPTION_NAME, HAS_ARG)	{DEOPT_(#OPTION_NAME), HAS_ARG, NULL, OPTION_NAME}
#define LONG_OPT_LAST { NULL,0,NULL,0 }

enum {
	opt_help = 1,
	opt_version,
	opt_model,
	opt_baseClass,
	opt_includem
};

int main (int argc, const char * argv[]) {
    NSAutoreleasePool	*pool = [[NSAutoreleasePool alloc] init];
	
	NSManagedObjectModel *model = nil;
	NSString			*tempMOMPath = nil;
	NSString			*mfilePath = nil;
	NSMutableString		*mfileContent = [NSMutableString stringWithString:@""];
	
	static struct option longopts[] = {
		LONG_OPT(opt_help, no_argument),
		LONG_OPT(opt_version, no_argument),
		LONG_OPT(opt_model, required_argument),
		LONG_OPT(opt_baseClass, required_argument),
		LONG_OPT(opt_includem, required_argument),
		LONG_OPT_LAST
	};
	int opt_code;
	while ((opt_code = getopt_long_only(argc, (char* const*)argv, "m:", longopts, NULL)) != -1) {
		switch (opt_code) {
			case opt_model:
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
			case opt_baseClass:
				gCustomBaseClass = [NSString stringWithUTF8String:optarg];
				break;
			case opt_includem:
				assert(!mfilePath);
				mfilePath = [NSString stringWithUTF8String:optarg];
				assert(mfilePath);
				assert([mfilePath length]);
				break;
			case opt_version:
				printf("mogenerator 1.1. By Jonathan 'Wolf' Rentzsch.\n");
				break;
			case opt_help:
			default:
				printf("mogenerator [-model /path/to/file.xcdatamodel] [-baseClass MyBaseClassMO] [-includem include.m] [-version] [-help]\n");
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
			NSString *entityClassName = [entity managedObjectClassName];
			if (![entityClassName isEqualToString:@"NSManagedObject"] && ![entityClassName isEqualToString:gCustomBaseClass]) {
				NSString *generatedMachineH = [machineH executeWithObject:entity sender:nil];
				NSString *generatedMachineM = [machineM executeWithObject:entity sender:nil];
				NSString *generatedHumanH = [humanH executeWithObject:entity sender:nil];
				NSString *generatedHumanM = [humanM executeWithObject:entity sender:nil];
				
				BOOL machineDirtied = NO;
				
				NSString *machineHFileName = [NSString stringWithFormat:@"_%@.h", entityClassName];
				if (![fm regularFileExistsAtPath:machineHFileName] || ![generatedMachineH isEqualToString:[NSString stringWithContentsOfFile:machineHFileName]]) {
					//	If the file doesn't exist or is different than what we just generated, write it out.
					[generatedMachineH writeToFile:machineHFileName atomically:NO];
					machineDirtied = YES;
				}
				NSString *machineMFileName = [NSString stringWithFormat:@"_%@.m", entityClassName];
				if (![fm regularFileExistsAtPath:machineMFileName] || ![generatedMachineM isEqualToString:[NSString stringWithContentsOfFile:machineMFileName]]) {
					//	If the file doesn't exist or is different than what we just generated, write it out.
					[generatedMachineM writeToFile:machineMFileName atomically:NO];
					machineDirtied = YES;
				}
				NSString *humanHFileName = [NSString stringWithFormat:@"%@.h", entityClassName];
				if ([fm regularFileExistsAtPath:humanHFileName]) {
					if (machineDirtied)
						[fm touchPath:humanHFileName];
				} else {
					[generatedHumanH writeToFile:humanHFileName atomically:NO];
				}
				NSString *humanMFileName = [NSString stringWithFormat:@"%@.m", entityClassName];
				NSString *humanMMFileName = [NSString stringWithFormat:@"%@.mm", entityClassName];
				if (![fm regularFileExistsAtPath:humanMFileName] && [fm regularFileExistsAtPath:humanMMFileName]) {
					//	Allow .mm human files as well as .m files.
					humanMFileName = humanMMFileName;
				}
				
				if ([fm regularFileExistsAtPath:humanMFileName]) {
					if (machineDirtied)
						[fm touchPath:humanMFileName];
				} else {
					[generatedHumanM writeToFile:humanMFileName atomically:NO];
				}
				
				[mfileContent appendFormat:@"#include \"%@\"\n#include \"%@\"\n", humanMFileName, machineMFileName];
			}
		}
	}
	
	if (tempMOMPath) {
		[fm removeFileAtPath:tempMOMPath handler:nil];
	}
	if (mfilePath) {
		[mfileContent writeToFile:mfilePath atomically:NO];
	}
	
    [pool release];
    return 0;
}
