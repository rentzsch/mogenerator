// mogenerator.m
//   Copyright (c) 2006-2013 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/mit
//   http://github.com/rentzsch/mogenerator

#import "mogenerator.h"
#import "RegexKitLite.h"

static NSString * const kTemplateVar = @"TemplateVar";
NSString  *gCustomBaseClass;
NSString  *gCustomBaseClassImport;
NSString  *gCustomBaseClassForced;

@interface NSEntityDescription (fetchedPropertiesAdditions)
- (NSDictionary*)fetchedPropertiesByName;
@end

@implementation NSEntityDescription (fetchedPropertiesAdditions)
- (NSDictionary*)fetchedPropertiesByName {
    NSMutableDictionary *fetchedPropertiesByName = [NSMutableDictionary dictionary];
    
    nsenumerate ([self properties], NSPropertyDescription, property) {
        if ([property isKindOfClass:[NSFetchedPropertyDescription class]]) {
            [fetchedPropertiesByName setObject:property forKey:[property name]];
        }
    }
    
    return fetchedPropertiesByName;
}
@end

@interface NSEntityDescription (userInfoAdditions)
- (BOOL)hasUserInfoKeys;
- (NSDictionary *)userInfoByKeys;
@end

@implementation NSEntityDescription (userInfoAdditions)
- (BOOL)hasUserInfoKeys {
	return ([self.userInfo count] > 0);
}

- (NSDictionary *)userInfoByKeys
{
	NSMutableDictionary *userInfoByKeys = [NSMutableDictionary dictionary];

	for (NSString *key in self.userInfo)
		[userInfoByKeys setObject:[NSDictionary dictionaryWithObjectsAndKeys:key, @"key", [self.userInfo objectForKey:key], @"value", nil] forKey:key];

	return userInfoByKeys;
}
@end

@implementation NSManagedObjectModel (entitiesWithACustomSubclassVerbose)
- (NSArray*)entitiesWithACustomSubclassInConfiguration:(NSString*)configuration_ verbose:(BOOL)verbose_ {
    NSMutableArray *result = [NSMutableArray array];
    NSArray* allEntities = nil;
    
    if (nil == configuration_) {
        allEntities = [self entities];
    }
    else if (NSNotFound != [[self configurations] indexOfObject:configuration_]){
        allEntities = [self entitiesForConfiguration:configuration_];
    }
    else {
        if (verbose_){
            ddprintf(@"No configuration %@ found in model. No files will be generated.\n(model configurations: %@)\n", configuration_, [self configurations]);
        }
        return nil;
    }
    
    if (verbose_ && [allEntities count] == 0){
        ddprintf(@"No entities found in model (or in specified configuration). No files will be generated.\n(model description: %@)\n", self);
    }
    
    nsenumerate (allEntities, NSEntityDescription, entity) {
        NSString *entityClassName = [entity managedObjectClassName];
        
        if ([entity hasCustomClass]){
            [result addObject:entity];
        } else {
            if (verbose_) {
                ddprintf(@"skipping entity %@ (%@) because it doesn't use a custom subclass.\n", 
                         entity.name, entityClassName);
            }
        }
    }
    
    return [result sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"managedObjectClassName"
                                                                                                     ascending:YES] autorelease]]];
}
@end


@implementation NSEntityDescription (customBaseClass)
- (BOOL)hasCustomBaseCaseImport {
    return gCustomBaseClassImport == nil ? NO : YES;
}
- (NSString*)baseClassImport {
    return gCustomBaseClassImport;
}

- (BOOL)hasCustomClass {
    NSString *entityClassName = [self managedObjectClassName];
    BOOL result = !([entityClassName isEqualToString:@"NSManagedObject"]
        || [entityClassName isEqualToString:@""]
        || [entityClassName isEqualToString:gCustomBaseClass]);
    return result;
}

- (BOOL)hasSuperentity {
    NSEntityDescription *superentity = [self superentity];
    if (superentity) {
        return YES;
    }
    return NO;
}

