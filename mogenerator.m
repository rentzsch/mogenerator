/*******************************************************************************
	mogenerator.m - <http://github.com/rentzsch/mogenerator>
		Copyright (c) 2006-2011 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import "mogenerator.h"
#import "RegexKitLite.h"

static NSString *kTemplateVar = @"TemplateVar";
NSString	*gCustomBaseClass;
NSString	*gCustomBaseClassForced;

@interface NSEntityDescription (fetchedPropertiesAdditions)
- (NSDictionary *)fetchedPropertiesByName;
@end

@implementation NSEntityDescription (fetchedPropertiesAdditions)
- (NSDictionary *)fetchedPropertiesByName
{
	NSMutableDictionary *fetchedPropertiesByName = [NSMutableDictionary dictionary];
	
	nsenumerate ([self properties], NSPropertyDescription, property) {
		if([property isKindOfClass:[NSFetchedPropertyDescription class]])
			[fetchedPropertiesByName setObject:property forKey:[property name]];
	}
	
	return fetchedPropertiesByName;
}
@end

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
	if(!gCustomBaseClassForced) {
		NSEntityDescription *superentity = [self superentity];
		if (superentity) {
			return [superentity managedObjectClassName];
		} else {
			return gCustomBaseClass ? gCustomBaseClass : @"NSManagedObject";
		}
	} else {
		return gCustomBaseClassForced;
	}
}
/** @TypeInfo NSAttributeDescription */
- (NSArray*)noninheritedAttributes {
	NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	NSEntityDescription *superentity = [self superentity];
	if (superentity) {
		NSMutableArray *result = [[[[self attributesByName] allValues] mutableCopy] autorelease];
		[result removeObjectsInArray:[[superentity attributesByName] allValues]];
		return [result sortedArrayUsingDescriptors:sortDescriptors];
	} else {
		return [[[self attributesByName] allValues] sortedArrayUsingDescriptors:sortDescriptors];
	}
}
/** @TypeInfo NSAttributeDescription */
- (NSArray*)noninheritedRelationships {
	NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	NSEntityDescription *superentity = [self superentity];
	if (superentity) {
		NSMutableArray *result = [[[[self relationshipsByName] allValues] mutableCopy] autorelease];
		[result removeObjectsInArray:[[superentity relationshipsByName] allValues]];
		return [result sortedArrayUsingDescriptors:sortDescriptors];
	} else {
		return [[[self relationshipsByName] allValues] sortedArrayUsingDescriptors:sortDescriptors];
	}
}
/** @TypeInfo NSFetchedPropertyDescription */
- (NSArray*)noninheritedFetchedProperties {
	NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	NSEntityDescription *superentity = [self superentity];
	if (superentity) {
		NSMutableArray *result = [[[[self fetchedPropertiesByName] allValues] mutableCopy] autorelease];
		[result removeObjectsInArray:[[superentity fetchedPropertiesByName] allValues]];
		return [result sortedArrayUsingDescriptors:sortDescriptors];
	} else {
		return [[[self fetchedPropertiesByName] allValues]  sortedArrayUsingDescriptors:sortDescriptors];
	}
}
/** @TypeInfo NSAttributeDescription */
- (NSArray*)indexedNoninheritedAttributes {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isIndexed == YES"];
	return [[self noninheritedAttributes] filteredArrayUsingPredicate:predicate];
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
                    type = [attribute objectAttributeClassName];
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
						   [NSNumber numberWithBool:[bindings count] > 0], @"hasBindings",
                           [NSNumber numberWithBool:[fetchRequestName hasPrefix:@"one"]], @"singleResult",
                           nil]];
	}
	return result;
}
@end

