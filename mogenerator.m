/*******************************************************************************
	mogenerator.m
		Copyright (c) 2006-2007 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

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
			return @"int";
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

NSString *ApplicationSupportSubdirectoryName = @"mogenerator";
static NSString* appSupportFileNamed(NSString *fileName_) {
	NSArray *appSupportDirectories = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask+NSLocalDomainMask, YES);
	assert(appSupportDirectories);
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDirectory;
	
	nsenumerate (appSupportDirectories, NSString*, appSupportDirectory) {
		if ([fileManager fileExistsAtPath:appSupportDirectory isDirectory:&isDirectory]) {
			NSString *appSupportSubdirectory = [appSupportDirectory stringByAppendingPathComponent:ApplicationSupportSubdirectoryName];
			if ([fileManager fileExistsAtPath:appSupportSubdirectory isDirectory:&isDirectory] && isDirectory) {
				NSString *appSupportFile = [appSupportSubdirectory stringByAppendingPathComponent:fileName_];
				if ([fileManager fileExistsAtPath:appSupportFile isDirectory:&isDirectory] && !isDirectory) {
					return appSupportFile;
				}
			}
		}
	}
	
	NSLog(@"appSupportFileNamed(@\"%@\"): file not found", fileName_);
	exit(1);
	return nil;
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

				if( ![[NSFileManager defaultManager] fileExistsAtPath:path]){
					fprintf(stderr, "mogenerator: error loading file at %s: no such file exists.\n", optarg);
					return ENOENT;
				}
					
				if ([[path pathExtension] isEqualToString:@"xcdatamodel"]) {
					//	We've been handed a .xcdatamodel data model, transparently compile it into a .mom managed object model.
					NSString *momc = [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"]
						? @"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"
						: @"/Developer/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc";
					
					tempMOMPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:[(id)CFUUIDCreateString(kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault)) autorelease]] stringByAppendingPathExtension:@"mom"];
					system([[NSString stringWithFormat:@"\"%@\" %@ %@", momc, path, tempMOMPath] UTF8String]); // Ignored system's result -- momc doesn't return any relevent error codes.
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
				printf("mogenerator 1.2. By Jonathan 'Wolf' Rentzsch + friends.\n");
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

	int machineFilesGenerated = 0;        
	int humanFilesGenerated = 0;
	
	if (model) {
		MiscMergeEngine *machineH = engineWithTemplatePath(appSupportFileNamed(@"machine.h.motemplate"));
		assert(machineH);
		MiscMergeEngine *machineM = engineWithTemplatePath(appSupportFileNamed(@"machine.m.motemplate"));
		assert(machineM);
		MiscMergeEngine *humanH = engineWithTemplatePath(appSupportFileNamed(@"human.h.motemplate"));
		assert(humanH);
		MiscMergeEngine *humanM = engineWithTemplatePath(appSupportFileNamed(@"human.m.motemplate"));
		assert(humanM);	

		int entityCount = [[model entities] count];

		if(entityCount == 0){ 
			printf("No entities found in model. No files will be generated.\n");
			NSLog(@"the model description is %@.", model);
		}
		
		nsenumerate ([model entities], NSEntityDescription, entity) {
			NSString *entityClassName = [entity managedObjectClassName];

			if ([entityClassName isEqualToString:@"NSManagedObject"] ||
				[entityClassName isEqualToString:gCustomBaseClass]){
				printf("skipping entity %s because it doesn't use a custom subclass.\n", 
					   [entityClassName cStringUsingEncoding:NSUTF8StringEncoding]);
				continue;
			}
			
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
				machineFilesGenerated++;
			}
			NSString *machineMFileName = [NSString stringWithFormat:@"_%@.m", entityClassName];
			if (![fm regularFileExistsAtPath:machineMFileName] || ![generatedMachineM isEqualToString:[NSString stringWithContentsOfFile:machineMFileName]]) {
				//	If the file doesn't exist or is different than what we just generated, write it out.
				[generatedMachineM writeToFile:machineMFileName atomically:NO];
				machineDirtied = YES;
				machineFilesGenerated++;
			}
			NSString *humanHFileName = [NSString stringWithFormat:@"%@.h", entityClassName];
			if ([fm regularFileExistsAtPath:humanHFileName]) {
				if (machineDirtied)
					[fm touchPath:humanHFileName];
			} else {
				[generatedHumanH writeToFile:humanHFileName atomically:NO];
				humanFilesGenerated++;
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
				humanFilesGenerated++;
			}
			
			[mfileContent appendFormat:@"#include \"%@\"\n#include \"%@\"\n", humanMFileName, machineMFileName];
		}
	}
	
	if (tempMOMPath) {
		[fm removeFileAtPath:tempMOMPath handler:nil];
	}
	bool mfileGenerated = NO;
	if (mfilePath && ![mfileContent isEqualToString:@""]) {
		[mfileContent writeToFile:mfilePath atomically:NO];
		mfileGenerated = YES;
	}
	
	printf("%d machine files%s %d human files%s generated.\n", machineFilesGenerated,
		   (mfileGenerated ? "," : " and"), humanFilesGenerated, (mfileGenerated ? " and one include.m file" : ""));
	
	[pool release];
	return 0;
}
