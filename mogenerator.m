/*******************************************************************************
	mogenerator.m - <http://github.com/rentzsch/mogenerator>
		Copyright (c) 2006-2010 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import "mogenerator.h"
#import "RegexKitLite.h"

NSString	*gCustomBaseClass;

@implementation NSManagedObjectModel (entitiesWithACustomSubclassVerbose)
- (NSArray*)entitiesWithACustomSubclassVerbose:(BOOL)verbose_ {
	NSMutableArray *result = [NSMutableArray array];
	
	if(verbose_ && [[self entities] count] == 0){ 
		ddprintf(@"No entities found in model. No files will be generated.\n(model description: %@)\n", self);
	}
	
	nsenumerate ([self entities], NSEntityDescription, entity) {
		NSString *entityClassName = [entity managedObjectClassName];
		
		if ([entityClassName isEqualToString:@"NSManagedObject"] || [entityClassName isEqualToString:gCustomBaseClass]){
			if (verbose_) {
				ddprintf(@"skipping entity %@ because it doesn't use a custom subclass.\n", 
						 entityClassName);
			}
		} else {
			[result addObject:entity];
		}
	}
	
	return [result sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"managedObjectClassName"
																									 ascending:YES] autorelease]]];
}
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

#pragma mark Fetch Request support

- (NSDictionary*)fetchRequestTemplates {
	// -[NSManagedObjectModel _fetchRequestTemplatesByName] is a private method, but it's the only way to get
	//	model fetch request templates without knowing their name ahead of time. rdar://problem/4901396 asks for
	//	a public method (-[NSManagedObjectModel fetchRequestTemplatesByName]) that does the same thing.
	//	If that request is fulfilled, this code won't need to be modified thanks to KVC lookup order magic.
    //  UPDATE: 10.5 now has a public -fetchRequestTemplatesByName method.
	NSDictionary *fetchRequests = [[self managedObjectModel] valueForKey:@"fetchRequestTemplatesByName"];
	
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[fetchRequests count]];
	nsenumerate ([fetchRequests allKeys], NSString, fetchRequestName) {
		NSFetchRequest *fetchRequest = [fetchRequests objectForKey:fetchRequestName];
		if ([fetchRequest entity] == self) {
			[result setObject:fetchRequest forKey:fetchRequestName];
		}
	}
	return result;
}

- (NSString *)_resolveKeyPathType:(NSString *)keyPath {
	NSArray *components = [keyPath componentsSeparatedByString:@"."];

	// Hope the set of keys in the key path consists of solely relationships. Abort otherwise
	
	NSEntityDescription *entity = self;
    nsenumerate(components, NSString, key) {
		NSRelationshipDescription *relationship = [[entity relationshipsByName] objectForKey:key];
		assert(relationship);
		entity = [relationship destinationEntity];
	}
	
	return [entity managedObjectClassName];
}

- (void)_processPredicate:(NSPredicate*)predicate_ bindings:(NSMutableArray*)bindings_ {
    if (!predicate_) return;
    
	if ([predicate_ isKindOfClass:[NSCompoundPredicate class]]) {
		nsenumerate([(NSCompoundPredicate*)predicate_ subpredicates], NSPredicate, subpredicate) {
			[self _processPredicate:subpredicate bindings:bindings_];
		}
	} else if ([predicate_ isKindOfClass:[NSComparisonPredicate class]]) {
		assert([[(NSComparisonPredicate*)predicate_ leftExpression] expressionType] == NSKeyPathExpressionType);
		NSExpression *lhs = [(NSComparisonPredicate*)predicate_ leftExpression];
		NSExpression *rhs = [(NSComparisonPredicate*)predicate_ rightExpression];
		switch([rhs expressionType]) {
			case NSConstantValueExpressionType:
			case NSEvaluatedObjectExpressionType:
			case NSKeyPathExpressionType:
			case NSFunctionExpressionType:
				//	Don't do anything with these.
				break;
			case NSVariableExpressionType: {
				// TODO SHOULD Handle LHS keypaths.
                
                NSString *type = nil;
                
                NSAttributeDescription *attribute = [[self attributesByName] objectForKey:[lhs keyPath]];
                if (attribute) {
                    type = [attribute objectAttributeType];
                } else {
                    type = [self _resolveKeyPathType:[lhs keyPath]];
                }
                type = [type stringByAppendingString:@"*"];
                
				[bindings_ addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [rhs variable], @"name",
                                      type, @"type",
                                      nil]];
			} break;
			default:
				assert(0 && "unknown NSExpression type");
		}
	}
}
- (NSArray*)prettyFetchRequests {
	NSDictionary *fetchRequests = [self fetchRequestTemplates];
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[fetchRequests count]];
	nsenumerate ([fetchRequests allKeys], NSString, fetchRequestName) {
		NSFetchRequest *fetchRequest = [fetchRequests objectForKey:fetchRequestName];
		NSMutableArray *bindings = [NSMutableArray array];
		[self _processPredicate:[fetchRequest predicate] bindings:bindings];
		[result addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           fetchRequestName, @"name",
                           bindings, @"bindings",
                           [NSNumber numberWithBool:[fetchRequestName hasPrefix:@"one"]], @"singleResult",
                           nil]];
	}
	return result;
}
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
- (NSString*)objectAttributeType {
#if MAC_OS_X_VERSION_MAX_ALLOWED < 1050
    #define NSTransformableAttributeType 1800
#endif
    if ([self attributeType] == NSTransformableAttributeType) {
        NSString *result = [[self userInfo] objectForKey:@"attributeValueClassName"];
        return result ? result : @"NSObject";
    } else {
        return [self attributeValueClassName];
    }
}
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

@implementation MOGeneratorApp

NSString *ApplicationSupportSubdirectoryName = @"mogenerator";
- (NSString*)appSupportFileNamed:(NSString*)fileName_ {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDirectory;
	
	if (templatePath) {
		if ([fileManager fileExistsAtPath:templatePath isDirectory:&isDirectory] && isDirectory) {
			return [templatePath stringByAppendingPathComponent:fileName_];
		}
	} else {
		NSArray *appSupportDirectories = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask+NSLocalDomainMask, YES);
		assert(appSupportDirectories);
		
		nsenumerate (appSupportDirectories, NSString*, appSupportDirectory) {
			if ([fileManager fileExistsAtPath:appSupportDirectory isDirectory:&isDirectory]) {
				NSString *appSupportSubdirectory = [appSupportDirectory stringByAppendingPathComponent:ApplicationSupportSubdirectoryName];
				if (templateGroup) {
					appSupportSubdirectory = [appSupportSubdirectory stringByAppendingPathComponent:templateGroup];
				}
				if ([fileManager fileExistsAtPath:appSupportSubdirectory isDirectory:&isDirectory] && isDirectory) {
					NSString *appSupportFile = [appSupportSubdirectory stringByAppendingPathComponent:fileName_];
					if ([fileManager fileExistsAtPath:appSupportFile isDirectory:&isDirectory] && !isDirectory) {
						return appSupportFile;
					}
				}
			}
		}
	}
	
	ddprintf(@"appSupportFileNamed:@\"%@\": file not found", fileName_);
	exit(EXIT_FAILURE);
	return nil;
}

- (void) application: (DDCliApplication *) app
    willParseOptions: (DDGetoptLongParser *) optionsParser;
{
    [optionsParser setGetoptLongOnly: YES];
    DDGetoptOption optionTable[] = 
    {
    // Long					Short   Argument options
    {@"model",				'm',    DDGetoptRequiredArgument},
    {@"base-class",			0,     DDGetoptRequiredArgument},
    // For compatibility:
    {@"baseClass",			0,      DDGetoptRequiredArgument},
    {@"includem",			0,      DDGetoptRequiredArgument},
    {@"template-path",		0,      DDGetoptRequiredArgument},
    // For compatibility:
    {@"templatePath",		0,      DDGetoptRequiredArgument},
    {@"output-dir",			'O',    DDGetoptRequiredArgument},
    {@"machine-dir",		'M',    DDGetoptRequiredArgument},
    {@"human-dir",			'H',    DDGetoptRequiredArgument},
    {@"template-group",		0,      DDGetoptRequiredArgument},
    {@"list-source-files",	0,      DDGetoptNoArgument},
    {@"orphaned",			0,      DDGetoptNoArgument},

    {@"help",				'h',    DDGetoptNoArgument},
    {@"version",			0,      DDGetoptNoArgument},
    {nil,					0,      0},
    };
    [optionsParser addOptionsFromTable: optionTable];
}

- (void) printUsage;
{
    ddprintf(@"%@: Usage [OPTIONS] <argument> [...]\n", DDCliApp);
    printf("\n"
           "  -m, --model MODEL             Path to model\n"
           "      --base-class CLASS        Custom base class\n"
           "      --includem FILE           Generate aggregate include file\n"
           "      --template-path PATH      Path to templates\n"
           "      --template-group NAME     Name of template group\n"
           "  -O, --output-dir DIR          Output directory\n"
           "  -M, --machine-dir DIR         Output directory for machine files\n"
           "  -H, --human-dir DIR           Output directory for human files\n"
		   "      --list-source-files		Only list model-related source files\n"
           "      --orphaned                Only list files whose entities no longer exist\n"
           "      --version                 Display version and exit\n"
           "  -h, --help                    Display this help and exit\n"
           "\n"
           "Implements generation gap codegen pattern for Core Data.\n"
           "Inspired by eogenerator.\n");
}

- (void) setModel: (NSString *) path;
{
    assert(!model); // Currently we only can load one model.

    if( ![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSString * reason = [NSString stringWithFormat: @"error loading file at %@: no such file exists", path];
        DDCliParseException * e = [DDCliParseException parseExceptionWithReason: reason
                                                                       exitCode: EX_NOINPUT];
        @throw e;
    }

    if ([[path pathExtension] isEqualToString:@"xcdatamodel"]) {
        //	We've been handed a .xcdatamodel data model, transparently compile it into a .mom managed object model.
        
        //  Find where Xcode installed momc this week.
        NSString *momc = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Developer/usr/bin/momc"]) { // Xcode 3.1 installs it here.
            momc = @"/Developer/usr/bin/momc";
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"]) { // Xcode 3.0.
            momc = @"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc";
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Developer/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"]) { // Xcode 2.4.
            momc = @"/Developer/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc";
        }
        assert(momc && "momc not found");
        
        tempMOMPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:[(id)CFUUIDCreateString(kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault)) autorelease]] stringByAppendingPathExtension:@"mom"];
        system([[NSString stringWithFormat:@"\"%@\" \"%@\" \"%@\"", momc, path, tempMOMPath] UTF8String]); // Ignored system's result -- momc doesn't return any relevent error codes.
        path = tempMOMPath;
    }
    model = [[[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]] autorelease];
    assert(model);
}

- (int) application: (DDCliApplication *) app
   runWithArguments: (NSArray *) arguments;
{
    if (_help) {
        [self printUsage];
        return EXIT_SUCCESS;
    }
    
    if (_version) {
        printf("mogenerator 1.17. By Jonathan 'Wolf' Rentzsch + friends.\n");
        return EXIT_SUCCESS;
    }
    
    gCustomBaseClass = [baseClass retain];
    NSString * mfilePath = includem;
	NSMutableString * mfileContent = [NSMutableString stringWithString:@""];
    if (outputDir == nil)
        outputDir = @"";
    if (machineDir == nil)
        machineDir = outputDir;
    if (humanDir == nil)
        humanDir = outputDir;

	NSFileManager *fm = [NSFileManager defaultManager];
	
	if (_orphaned) {
		NSMutableDictionary *entityFilesByName = [NSMutableDictionary dictionary];
		
		NSArray *srcDirs = [NSArray arrayWithObjects:machineDir, humanDir, nil];
		nsenumerate(srcDirs, NSString, srcDir) {
			if (![srcDir length]) {
				srcDir = [fm currentDirectoryPath];
			}
			nsenumerate([fm subpathsAtPath:srcDir], NSString, srcFileName) {
				#define MANAGED_OBJECT_SOURCE_FILE_REGEX	@"_?([a-zA-Z0-9_]+MO).(h|m|mm)" // Sadly /^(*MO).(h|m|mm)$/ doesn't work.
				if ([srcFileName isMatchedByRegex:MANAGED_OBJECT_SOURCE_FILE_REGEX]) {
					NSString *entityName = [[srcFileName captureComponentsMatchedByRegex:MANAGED_OBJECT_SOURCE_FILE_REGEX] objectAtIndex:1];
					if (![entityFilesByName objectForKey:entityName]) {
						[entityFilesByName setObject:[NSMutableSet set] forKey:entityName];
					}
					[[entityFilesByName objectForKey:entityName] addObject:srcFileName];
				}
			}
		}
		nsenumerate ([model entitiesWithACustomSubclassVerbose:NO], NSEntityDescription, entity) {
			[entityFilesByName removeObjectForKey:[entity managedObjectClassName]];
		}
		nsenumerate(entityFilesByName, NSSet, ophanedFiles) {
			nsenumerate(ophanedFiles, NSString, ophanedFile) {
				ddprintf(@"%@\n", ophanedFile);
			}
		}
		
		return EXIT_SUCCESS;
	}
    
	int machineFilesGenerated = 0;        
	int humanFilesGenerated = 0;
	
	if (model) {
		MiscMergeEngine *machineH = engineWithTemplatePath([self appSupportFileNamed:@"machine.h.motemplate"]);
		assert(machineH);
		MiscMergeEngine *machineM = engineWithTemplatePath([self appSupportFileNamed:@"machine.m.motemplate"]);
		assert(machineM);
		MiscMergeEngine *humanH = engineWithTemplatePath([self appSupportFileNamed:@"human.h.motemplate"]);
		assert(humanH);
		MiscMergeEngine *humanM = engineWithTemplatePath([self appSupportFileNamed:@"human.m.motemplate"]);
		assert(humanM);
		
		NSMutableArray	*humanMFiles = [NSMutableArray array],
						*humanHFiles = [NSMutableArray array],
						*machineMFiles = [NSMutableArray array],
						*machineHFiles = [NSMutableArray array];
		
		nsenumerate ([model entitiesWithACustomSubclassVerbose:YES], NSEntityDescription, entity) {
			NSString *generatedMachineH = [machineH executeWithObject:entity sender:nil];
			NSString *generatedMachineM = [machineM executeWithObject:entity sender:nil];
			NSString *generatedHumanH = [humanH executeWithObject:entity sender:nil];
			NSString *generatedHumanM = [humanM executeWithObject:entity sender:nil];
			
			NSString *entityClassName = [entity managedObjectClassName];
			BOOL machineDirtied = NO;
			
			// Machine header files.
			NSString *machineHFileName = [machineDir stringByAppendingPathComponent:
                [NSString stringWithFormat:@"_%@.h", entityClassName]];
			if (_listSourceFiles) {
				[machineHFiles addObject:machineHFileName];
			} else {
				if (![fm regularFileExistsAtPath:machineHFileName] || ![generatedMachineH isEqualToString:[NSString stringWithContentsOfFile:machineHFileName]]) {
					//	If the file doesn't exist or is different than what we just generated, write it out.
					[generatedMachineH writeToFile:machineHFileName atomically:NO];
					machineDirtied = YES;
					machineFilesGenerated++;
				}
			}
			
			// Machine source files.
			NSString *machineMFileName = [machineDir stringByAppendingPathComponent:
                [NSString stringWithFormat:@"_%@.m", entityClassName]];
			if (_listSourceFiles) {
				[machineMFiles addObject:machineMFileName];
			} else {
				if (![fm regularFileExistsAtPath:machineMFileName] || ![generatedMachineM isEqualToString:[NSString stringWithContentsOfFile:machineMFileName]]) {
					//	If the file doesn't exist or is different than what we just generated, write it out.
					[generatedMachineM writeToFile:machineMFileName atomically:NO];
					machineDirtied = YES;
					machineFilesGenerated++;
				}
			}
			
			// Human header files.
			NSString *humanHFileName = [humanDir stringByAppendingPathComponent:
                [NSString stringWithFormat:@"%@.h", entityClassName]];
			if (_listSourceFiles) {
				[humanHFiles addObject:humanHFileName];
			} else {
				if ([fm regularFileExistsAtPath:humanHFileName]) {
					if (machineDirtied)
						[fm touchPath:humanHFileName];
				} else {
					[generatedHumanH writeToFile:humanHFileName atomically:NO];
					humanFilesGenerated++;
				}
			}
			
			//	Human source files.
			NSString *humanMFileName = [humanDir stringByAppendingPathComponent:
                [NSString stringWithFormat:@"%@.m", entityClassName]];
			NSString *humanMMFileName = [humanDir stringByAppendingPathComponent:
                [NSString stringWithFormat:@"%@.mm", entityClassName]];
			if (![fm regularFileExistsAtPath:humanMFileName] && [fm regularFileExistsAtPath:humanMMFileName]) {
				//	Allow .mm human files as well as .m files.
				humanMFileName = humanMMFileName;
			}
			if (_listSourceFiles) {
				[humanMFiles addObject:humanMFileName];
			} else {
				if ([fm regularFileExistsAtPath:humanMFileName]) {
					if (machineDirtied)
						[fm touchPath:humanMFileName];
				} else {
					[generatedHumanM writeToFile:humanMFileName atomically:NO];
					humanFilesGenerated++;
				}
			}
			
			[mfileContent appendFormat:@"#include \"%@\"\n#include \"%@\"\n",
                [humanMFileName lastPathComponent], [machineMFileName lastPathComponent]];
		}
		
		if (_listSourceFiles) {
			NSArray *filesList = [NSArray arrayWithObjects:humanMFiles, humanHFiles, machineMFiles, machineHFiles, nil];
			nsenumerate (filesList, NSArray, files) {
				nsenumerate (files, NSString, fileName) {
					ddprintf(@"%@\n", fileName);
				}
			}
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
	
	if (!_listSourceFiles) {
		printf("%d machine files%s %d human files%s generated.\n", machineFilesGenerated,
			   (mfileGenerated ? "," : " and"), humanFilesGenerated, (mfileGenerated ? " and one include.m file" : ""));
	}
    
    return EXIT_SUCCESS;
}

@end

int main (int argc, char * const * argv)
{
    return DDCliAppRunWithClass([MOGeneratorApp class]);
}