@implementation NSAttributeDescription (typing)
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
			return @"int16_t";
			break;
		case NSInteger32AttributeType:
			return @"int32_t";
			break;
		case NSInteger64AttributeType:
			return @"int64_t";
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
- (NSString*)scalarAccessorMethodName {
	switch ([self attributeType]) {
		case NSInteger16AttributeType:
			return @"shortValue";
			break;
		case NSInteger32AttributeType:
			return @"intValue";
			break;
		case NSInteger64AttributeType:
			return @"longLongValue";
			break;
		case NSDoubleAttributeType:
			return @"doubleValue";
			break;
		case NSFloatAttributeType:
			return @"floatValue";
			break;
		case NSBooleanAttributeType:
			return @"boolValue";
			break;
		default:
			return nil;
	}
}
- (NSString*)scalarFactoryMethodName {
	switch ([self attributeType]) {
		case NSInteger16AttributeType:
			return @"numberWithShort:";
			break;
		case NSInteger32AttributeType:
			return @"numberWithInt:";
			break;
		case NSInteger64AttributeType:
			return @"numberWithLongLong:";
			break;
		case NSDoubleAttributeType:
			return @"numberWithDouble:";
			break;
		case NSFloatAttributeType:
			return @"numberWithFloat:";
			break;
		case NSBooleanAttributeType:
			return @"numberWithBool:";
			break;
		default:
			return nil;
	}
}
- (BOOL)hasDefinedAttributeType {
	return [self attributeType] != NSUndefinedAttributeType;
}
- (NSString*)objectAttributeClassName {
	NSString *result = nil;
	if ([self hasTransformableAttributeType]) {
        result = [[self userInfo] objectForKey:@"attributeValueClassName"];
		if (!result) {
			result = @"NSObject";
		}
    } else {
        result = [self attributeValueClassName];
    }
	return result;
}
- (NSString*)objectAttributeType {
	NSString *result = [self objectAttributeClassName];
	result = [result stringByAppendingString:@" *"];
	if ([result isEqualToString:@"NSObject *"]) {
		result = @"id";
	}
	return result;
}
- (BOOL)hasTransformableAttributeType {
	return ([self attributeType] == NSTransformableAttributeType);
}
@end

@implementation NSRelationshipDescription (collectionClassName)

- (NSString*)mutableCollectionClassName {
	return [self jr_isOrdered] ? @"NSMutableOrderedSet" : @"NSMutableSet";
}

- (NSString*)immutableCollectionClassName {
	return [self jr_isOrdered] ? @"NSOrderedSet" : @"NSSet";
}

- (BOOL)jr_isOrdered {
	if ([self respondsToSelector:@selector(isOrdered)]) {
        return [self isOrdered];
    } else {
        return NO;
    }
}

@end