- (BOOL)hasCustomSuperentity {
    NSString *forcedBaseClass = [self forcedCustomBaseClass];
    if (!forcedBaseClass) {
        NSEntityDescription *superentity = [self superentity];
        if (superentity) {
            return [superentity hasCustomClass] ? YES : NO;
        } else {
            return gCustomBaseClass ? YES : NO;
        }
    } else {
        return YES;
    }
}

- (NSString*)customSuperentity {
    NSString *forcedBaseClass = [self forcedCustomBaseClass];
    if (!forcedBaseClass) {
        NSEntityDescription *superentity = [self superentity];
        if (superentity) {
            return [superentity managedObjectClassName];
        } else {
            return gCustomBaseClass ? gCustomBaseClass : @"NSManagedObject";
        }
    } else {
        return forcedBaseClass;
    }
}
- (NSString*)forcedCustomBaseClass {
    NSString* userInfoCustomBaseClass = [[self userInfo] objectForKey:@"mogenerator.customBaseClass"];
    return userInfoCustomBaseClass ? userInfoCustomBaseClass : gCustomBaseClassForced;
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
- (NSArray*)noninheritedAttributesSansType {
    NSArray *attributeDescriptions = [self noninheritedAttributes];
    NSMutableArray *filteredAttributeDescriptions = [NSMutableArray arrayWithCapacity:[attributeDescriptions count]];
    
    nsenumerate(attributeDescriptions, NSAttributeDescription, attributeDescription) {
        if (![[attributeDescription name] isEqualToString:@"type"]) {
            [filteredAttributeDescriptions addObject:attributeDescription];
        }
    }
    return filteredAttributeDescriptions;
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
/** @TypeInfo NSEntityUserInfoDescription */
- (NSArray*)userInfoKeyValues {
	NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES]];
	NSEntityDescription *superentity = [self superentity];
	if (superentity) {
		NSMutableArray *result = [[[[self userInfoByKeys] allValues] mutableCopy] autorelease];
		[result removeObjectsInArray:[[superentity userInfoByKeys] allValues]];
		return [result sortedArrayUsingDescriptors:sortDescriptors];
	} else {
		return [[[self userInfoByKeys] allValues] sortedArrayUsingDescriptors:sortDescriptors];
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
    //  model fetch request templates without knowing their name ahead of time. rdar://problem/4901396 asks for
    //  a public method (-[NSManagedObjectModel fetchRequestTemplatesByName]) that does the same thing.
    //  If that request is fulfilled, this code won't need to be modified thanks to KVC lookup order magic.
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

- (NSString*)_resolveKeyPathType:(NSString*)keyPath {
    NSArray *components = [keyPath componentsSeparatedByString:@"."];

    // Hope the set of keys in the key path consists of solely relationships. Abort otherwise
    
    NSEntityDescription *entity = self;
    nsenumerate(components, NSString, key) {
        id property = [[entity propertiesByName] objectForKey:key];
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            NSString *result = [property objectAttributeType];
            return [result substringToIndex:[result length] -1];
        } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
            entity = [property destinationEntity];
        }
        assert(property);
    }
    
    return [entity managedObjectClassName];
}

