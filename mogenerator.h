/*******************************************************************************
	mogenerator.h - <http://github.com/rentzsch/mogenerator>
		Copyright (c) 2006-2011 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
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
#import "DDCommandLineInterface.h"

@interface NSManagedObjectModel (entitiesWithACustomSubclassVerbose)
- (NSArray*)entitiesWithACustomSubclassVerbose:(BOOL)verbose_;
@end

@interface NSEntityDescription (customBaseClass)
- (BOOL)hasCustomSuperentity;
- (NSString*)customSuperentity;
- (void)_processPredicate:(NSPredicate*)predicate_ bindings:(NSMutableArray*)bindings_;
- (NSArray*)prettyFetchRequests;
@end

@interface NSAttributeDescription (typing)
- (BOOL)hasScalarAttributeType;
- (NSString*)scalarAttributeType;
- (NSString*)scalarAccessorMethodName;
- (NSString*)scalarFactoryMethodName;
- (BOOL)hasDefinedAttributeType;
- (NSString*)objectAttributeClassName;
- (NSString*)objectAttributeType;
- (BOOL)hasTransformableAttributeType;
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
	NSString				*origModelBasePath;
	NSString				*tempMOMPath;
	NSManagedObjectModel	*model;
	NSString				*baseClass;
	NSString				*baseClassForce;
	NSString				*includem;
	NSString				*includeh;
	NSString				*templatePath;
	NSString				*outputDir;
	NSString				*machineDir;
	NSString				*humanDir;
	NSString				*templateGroup;
	BOOL					_help;
	BOOL					_version;
	BOOL					_listSourceFiles;
    BOOL					_orphaned;
    NSMutableDictionary     *templateVar;
}

- (NSString*)appSupportFileNamed:(NSString*)fileName_;
@end