@implementation NSString (camelCaseString)
- (NSString*)camelCaseString {
	NSArray *lowerCasedWordArray = [[self wordArray] arrayByMakingObjectsPerformSelector:@selector(lowercaseString)];
	NSUInteger wordIndex = 1, wordCount = [lowerCasedWordArray count];
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

- (id)init {
    self = [super init];
    if (self) {
        templateVar = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    [templateVar release];
    [super dealloc];
}

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
	{@"base-class-force",	0,     DDGetoptRequiredArgument},
    // For compatibility:
    {@"baseClass",			0,      DDGetoptRequiredArgument},
    {@"includem",			0,      DDGetoptRequiredArgument},
	{@"includeh",			0,      DDGetoptRequiredArgument},
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
	{@"template-var",		0,      DDGetoptKeyValueArgument},
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
		   "      --base-class-force CLASS  Same as --base-class except will force all entities to have the specified base class. Even if a super entity exists\n"
           "      --includem FILE           Generate aggregate include file for .m files for both human and machine generated source files\n"
           "      --includeh FILE           Generate aggregate include file for .h files for human generated source files only\n"
           "      --template-path PATH      Path to templates (absolute or relative to model path)\n"
           "      --template-group NAME     Name of template group\n"
		   "      --template-var KEY=VALUE  A key-value pair to pass to the template file. There can be many of these.\n"
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

- (NSString*)currentXcodePath {
	NSString *result = @"";
	
	@try {
		NSTask *task = [[[NSTask alloc] init] autorelease];
		[task setLaunchPath:@"/usr/bin/xcode-select"];
		
		[task setArguments:[NSArray arrayWithObject:@"-print-path"]];
		
		NSPipe *pipe = [NSPipe pipe];
		[task setStandardOutput:pipe];
		//	Ensures that the current tasks output doesn't get hijacked
		[task setStandardInput:[NSPipe pipe]];
		
		NSFileHandle *file = [pipe fileHandleForReading];
		
		[task launch];
		
		NSData *data = [file readDataToEndOfFile];
		result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		result = [result substringToIndex:[result length]-1]; // trim newline
	} @catch(NSException *ex) {
		ddprintf(@"WARNING couldn't launch /usr/bin/xcode-select\n");
	}
	
	return result;
}

- (void)setModel:(NSString*)path;
{
    assert(!model); // Currently we only can load one model.

	origModelBasePath = [path stringByDeletingLastPathComponent];
	
    if( ![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSString * reason = [NSString stringWithFormat: @"error loading file at %@: no such file exists", path];
        DDCliParseException * e = [DDCliParseException parseExceptionWithReason: reason
                                                                       exitCode: EX_NOINPUT];
        @throw e;
    }

    if ([[path pathExtension] isEqualToString:@"xcdatamodel"]) {
        //	We've been handed a .xcdatamodel data model, transparently compile it into a .mom managed object model.
        
        //  Find where Xcode installed momc this week.
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *momc = nil;
        NSString *defaultLocation = [NSString stringWithFormat:@"%@/usr/bin/momc", [self currentXcodePath]];
        
        if([fm fileExistsAtPath:defaultLocation]) {
            momc = defaultLocation;
        } else if ([fm fileExistsAtPath:@"/Applications/Xcode.app/Contents/Developer/usr/bin/momc"]) { 
            // Xcode 4.3 - Command Line Tools for Xcode
            momc = @"/Applications/Xcode.app/Contents/Developer/usr/bin/momc";
        } else if ([fm fileExistsAtPath:@"/Developer/usr/bin/momc"]) { // Xcode 3.1 installs it here.
            momc = @"/Developer/usr/bin/momc";
        } else if ([fm fileExistsAtPath:@"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"]) { // Xcode 3.0.
            momc = @"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc";
        } else if ([fm fileExistsAtPath:@"/Developer/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"]) { // Xcode 2.4.
            momc = @"/Developer/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc";
        }
        assert(momc && "momc not found");
        
        tempMOMPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] stringByAppendingPathExtension:@"mom"];
		
		NSArray *supportedMomcOptions = [NSArray arrayWithObjects:@"MOMC_NO_WARNINGS", @"MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS", @"MOMC_SUPPRESS_INVERSE_TRANSIENT_ERROR", nil];
		NSMutableString *momcOptions = [NSMutableString string];
		
		for (NSString *momcOption in supportedMomcOptions)
		{
			if([[[NSProcessInfo processInfo] environment] objectForKey:momcOption] != nil)
			{
				[momcOptions appendFormat:@" -%@ ", momcOption];
			}
		}
		
	    system([[NSString stringWithFormat:@"\"%@\" %@ \"%@\" \"%@\"", momc, momcOptions, path, tempMOMPath] UTF8String]); // Ignored system's result -- momc doesn't return any relevent error codes.
        path = tempMOMPath;
    }
    model = [[[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]] autorelease];
    assert(model);
}

- (void)validateOutputPath:(NSString *)path forType:(NSString *)type
{
	//	Ignore nil ones
	if (path == nil) {
		return;
	}
	
	NSString		*errorString = nil;
	NSError			*error = nil;
	NSFileManager	*fm = [NSFileManager defaultManager];
	BOOL			isDir = NO;
	
	//	Test to see if the path exists
	if ([fm fileExistsAtPath:path isDirectory:&isDir]) {
		if (!isDir) {
			errorString = [NSString stringWithFormat:@"%@ Directory path (%@) exists as a file.", type, path];
		}
	}
	//	Try to create path
	else {
		if (![fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
			errorString = [NSString stringWithFormat:@"Couldn't create %@ Directory (%@):%@", type, path, [error localizedDescription]];
		}
	}
	
	if (errorString != nil) {

		//	Print error message and exit with IO error
        ddprintf(errorString);
		exit(EX_IOERR);
	}
}

- (int) application: (DDCliApplication *) app
   runWithArguments: (NSArray *) arguments;
{
    if (_help) {
        [self printUsage];
        return EXIT_SUCCESS;
    }
    
    if (_version) {
        printf("mogenerator 1.25. By Jonathan 'Wolf' Rentzsch + friends.\n");
        return EXIT_SUCCESS;
    }

	if(baseClassForce) {
		gCustomBaseClassForced = [baseClassForce retain];
		gCustomBaseClass = gCustomBaseClassForced;
	} else {
		gCustomBaseClass = [baseClass retain];
	}

    NSString * mfilePath = includem;
	NSString * hfilePath = includeh;
	
	NSMutableString * mfileContent = [NSMutableString stringWithString:@""];
	NSMutableString * hfileContent = [NSMutableString stringWithString:@""];
	
	[self validateOutputPath:outputDir forType:@"Output"];
	[self validateOutputPath:machineDir forType:@"Machine Output"];
	[self validateOutputPath:humanDir forType:@"Human Output"];

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
	
	if (templatePath) {
		
		NSString* absoluteTemplatePath = nil;
		
		if (![templatePath isAbsolutePath]) {
			absoluteTemplatePath = [[origModelBasePath stringByAppendingPathComponent:templatePath] stringByStandardizingPath];
			
			// Be kind and try a relative Path of the parent xcdatamodeld folder of the model, if it exists
			if ((![fm fileExistsAtPath:absoluteTemplatePath]) && ([[origModelBasePath pathExtension] isEqualToString:@"xcdatamodeld"])) {
				absoluteTemplatePath = [[[origModelBasePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:templatePath] stringByStandardizingPath];
			}
		} else {
			absoluteTemplatePath = templatePath;
		}

		
		// if the computed absoluteTemplatePath exists, use it.
		if ([fm fileExistsAtPath:absoluteTemplatePath]) {
			templatePath = absoluteTemplatePath;
		}
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
		
		// Add the template var dictionary to each of the merge engines
		[machineH setEngineValue:templateVar forKey:kTemplateVar];
		[machineM setEngineValue:templateVar forKey:kTemplateVar];
		[humanH setEngineValue:templateVar forKey:kTemplateVar];
		[humanM setEngineValue:templateVar forKey:kTemplateVar];
		
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
				if (![fm regularFileExistsAtPath:machineHFileName] || ![generatedMachineH isEqualToString:[NSString stringWithContentsOfFile:machineHFileName encoding:NSUTF8StringEncoding error:nil]]) {
					//	If the file doesn't exist or is different than what we just generated, write it out.
					[generatedMachineH writeToFile:machineHFileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
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
				if (![fm regularFileExistsAtPath:machineMFileName] || ![generatedMachineM isEqualToString:[NSString stringWithContentsOfFile:machineMFileName encoding:NSUTF8StringEncoding error:nil]]) {
					//	If the file doesn't exist or is different than what we just generated, write it out.
					[generatedMachineM writeToFile:machineMFileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
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
					[generatedHumanH writeToFile:humanHFileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
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
					[generatedHumanM writeToFile:humanMFileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
					humanFilesGenerated++;
				}
			}
			
			[mfileContent appendFormat:@"#import \"%@\"\n#import \"%@\"\n",
                [humanMFileName lastPathComponent], [machineMFileName lastPathComponent]];
			
			[hfileContent appendFormat:@"#import \"%@\"\n", [humanHFileName lastPathComponent]];
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
		[fm removeItemAtPath:tempMOMPath error:nil];
	}
	bool mfileGenerated = NO;
	if (mfilePath && ![mfileContent isEqualToString:@""]) {
		[mfileContent writeToFile:mfilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
		mfileGenerated = YES;
	}

	bool hfileGenerated = NO;
	if (hfilePath && ![hfileContent isEqualToString:@""]) {
		[hfileContent writeToFile:hfilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
		hfileGenerated = YES;
	}

	if (!_listSourceFiles) {
		printf("%d machine files%s %d human files%s generated.\n", machineFilesGenerated,
			   (mfileGenerated ? "," : " and"), humanFilesGenerated, (mfileGenerated ? " and one include.m file" : ""));

		if(hfileGenerated) {
			printf("Aggregate header file was also generated to %s.\n", [hfilePath fileSystemRepresentation]);
		}
	}
    
    return EXIT_SUCCESS;
}

@end

int main (int argc, char * const * argv)
{
    return DDCliAppRunWithClass([MOGeneratorApp class]);
}