// auxiliary function
- (BOOL)bindingsArray:(NSArray*)bindings containsVariableNamed:(NSString*)name {
    for (NSDictionary *dict in bindings) {
        if ([[dict objectForKey:@"name"] isEqual:name]) {
            return YES;
        }
    }
    return NO;
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
                //  Don't do anything with these.
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
                // make sure that no repeated variables are entered here.
                if (![self bindingsArray:bindings_ containsVariableNamed:[rhs variable]]) {
                    [bindings_ addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [rhs variable], @"name",
                                      type, @"type",
                                      nil]];
                }
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
- (NSArray*)objectAttributeTransformableProtocols {
    if ([self hasAttributeTransformableProtocols]) {
        NSString *protocolsString = [[self userInfo] objectForKey:@"attributeTransformableProtocols"];
        NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@", "];
        NSMutableArray *protocols = [NSMutableArray arrayWithArray:[protocolsString componentsSeparatedByCharactersInSet:removeCharSet]];
        [protocols removeObject:@""];
        return protocols;
    }
    return nil;
}
- (BOOL)hasAttributeTransformableProtocols {
    return [self hasTransformableAttributeType] && [[self userInfo] objectForKey:@"attributeTransformableProtocols"];
}
- (NSString*)objectAttributeType {
    NSString *result = [self objectAttributeClassName];
    if ([result isEqualToString:@"Class"]) {
        // `Class` (don't append asterisk).
    } else if ([result rangeOfString:@"<"].location != NSNotFound) {
        // `id<Protocol1,Protocol2>` (don't append asterisk).
    } else if ([result isEqualToString:@"NSObject"]) {
        result = @"id";
    } else {
        result = [result stringByAppendingString:@"*"]; // Make it a pointer.
    }
    return result;
}
- (BOOL)hasTransformableAttributeType {
    return ([self attributeType] == NSTransformableAttributeType);
}

