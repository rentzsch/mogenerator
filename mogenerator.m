// mogenerator.m
//   Copyright (c) 2006-2016 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/mit
//   http://github.com/rentzsch/mogenerator

#import "mogenerator.h"
#import "NSManagedObjectModel+momcom.h"
#import "NSAttributeDescription+momcom.h"
#import "NSString+MORegEx.h"

static NSString * const kTemplateVar = @"TemplateVar";
static NSString  *gCustomBaseClass;
static NSString  *gCustomBaseClassImport;
static NSString  *gCustomBaseClassForced;
static BOOL       gSwift;

static const NSString *const kAttributeValueScalarTypeKey = @"attributeValueScalarType";
static const NSString *const kAdditionalHeaderFileNameKey = @"additionalHeaderFileName";
static const NSString *const kCustomBaseClass = @"mogenerator.customBaseClass";
static const NSString *const kReadOnly = @"mogenerator.readonly";

@interface NSEntityDescription (fetchedPropertiesAdditions)
- (NSDictionary*)fetchedPropertiesByName;
@end

@implementation NSEntityDescription (fetchedPropertiesAdditions)
- (NSDictionary*)fetchedPropertiesByName {
    NSMutableDictionary *fetchedPropertiesByName = [NSMutableDictionary dictionary];

    NSArray *properties = [self properties];
    for (NSPropertyDescription *property in properties)
    {
        if ([property isKindOfClass:[NSFetchedPropertyDescription class]]) {
            [fetchedPropertiesByName setObject:property forKey:[property name]];
        }
    }

    return fetchedPropertiesByName;
}
@end

@interface NSEntityDescription (swiftAdditions)
- (NSString *)sanitizedManagedObjectClassName;
@end

@implementation NSEntityDescription (swiftAdditions)

