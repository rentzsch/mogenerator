// mogenerator.h
//   Copyright (c) 2006-2016 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/mit
//   http://github.com/rentzsch/mogenerator

@import Foundation;
@import CoreData;

#import "MiscMergeTemplate.h"
#import "MiscMergeCommandBlock.h"
#import "MiscMergeEngine.h"
#import "FoundationAdditions.h"
#import "NSString+MiscAdditions.h"
#import "DDCommandLineInterface.h"

@interface NSManagedObjectModel (entitiesWithACustomSubclassVerbose)
- (NSArray*)entitiesWithACustomSubclassInConfiguration:(NSString*)configuration_ verbose:(BOOL)verbose_;
@end

@interface NSEntityDescription (userInfo)
/// @return Whether or not the entity should be ignored during code generation
- (BOOL)isIgnored;
@end

@interface NSEntityDescription (customBaseClass)
- (BOOL)hasCustomClass;
- (BOOL)hasSuperentity;
- (BOOL)hasCustomSuperentity;
- (BOOL)hasAdditionalHeaderFile;
- (NSString*)customSuperentity;
- (NSString*)forcedCustomBaseClass;
- (NSString*)additionalHeaderFileName;
- (void)_processPredicate:(NSPredicate*)predicate_ bindings:(NSMutableArray*)bindings_;
- (NSArray*)prettyFetchRequests;
@end

@interface NSAttributeDescription (typing)
- (BOOL)hasScalarAttributeType;
- (BOOL)usesScalarAttributeType;
- (BOOL)usesCustomScalarAttributeType;
- (NSString*)scalarAttributeType;
- (NSString*)scalarAccessorMethodName;
- (NSString*)scalarFactoryMethodName;
- (BOOL)hasDefinedAttributeType;
- (NSArray*)objectAttributeTransformableProtocols;
- (BOOL)hasAttributeTransformableProtocols;
- (BOOL)usesCustomObjectAttributeType;
- (NSString*)objectAttributeClassName;
- (NSString*)objectAttributeType;
- (BOOL)hasTransformableAttributeType;
- (BOOL)isReadonly;
@end

@interface NSRelationshipDescription (collectionClassName)
- (NSString*)mutableCollectionClassName;
- (NSString*)immutableCollectionClassName;
- (BOOL)jr_isOrdered;
@end
@interface NSObject (JustHereToSuppressIsOrderedNotImplementedCompilerWarning)
- (BOOL)isOrdered;
@end

@interface NSString (camelCaseString)
- (NSString*)camelCaseString;
@end

@interface MOGeneratorApp : NSObject <DDCliApplicationDelegate> {
    NSString              *origModelBasePath;
    NSString              *tempGeneratedMomFilePath;
    NSManagedObjectModel  *model;
    NSString              *configuration;
    NSString              *baseClass;
    NSString              *baseClassImport;
    NSString              *baseClassForce;
    NSString              *includem;
    NSString              *includeh;
    NSString              *templatePath;
    NSString              *outputDir;
    NSString              *machineDir;
    NSString              *humanDir;
    NSString              *templateGroup;
    BOOL                  _help;
    BOOL                  _version;
    BOOL                  _listSourceFiles;
    BOOL                  _orphaned;
    BOOL                  _swift;
    BOOL                  _v2;
    NSMutableDictionary   *templateVar;
}
@end