- (BOOL)isReadonly {
    NSString *readonlyUserinfoValue = [[self userInfo] objectForKey:@"mogenerator.readonly"];
    if (readonlyUserinfoValue != nil) {
        return YES;
    }
    return NO;
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

@interface MogeneratorTemplateDesc : NSObject {
    NSString *templateName;
    NSString *templatePath;
}
- (id)initWithName:(NSString*)name_ path:(NSString*)path_;
- (NSString*)templateName;
- (void)setTemplateName:(NSString*)name_;
- (NSString*)templatePath;
- (void)setTemplatePath:(NSString*)path_;
@end

static MiscMergeEngine* engineWithTemplateDesc(MogeneratorTemplateDesc *templateDesc_) {
    MiscMergeTemplate *template = [[[MiscMergeTemplate alloc] init] autorelease];
    [template setStartDelimiter:@"<$" endDelimiter:@"$>"];
    if ([templateDesc_ templatePath]) {
        [template parseContentsOfFile:[templateDesc_ templatePath]];
    } else {
        NSData *templateData = [[NSBundle mainBundle] objectForInfoDictionaryKey:[templateDesc_ templateName]];
        assert(templateData);
        NSString *templateString = [[[NSString alloc] initWithData:templateData encoding:NSASCIIStringEncoding] autorelease];
        [template setFilename:[@"x-__info_plist://" stringByAppendingString:[templateDesc_ templateName]]];
        [template parseString:templateString];
    }
    
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
- (MogeneratorTemplateDesc*)templateDescNamed:(NSString*)fileName_ {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    
    if (templatePath) {
        if ([fileManager fileExistsAtPath:templatePath isDirectory:&isDirectory] && isDirectory) {
            return [[[MogeneratorTemplateDesc alloc] initWithName:fileName_
                                                             path:[templatePath stringByAppendingPathComponent:fileName_]] autorelease];
        }
    } else if (templateGroup) {
        NSArray *appSupportDirectories = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask+NSLocalDomainMask, YES);
        assert(appSupportDirectories);
        
        nsenumerate (appSupportDirectories, NSString*, appSupportDirectory) {
            if ([fileManager fileExistsAtPath:appSupportDirectory isDirectory:&isDirectory]) {
                NSString *appSupportSubdirectory = [appSupportDirectory stringByAppendingPathComponent:ApplicationSupportSubdirectoryName];
                appSupportSubdirectory = [appSupportSubdirectory stringByAppendingPathComponent:templateGroup];
                if ([fileManager fileExistsAtPath:appSupportSubdirectory isDirectory:&isDirectory] && isDirectory) {
                    NSString *appSupportFile = [appSupportSubdirectory stringByAppendingPathComponent:fileName_];
                    if ([fileManager fileExistsAtPath:appSupportFile isDirectory:&isDirectory] && !isDirectory) {
                        return [[[MogeneratorTemplateDesc alloc] initWithName:fileName_ path:appSupportFile] autorelease];
                    }
                }
            }
        }
    } else {
        return [[[MogeneratorTemplateDesc alloc] initWithName:fileName_ path:nil] autorelease];
    }
    
    ddprintf(@"templateDescNamed:@\"%@\": file not found", fileName_);
    exit(EXIT_FAILURE);
    return nil;
}

- (void)application:(DDCliApplication*)app
   willParseOptions:(DDGetoptLongParser*)optionsParser;
{
    [optionsParser setGetoptLongOnly:YES];
    DDGetoptOption optionTable[] = 
    {
    // Long                 Short   Argument options
    {@"model",              'm',    DDGetoptRequiredArgument},
    {@"configuration",      'C',    DDGetoptRequiredArgument},
    {@"base-class",         0,     DDGetoptRequiredArgument},
    {@"base-class-import",  0,     DDGetoptRequiredArgument},
    {@"base-class-force",   0,     DDGetoptRequiredArgument},
    // For compatibility:
    {@"baseClass",          0,      DDGetoptRequiredArgument},
    {@"includem",           0,      DDGetoptRequiredArgument},
    {@"includeh",           0,      DDGetoptRequiredArgument},
    {@"template-path",      0,      DDGetoptRequiredArgument},
    // For compatibility:
    {@"templatePath",       0,      DDGetoptRequiredArgument},
    {@"output-dir",         'O',    DDGetoptRequiredArgument},
    {@"machine-dir",        'M',    DDGetoptRequiredArgument},
    {@"human-dir",          'H',    DDGetoptRequiredArgument},
    {@"template-group",     0,      DDGetoptRequiredArgument},
    {@"list-source-files",  0,      DDGetoptNoArgument},
    {@"orphaned",           0,      DDGetoptNoArgument},

    {@"help",               'h',    DDGetoptNoArgument},
    {@"version",            0,      DDGetoptNoArgument},
    {@"template-var",       0,      DDGetoptKeyValueArgument},
    {nil,                   0,      0},
    };
    [optionsParser addOptionsFromTable:optionTable];
}

- (void)printUsage {
    ddprintf(@"%@: Usage [OPTIONS] <argument> [...]\n", DDCliApp);
    printf("\n"
           "  -m, --model MODEL             Path to model\n"
           "  -C, --configuration CONFIG    Only consider entities included in the named configuration\n"
           "      --base-class CLASS        Custom base class\n"
           "      --base-class-import TEXT        Imports base class as #import TEXT\n"
           "      --base-class-force CLASS  Same as --base-class except will force all entities to have the specified base class. Even if a super entity exists\n"
           "      --includem FILE           Generate aggregate include file for .m files for both human and machine generated source files\n"
           "      --includeh FILE           Generate aggregate include file for .h files for human generated source files only\n"
           "      --template-path PATH      Path to templates (absolute or relative to model path)\n"
           "      --template-group NAME     Name of template group\n"
           "      --template-var KEY=VALUE  A key-value pair to pass to the template file. There can be many of these.\n"
           "  -O, --output-dir DIR          Output directory\n"
           "  -M, --machine-dir DIR         Output directory for machine files\n"
           "  -H, --human-dir DIR           Output directory for human files\n"
           "      --list-source-files       Only list model-related source files\n"
           "      --orphaned                Only list files whose entities no longer exist\n"
           "      --version                 Display version and exit\n"
           "  -h, --help                    Display this help and exit\n"
           "\n"
           "Implements generation gap codegen pattern for Core Data.\n"
           "Inspired by eogenerator.\n");
}

- (NSString*)xcodeSelectPrintPath {
    NSString *result = @"";
    
    @try {
        NSTask *task = [[[NSTask alloc] init] autorelease];
        [task setLaunchPath:@"/usr/bin/xcode-select"];
        
        [task setArguments:[NSArray arrayWithObject:@"-print-path"]];
        
        NSPipe *pipe = [NSPipe pipe];
        [task setStandardOutput:pipe];
        //  Ensures that the current tasks output doesn't get hijacked
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

- (void)setModel:(NSString*)momOrXCDataModelFilePath {
    assert(!model); // Currently we only can load one model.
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:momOrXCDataModelFilePath]) {
        NSString *reason = [NSString stringWithFormat:@"error loading file at %@: no such file exists", momOrXCDataModelFilePath];
        DDCliParseException *e = [DDCliParseException parseExceptionWithReason:reason
                                                                      exitCode:EX_NOINPUT];
        @throw e;
    }
    
    origModelBasePath = [momOrXCDataModelFilePath stringByDeletingLastPathComponent];
    
    // If given a data model bundle (.xcdatamodeld) file, assume its "current" data model file.
    if ([[momOrXCDataModelFilePath pathExtension] isEqualToString:@"xcdatamodeld"]) {
        // xcdatamodeld bundles have a ".xccurrentversion" plist file in them with a
        // "_XCCurrentVersionName" key representing the current model's file name.
        NSString *xccurrentversionPath = [momOrXCDataModelFilePath stringByAppendingPathComponent:@".xccurrentversion"];
        if ([fm fileExistsAtPath:xccurrentversionPath]) {
            NSDictionary *xccurrentversionPlist = [NSDictionary dictionaryWithContentsOfFile:xccurrentversionPath];
            NSString *currentModelName = [xccurrentversionPlist objectForKey:@"_XCCurrentVersionName"];
            if (currentModelName) {
                momOrXCDataModelFilePath = [momOrXCDataModelFilePath stringByAppendingPathComponent:currentModelName];
            }
        }
        else {
            // Freshly created models with only one version do NOT have a .xccurrentversion file, but only have one model
            // in them.  Use that model.
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self endswith %@", @".xcdatamodel"];
            NSArray *contents = [[fm contentsOfDirectoryAtPath:momOrXCDataModelFilePath error:nil]
                                   filteredArrayUsingPredicate:predicate];
            if (contents.count == 1) {
                momOrXCDataModelFilePath = [momOrXCDataModelFilePath stringByAppendingPathComponent:[contents lastObject]];
            }
        }
    }
    
    NSString *momFilePath = nil;
    if ([[momOrXCDataModelFilePath pathExtension] isEqualToString:@"xcdatamodel"]) {
        //  We've been handed a .xcdatamodel data model, transparently compile it into a .mom managed object model.
        
        NSString *momcTool = nil;
        {{
            if (NO && [fm fileExistsAtPath:@"/usr/bin/xcrun"]) {
                // Cool, we can just use Xcode 3.2.6/4.x's xcrun command to find and execute momc for us.
                momcTool = @"/usr/bin/xcrun momc";
            } else {
                // Rats, don't have xcrun. Hunt around for momc in various places where various versions of Xcode stashed it.
                NSString *xcodeSelectMomcPath = [NSString stringWithFormat:@"%@/usr/bin/momc", [self xcodeSelectPrintPath]];
                
                if ([fm fileExistsAtPath:xcodeSelectMomcPath]) {
                    momcTool = [NSString stringWithFormat:@"\"%@\"", xcodeSelectMomcPath]; // Quote for safety.
                } else if ([fm fileExistsAtPath:@"/Applications/Xcode.app/Contents/Developer/usr/bin/momc"]) {
                    // Xcode 4.3 - Command Line Tools for Xcode
                    momcTool = @"/Applications/Xcode.app/Contents/Developer/usr/bin/momc";
                } else if ([fm fileExistsAtPath:@"/Developer/usr/bin/momc"]) {
                    // Xcode 3.1.
                    momcTool = @"/Developer/usr/bin/momc";
                } else if ([fm fileExistsAtPath:@"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"]) {
                    // Xcode 3.0.
                    momcTool = @"\"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc\"";
                } else if ([fm fileExistsAtPath:@"/Developer/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"]) {
                    // Xcode 2.4.
                    momcTool = @"/Developer/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc";
                }
                assert(momcTool && "momc not found");
            }
        }}
        
        NSMutableString *momcOptions = [NSMutableString string];
        {{
            NSArray *supportedMomcOptions = [NSArray arrayWithObjects:
                                             @"MOMC_NO_WARNINGS",
                                             @"MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS",
                                             @"MOMC_SUPPRESS_INVERSE_TRANSIENT_ERROR",
                                             nil];
            for (NSString *momcOption in supportedMomcOptions) {
                if ([[[NSProcessInfo processInfo] environment] objectForKey:momcOption]) {
                    [momcOptions appendFormat:@" -%@ ", momcOption];
                }
            }
        }}
        
        NSString *momcIncantation = nil;
        {{
            NSString *tempGeneratedMomFileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingPathExtension:@"mom"];
            tempGeneratedMomFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:tempGeneratedMomFileName];
            momcIncantation = [NSString stringWithFormat:@"%@ %@ \"%@\" \"%@\"",
                               momcTool,
                               momcOptions,
                               momOrXCDataModelFilePath,
                               tempGeneratedMomFilePath];
        }}
        
        {{
            system([momcIncantation UTF8String]); // Ignore system() result since momc sadly doesn't return any relevent error codes.
            momFilePath = tempGeneratedMomFilePath;
        }}
    } else {
        momFilePath = momOrXCDataModelFilePath;
    }
    
    model = [[[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:momFilePath]] autorelease];
    assert(model);
}