- (NSString *)sanitizedManagedObjectClassName {
    NSString *className = [self managedObjectClassName];
    if ([className hasPrefix:@"."]) {
        return [className stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    return className;
}

@end

@interface NSEntityDescription (userInfoAdditions)
- (BOOL)hasUserInfoKeys;
- (NSDictionary *)userInfoByKeys;
@end

@implementation NSEntityDescription (userInfoAdditions)
- (NSDictionary*)sanitizedUserInfo {
    NSMutableCharacterSet *validCharacters = [[[NSCharacterSet letterCharacterSet] mutableCopy] autorelease];
    [validCharacters formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [validCharacters addCharactersInString:@"_"];
    NSCharacterSet *invalidCharacters = [validCharacters invertedSet];

    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[[self userInfo] count]];
    for (NSString *key in self.userInfo) {
        if ([key rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound) {
            NSString *value = [self.userInfo objectForKey:key];
            value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            [result setObject:value forKey:key];
        }
    }

    return result;
}

- (BOOL)hasUserInfoKeys {
	return ([self.sanitizedUserInfo count] > 0);
}

- (NSDictionary *)userInfoByKeys {
	NSMutableDictionary *userInfoByKeys = [NSMutableDictionary dictionary];

	for (NSString *key in self.sanitizedUserInfo)
		[userInfoByKeys setObject:[NSDictionary dictionaryWithObjectsAndKeys:key, @"key", [self.sanitizedUserInfo objectForKey:key], @"value", nil] forKey:key];

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

    for (NSEntityDescription *entity in allEntities)
    {
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

- (BOOL)hasCustomSuperclass {
    // For Swift, where "override" is needed when both the entity and its superentity have custom classes.
    BOOL result = [self hasCustomClass] && [self hasCustomSuperentity] && [[self superentity] hasCustomClass];
    return result;
}

- (BOOL)hasAdditionalHeaderFile {
    return [[[self userInfo] allKeys] containsObject:kAdditionalHeaderFileNameKey];
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
    NSString* userInfoCustomBaseClass = [[self userInfo] objectForKey:kCustomBaseClass];
    return userInfoCustomBaseClass ? userInfoCustomBaseClass : gCustomBaseClassForced;
}
/** @TypeInfo NSAttributeDescription */
- (NSArray*)allAttributes {
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return [[[self attributesByName] allValues] sortedArrayUsingDescriptors:sortDescriptors];
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

- (NSString*)additionalHeaderFileName {
    return [[self userInfo] objectForKey:kAdditionalHeaderFileNameKey];
}

/** @TypeInfo NSAttributeDescription */
- (NSArray*)noninheritedAttributesSansType {
    NSArray *attributeDescriptions = [self noninheritedAttributes];
    NSMutableArray *filteredAttributeDescriptions = [NSMutableArray arrayWithCapacity:[attributeDescriptions count]];

    for (NSAttributeDescription *attributeDescription in attributeDescriptions)
    {
        if ([[attributeDescription name] isEqualToString:@"type"]) {
            ddprintf(@"WARNING skipping 'type' attribute on %@ (%@) - see https://github.com/rentzsch/mogenerator/issues/74\n",
                     self.name, self.managedObjectClassName);
        } else {
            [filteredAttributeDescriptions addObject:attributeDescription];
        }
    }
    return filteredAttributeDescriptions;
}
/** @TypeInfo NSRelationshipDescription */
- (NSArray*)allRelationships {
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return [[[self relationshipsByName] allValues] sortedArrayUsingDescriptors:sortDescriptors];
}
/** @TypeInfo NSRelationshipDescription */
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

    NSArray *keys = [fetchRequests allKeys];
    for (NSString *fetchRequestName in keys)
    {
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
    for (NSString *key in components)
    {
        id property = [[entity propertiesByName] objectForKey:key];
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            NSString *result = [property objectAttributeType];
            return gSwift ? result : [result substringToIndex:[result length] -1];
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
        for (NSPredicate *subpredicate in [(NSCompoundPredicate*)predicate_ subpredicates])
        {
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
                if (!gSwift) {
                    type = [type stringByAppendingString:@"*"];
                }
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

    NSArray *keys = [fetchRequests allKeys];
    for (NSString *fetchRequestName in keys)
    {
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
- (BOOL)isUnsigned
{
    BOOL hasMin = NO;
    for (NSPredicate *pred in [self validationPredicates]) {
        if ([pred.predicateFormat containsString:@">= 0"]) {
            hasMin = YES;
        }
    }
    return hasMin;
}

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

- (BOOL)usesScalarAttributeType {
    NSNumber *usesScalarAttributeType = [[self userInfo] objectForKey:kUsesScalarAttributeType];

    if (usesScalarAttributeType) {
        return usesScalarAttributeType.boolValue;
    } else {
        return NO;
    }
}

- (BOOL)usesCustomScalarAttributeType {
    NSString *attributeValueScalarType = [[self userInfo] objectForKey:kAttributeValueScalarTypeKey];
    return (attributeValueScalarType != nil);
}

- (NSString*)scalarAttributeType {
    BOOL isUnsigned = [self isUnsigned];

    NSString *attributeValueScalarType = [[self userInfo] objectForKey:kAttributeValueScalarTypeKey];

    if (attributeValueScalarType) {
        return attributeValueScalarType;
    } else {
        switch ([self attributeType]) {
            case NSInteger16AttributeType:
                return gSwift ? isUnsigned ? @"UInt16" : @"Int16" : isUnsigned ? @"uint16_t" : @"int16_t";
                break;
            case NSInteger32AttributeType:
                return gSwift ? isUnsigned ? @"UInt32" : @"Int32" : isUnsigned ? @"uint32_t" : @"int32_t";
                break;
            case NSInteger64AttributeType:
                return gSwift ? isUnsigned ? @"UInt64" : @"Int64" : isUnsigned ? @"uint64_t" : @"int64_t";
                break;
            case NSDoubleAttributeType:
                return gSwift ? @"Double" : @"double";
                break;
            case NSFloatAttributeType:
                return gSwift ? @"Float" : @"float";
                break;
            case NSBooleanAttributeType:
                return gSwift ? @"Bool" : @"BOOL";
                break;
            default:
                return nil;
        }
    }
}
- (NSString*)scalarAccessorMethodName {

    BOOL isUnsigned = [self isUnsigned];

    switch ([self attributeType]) {
        case NSInteger16AttributeType:
            if (isUnsigned) {
                return @"unsignedShortValue";
            }
            return @"shortValue";
            break;
        case NSInteger32AttributeType:
            if (isUnsigned) {
                return @"unsignedIntValue";
            }
            return @"intValue";
            break;
        case NSInteger64AttributeType:
            if (isUnsigned) {
                return @"unsignedLongLongValue";
            }
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

    BOOL isUnsigned = [self isUnsigned];

    switch ([self attributeType]) {
        case NSInteger16AttributeType:
            if (isUnsigned) {
                return @"numberWithUnsignedShort:";
            }
            return @"numberWithShort:";
            break;
        case NSInteger32AttributeType:
            if (isUnsigned) {
                return @"numberWithUnsignedInt:";
            }
            return @"numberWithInt:";
            break;
        case NSInteger64AttributeType:
            if (isUnsigned) {
                return @"numberWithUnsignedLongLong:";
            }
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
            result = gSwift ? @"AnyObject" : @"NSObject";
        }
    } else {
        // Forcibly generate the correct class name in case we are
        // running on macOS < 10.13
        switch ([self attributeType]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
            case NSURIAttributeType:
                result = @"NSURL";
                break;
            case NSUUIDAttributeType:
                result = @"NSUUID";
                break;
#pragma clang diagnostic pop
            default:
                result = [self attributeValueClassName];
        }
    }
    
    if (gSwift) {
        if ([result isEqualToString:@"NSString"]) {
            result = @"String";
        } else if ([result isEqualToString:@"NSDate"]) {
            result = @"Date";
        } else if ([result isEqualToString:@"NSData"]) {
            result = @"Data";
        } else if ([result isEqualToString:@"NSURL"]) {
            result = @"URL";
        } else if ([result isEqualToString:@"NSUUID"]) {
            result = @"UUID";
        }
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

- (BOOL)usesCustomObjectAttributeType {
    NSString *attributeValueClassName = [[self userInfo] objectForKey:@"attributeValueClassName"];
    return (attributeValueClassName != nil);
}

- (NSString*)objectAttributeType {
    NSString *result = [self objectAttributeClassName];
    if ([result isEqualToString:@"Class"]) {
        // `Class` (don't append asterisk).
    } else if ([result rangeOfString:@"<"].location != NSNotFound) {
        // `id<Protocol1,Protocol2>` (don't append asterisk).
    } else if ([result isEqualToString:@"NSObject"]) {
        result = gSwift ? @"AnyObject" : @"id";
    } else if (!gSwift) {
        result = [result stringByAppendingString:@"*"]; // Make it a pointer.
    }
    return result;
}
- (BOOL)hasTransformableAttributeType {
    return ([self attributeType] == NSTransformableAttributeType);
}

- (BOOL)isReadonly {
    NSString *readonlyUserinfoValue = [[self userInfo] objectForKey:kReadOnly];
    if (readonlyUserinfoValue != nil) {
        return YES;
    }
    return NO;
}

@end

@implementation NSRelationshipDescription (collectionClassName)

- (NSString*)jr_CollectionClassStringWithOrderedClassName:(NSString*)orderedClassName
                                       unorderedClassName:(NSString*)unorderedClassName
{
    NSString *generic = [NSString stringWithFormat:@"<%@*>", self.destinationEntity.managedObjectClassName];
    if (gSwift) {
        // No generics for Swift sets, for now.
        return [self jr_isOrdered] ? orderedClassName : unorderedClassName;
    }

    return [self jr_isOrdered]
        ? [orderedClassName stringByAppendingString:generic]
        : [unorderedClassName stringByAppendingString:generic];
}

- (NSString*)mutableCollectionClassName {
    return [self jr_CollectionClassStringWithOrderedClassName:@"NSMutableOrderedSet"
                                           unorderedClassName:@"NSMutableSet"];
}

- (NSString*)immutableCollectionClassName {
    return [self jr_CollectionClassStringWithOrderedClassName:@"NSOrderedSet"
                                           unorderedClassName:@"NSSet"];
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
- (instancetype)initWithName:(NSString*)name_ path:(NSString*)path_;
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
        NSString *templateString = [[[NSString alloc] initWithData:templateData encoding:NSUTF8StringEncoding] autorelease];
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

        for (NSString *appSupportDirectory in appSupportDirectories)
        {
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
        // Long                 Short  Argument options
        {@"v2",                 '2',   DDGetoptNoArgument},
        {@"model",              'm',   DDGetoptRequiredArgument},
        {@"configuration",      'C',   DDGetoptRequiredArgument},
        {@"base-class",         0,     DDGetoptRequiredArgument},
        {@"base-class-import",  0,     DDGetoptRequiredArgument},
        {@"base-class-force",   0,     DDGetoptRequiredArgument},
        // For compatibility:
        {@"baseClass",          0,     DDGetoptRequiredArgument},
        {@"includem",           0,     DDGetoptRequiredArgument},
        {@"includeh",           0,     DDGetoptRequiredArgument},
        {@"template-path",      0,     DDGetoptRequiredArgument},
        // For compatibility:
        {@"templatePath",       0,     DDGetoptRequiredArgument},
        {@"output-dir",         'O',   DDGetoptRequiredArgument},
        {@"machine-dir",        'M',   DDGetoptRequiredArgument},
        {@"human-dir",          'H',   DDGetoptRequiredArgument},
        {@"template-group",     0,     DDGetoptRequiredArgument},
        {@"list-source-files",  0,     DDGetoptNoArgument},
        {@"orphaned",           0,     DDGetoptNoArgument},

        {@"help",               'h',   DDGetoptNoArgument},
        {@"version",            0,     DDGetoptNoArgument},
        {@"template-var",       0,     DDGetoptKeyValueArgument},
        {@"swift",              'S',   DDGetoptNoArgument},
        {nil,                   0,     0},
    };
    [optionsParser addOptionsFromTable:optionTable];
    [optionsParser setArgumentsFilename:@".mogenerator-args"];
}

- (void)printUsage {
    printf("\n"
           "Mogenerator Help\n"
           "================\n"
           "\n"
           "Mogenerator generates code from your Core Data model files.\n"
           "\n"
           "Typical Use\n"
           "-----------\n"
           "\n"
           "$ mogenerator --model MyModel.xcdatamodeld --output-dir MyModel\n"
           "\n"
           "Use the --model argument to supply the required data model file.\n"
           "\n"
           "If --output-dir is optional but recommended. If not supplied, mogenerator will\n"
           "output generated files into the current directory.\n"
           "\n"
           "All Options\n"
           "-----------\n"
           "\n"
           "--model MODEL             Path to model\n"
           "--output-dir DIR          Output directory\n"
           "--swift                   Generate Swift templates instead of Objective-C\n"
           "--configuration CONFIG    Only consider entities included in the named\n"
           "                          configuration\n"
           "--base-class CLASS        Custom base class\n"
           "--base-class-import TEXT  Imports base class as #import TEXT\n"
           "--base-class-force CLASS  Same as --base-class except will force all entities to\n"
           "                          have the specified base class. Even if a super entity\n"
           "                          exists\n"
           "--includem FILE           Generate aggregate include file for .m files for both\n"
           "                          human and machine generated source files\n"
           "--includeh FILE           Generate aggregate include file for .h files for human\n"
           "                          generated source files only\n"
           "--template-path PATH      Path to templates (absolute or relative to model path)\n"
           "--template-group NAME     Name of template group\n"
           "--template-var KEY=VALUE  A key-value pair to pass to the template file. There\n"
           "                          can be many of these.\n"
           "--machine-dir DIR         Output directory for machine files\n"
           "--human-dir DIR           Output directory for human files\n"
           "--list-source-files       Only list model-related source files\n"
           "--orphaned                Only list files whose entities no longer exist\n"
           "--version                 Display version and exit\n"
           "--help                    Display this help and exit\n"
           );
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

        NSString *contentsPath = [momOrXCDataModelFilePath stringByAppendingPathComponent:@"contents"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:contentsPath]) {
            // Cool, the model is in the Xcode 4.0+ format, we can compile it ourselves.
            NSError *compileError = nil;
            momFilePath = [NSManagedObjectModel compileModelAtPath:momOrXCDataModelFilePath inDirectory:NSTemporaryDirectory() error:&compileError];
            if (momFilePath == nil) {
                NSLog(@"Error: %@", [compileError localizedDescription]);
            }
            assert(momFilePath);
        } else {
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
        }
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
        printf("mogenerator 1.31. By Jonathan 'Wolf' Rentzsch + friends.\n");
        return EXIT_SUCCESS;
    }

    gSwift = _swift;

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
        for (NSString *srcDir in srcDirs)
        {
            if (![srcDir length]) {
                srcDir = [fm currentDirectoryPath];
            }

            NSArray *subpaths = [fm subpathsAtPath:srcDir];
            for (NSString *srcFileName in subpaths)
            {
                NSString *moSourceFileRegex = @"_?([a-zA-Z0-9_]+MO).(h|m|mm)"; // Sadly /^(*MO).(h|m|mm)$/ doesn't work.

                if ([srcFileName isMatchedByRegex:moSourceFileRegex]) {
                    NSString *entityName = [[srcFileName captureComponentsMatchedByRegex:moSourceFileRegex] objectAtIndex:1];
                    if (![entityFilesByName objectForKey:entityName]) {
                        [entityFilesByName setObject:[NSMutableSet set] forKey:entityName];
                    }
                    [[entityFilesByName objectForKey:entityName] addObject:srcFileName];
                }

            }
        }

        NSArray *entitiesWithCustomSubclass = [model entitiesWithACustomSubclassInConfiguration:configuration verbose:NO];

        for (NSEntityDescription *entity in entitiesWithCustomSubclass)
        {
            [entityFilesByName removeObjectForKey:[entity managedObjectClassName]];
        }

        for (NSSet *orphanedFiles in entityFilesByName)
        {
            for (NSString *orphanedFile in orphanedFiles)
            {
                ddprintf(@"%@\n", orphanedFile);
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
        MiscMergeEngine *machineH = nil;
        MiscMergeEngine *machineM = nil;
        MiscMergeEngine *humanH = nil;
        MiscMergeEngine *humanM = nil;

        if (_swift) {
            machineH = engineWithTemplateDesc([self templateDescNamed:@"machine.swift.motemplate"]);
            assert(machineH);
            humanH = engineWithTemplateDesc([self templateDescNamed:@"human.swift.motemplate"]);
            assert(humanH);
        } else {
            machineH = engineWithTemplateDesc([self templateDescNamed:@"machine.h.motemplate"]);
            assert(machineH);
            machineM = engineWithTemplateDesc([self templateDescNamed:@"machine.m.motemplate"]);
            assert(machineM);
            humanH = engineWithTemplateDesc([self templateDescNamed:@"human.h.motemplate"]);
            assert(humanH);
            humanM = engineWithTemplateDesc([self templateDescNamed:@"human.m.motemplate"]);
            assert(humanM);
        }

        // Add the template var dictionary to each of the merge engines
        [machineH setEngineValue:templateVar forKey:kTemplateVar];
        [machineM setEngineValue:templateVar forKey:kTemplateVar];
        [humanH setEngineValue:templateVar forKey:kTemplateVar];
        [humanM setEngineValue:templateVar forKey:kTemplateVar];

        NSMutableArray  *humanMFiles = [NSMutableArray array],
                        *humanHFiles = [NSMutableArray array],
                        *machineMFiles = [NSMutableArray array],
                        *machineHFiles = [NSMutableArray array];

        NSArray *entitiesWithCustomSubclass = [model entitiesWithACustomSubclassInConfiguration:configuration verbose:YES];
        for (NSEntityDescription *entity in entitiesWithCustomSubclass)
        {
            NSString *generatedMachineH = [machineH executeWithObject:entity sender:nil];
            NSString *generatedMachineM = [machineM executeWithObject:entity sender:nil];
            NSString *generatedHumanH = [humanH executeWithObject:entity sender:nil];
            NSString *generatedHumanM = [humanM executeWithObject:entity sender:nil];

            // remove unnecessary empty lines
            NSString *searchPattern = @"([ \t]*(\n|\r|\r\n)){2,}";
            NSString *replacementString = @"\n\n";

            generatedMachineH = [generatedMachineH stringByReplacingOccurrencesOfRegex:searchPattern withString:replacementString];
            generatedMachineM = [generatedMachineM stringByReplacingOccurrencesOfRegex:searchPattern withString:replacementString];
            generatedHumanH = [generatedHumanH stringByReplacingOccurrencesOfRegex:searchPattern withString:replacementString];
            generatedHumanM = [generatedHumanM stringByReplacingOccurrencesOfRegex:searchPattern withString:replacementString];

            NSString *entityClassName = [entity managedObjectClassName];
            entityClassName = [entityClassName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
            BOOL machineDirtied = NO;

            // Machine header files.
            NSString *extension = (_swift ? @"swift" : @"h");
            NSString *machineHFileName = [machineDir stringByAppendingPathComponent:
                                    [NSString stringWithFormat:@"_%@.%@", entityClassName, extension]];
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
            NSString *machineMFileName = nil;
            if (!_swift) {
                machineMFileName = [machineDir stringByAppendingPathComponent:
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
            }

            // Human header files.
            NSString *humanHFileName = [humanDir stringByAppendingPathComponent:
                [NSString stringWithFormat:@"%@.%@", entityClassName, extension]];
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

            if (!_swift) {
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
        }

        if (_listSourceFiles) {
            NSArray *filesList = [NSArray arrayWithObjects:humanMFiles, humanHFiles, machineMFiles, machineHFiles, nil];

            for (NSArray *files in filesList)
            {
                for (NSString *fileName in files)
                {
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

- (instancetype)initWithName:(NSString*)name_ path:(NSString*)path_ {
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