- (void)validateOutputPath:(NSString*)path forType:(NSString*)type
{
    //  Ignore nil ones
    if (path == nil) {
        return;
    }
    
    NSString        *errorString = nil;
    NSError         *error = nil;
    NSFileManager   *fm = [NSFileManager defaultManager];
    BOOL            isDir = NO;
    
    //  Test to see if the path exists
    if ([fm fileExistsAtPath:path isDirectory:&isDir]) {
        if (!isDir) {
            errorString = [NSString stringWithFormat:@"%@ Directory path (%@) exists as a file.", type, path];
        }
    }
    //  Try to create path
    else {
        if (![fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            errorString = [NSString stringWithFormat:@"Couldn't create %@ Directory (%@):%@", type, path, [error localizedDescription]];
        }
    }
    
    if (errorString != nil) {

        //  Print error message and exit with IO error
        ddprintf(errorString);
        exit(EX_IOERR);
    }
}

- (int)application:(DDCliApplication*)app runWithArguments:(NSArray*)arguments {
    if (_help) {
        [self printUsage];
        return EXIT_SUCCESS;
    }
    
    if (_version) {
        printf("mogenerator 1.27. By Jonathan 'Wolf' Rentzsch + friends.\n");
        return EXIT_SUCCESS;
    }

    if (baseClassForce) {
        gCustomBaseClassForced = [baseClassForce retain];
        gCustomBaseClass = gCustomBaseClassForced;
        gCustomBaseClassImport = [baseClassImport retain];
    } else {
        gCustomBaseClass = [baseClass retain];
        gCustomBaseClassImport = [baseClassImport retain];
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
                #define MANAGED_OBJECT_SOURCE_FILE_REGEX    @"_?([a-zA-Z0-9_]+MO).(h|m|mm)" // Sadly /^(*MO).(h|m|mm)$/ doesn't work.
                if ([srcFileName isMatchedByRegex:MANAGED_OBJECT_SOURCE_FILE_REGEX]) {
                    NSString *entityName = [[srcFileName captureComponentsMatchedByRegex:MANAGED_OBJECT_SOURCE_FILE_REGEX] objectAtIndex:1];
                    if (![entityFilesByName objectForKey:entityName]) {
                        [entityFilesByName setObject:[NSMutableSet set] forKey:entityName];
                    }
                    [[entityFilesByName objectForKey:entityName] addObject:srcFileName];
                }
            }
        }
        nsenumerate ([model entitiesWithACustomSubclassInConfiguration:configuration verbose:NO], NSEntityDescription, entity) {
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
        MiscMergeEngine *machineH = engineWithTemplateDesc([self templateDescNamed:@"machine.h.motemplate"]);
        assert(machineH);
        MiscMergeEngine *machineM = engineWithTemplateDesc([self templateDescNamed:@"machine.m.motemplate"]);
        assert(machineM);
        MiscMergeEngine *humanH = engineWithTemplateDesc([self templateDescNamed:@"human.h.motemplate"]);
        assert(humanH);
        MiscMergeEngine *humanM = engineWithTemplateDesc([self templateDescNamed:@"human.m.motemplate"]);
        assert(humanM);
        
        // Add the template var dictionary to each of the merge engines
        [machineH setEngineValue:templateVar forKey:kTemplateVar];
        [machineM setEngineValue:templateVar forKey:kTemplateVar];
        [humanH setEngineValue:templateVar forKey:kTemplateVar];
        [humanM setEngineValue:templateVar forKey:kTemplateVar];
        
        NSMutableArray  *humanMFiles = [NSMutableArray array],
                        *humanHFiles = [NSMutableArray array],
                        *machineMFiles = [NSMutableArray array],
                        *machineHFiles = [NSMutableArray array];
        
        nsenumerate ([model entitiesWithACustomSubclassInConfiguration:configuration verbose:YES], NSEntityDescription, entity) {
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
                    //  If the file doesn't exist or is different than what we just generated, write it out.
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
                    //  If the file doesn't exist or is different than what we just generated, write it out.
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
            
            //  Human source files.
            NSString *humanMFileName = [humanDir stringByAppendingPathComponent:
                [NSString stringWithFormat:@"%@.m", entityClassName]];
            NSString *humanMMFileName = [humanDir stringByAppendingPathComponent:
                [NSString stringWithFormat:@"%@.mm", entityClassName]];
            if (![fm regularFileExistsAtPath:humanMFileName] && [fm regularFileExistsAtPath:humanMMFileName]) {
                //  Allow .mm human files as well as .m files.
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
    
    if (tempGeneratedMomFilePath) {
        [fm removeItemAtPath:tempGeneratedMomFilePath error:nil];
    }
    bool mfileGenerated = NO;
    if (mfilePath && ![mfileContent isEqualToString:@""] && (![fm regularFileExistsAtPath:mfilePath] || ![[NSString stringWithContentsOfFile:mfilePath encoding:NSUTF8StringEncoding error:nil] isEqualToString:mfileContent])) {
        [mfileContent writeToFile:mfilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        mfileGenerated = YES;
    }

    bool hfileGenerated = NO;
    if (hfilePath && ![hfileContent isEqualToString:@""] && (![fm regularFileExistsAtPath:hfilePath] || ![[NSString stringWithContentsOfFile:hfilePath encoding:NSUTF8StringEncoding error:nil] isEqualToString:hfileContent])) {
        [hfileContent writeToFile:hfilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        hfileGenerated = YES;
    }

    if (!_listSourceFiles) {
        printf("%d machine files%s %d human files%s generated.\n", machineFilesGenerated,
               (mfileGenerated ? "," : " and"), humanFilesGenerated, (mfileGenerated ? " and one include.m file" : ""));

        if (hfileGenerated) {
            printf("Aggregate header file was also generated to %s.\n", [hfilePath fileSystemRepresentation]);
        }
    }
    
    return EXIT_SUCCESS;
}

@end

@implementation MogeneratorTemplateDesc

- (id)initWithName:(NSString*)name_ path:(NSString*)path_ {
    self = [super init];
    if (self) {
        templateName = [name_ retain];
        templatePath = [path_ retain];
    }
    return self;
}

- (void)dealloc {
    [templateName release];
    [templatePath release];
    [super dealloc];
}

- (NSString*)templateName {
    return templateName;
}

- (void)setTemplateName:(NSString*)name_ {
    if (templateName != name_) {
        [templateName release];
        templateName = [name_ retain];
    }
}

- (NSString*)templatePath {
    return templatePath;
}

- (void)setTemplatePath:(NSString*)path_ {
    if (templatePath != path_) {
        [templatePath release];
        templatePath = [path_ retain];
    }
}

@end

int main(int argc, char * const * argv) {
    return DDCliAppRunWithClass([MOGeneratorApp class]);
}
