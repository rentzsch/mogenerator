//
//  MiscMergeEngine.h
//
//	Written by Don Yacktman and Carl Lindberg
//
//	Copyright 2001-2004 by Don Yacktman and Carl Lindberg.
//	All rights reserved.
//
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//	

#import <Foundation/NSObject.h>

@class NSMutableString, NSMutableArray, NSMutableDictionary;
@class MiscMergeTemplate, MiscMergeCommand, MiscMergeCommandBlock;

typedef enum _MiscMergeCommandExitType {
    MiscMergeCommandExitNormal,
    MiscMergeCommandExitBreak,
    MiscMergeCommandExitContinue
} MiscMergeCommandExitType;

typedef enum _MiscMergeFailedLookupResultType {
    MiscMergeFailedLookupResultKey,
    MiscMergeFailedLookupResultKeyWithDelims,
    MiscMergeFailedLookupResultNil,
    MiscMergeFailedLookupResultKeyIfNumeric
} MiscMergeFailedLookupResultType;

typedef enum _MiscMergeNilLookupResultType {
    MiscMergeNilLookupResultNil,
    MiscMergeNilLookupResultKeyIfQuoted,
    MiscMergeNilLookupResultKey,
    MiscMergeNilLookupResultKeyWithDelims
} MiscMergeNilLookupResultType;

@interface MiscMergeEngine : NSObject
{
    NSMutableDictionary *userInfo;
    NSMutableDictionary *engineSymbols;
    NSMutableDictionary *mergeSymbols;
    NSMutableDictionary *localSymbols;
    MiscMergeTemplate   *template;
    id              	currentObject;
    NSMutableArray  	*contextStack;
    NSMutableArray  	*commandStack;
    NSMutableString 	*outputString;
    MiscMergeEngine     *parentMerge;
    id                  driver;
    BOOL		aborted;
    BOOL   		keepDelimiters;
    BOOL		useRecursiveLookups;
    int			recursiveLookupLimit;
    MiscMergeFailedLookupResultType failedLookupResult;
    MiscMergeNilLookupResultType nilLookupResult;
}

/*" Initializing "*/
- init;
- initWithTemplate:(MiscMergeTemplate *)aTemplate;

/*" Setting/getting attributes "*/
- (NSMutableDictionary *)userInfo;
- (id)mainObject;
- (MiscMergeTemplate *)template;
- (MiscMergeEngine *)parentMerge;
- (void)setMainObject:(id)anObject;
- (void)setTemplate:(MiscMergeTemplate *)aTemplate;
- (void)setParentMerge:(MiscMergeEngine *)anEngine;

- (BOOL)useRecursiveLookups;
- (void)setUseRecursiveLookups:(BOOL)shouldRecurse;
- (int)recursiveLookupLimit;
- (void)setRecursiveLookupLimit:(int)recurseLimit;
- (void)setUseRecursiveLookups:(BOOL)shouldRecurse limit:(int)recurseLimit;

- (BOOL)keepsDelimiters;
- (void)setKeepsDelimiters:(BOOL)shouldKeep;

- (MiscMergeFailedLookupResultType)failedLookupResult;
- (void)setFailedLookupResult:(MiscMergeFailedLookupResultType)type;

- (MiscMergeNilLookupResultType)nilLookupResult;
- (void)setNilLookupResult:(MiscMergeNilLookupResultType)type;

/*" Manipulating context variables "*/
+ (NSMutableDictionary *)globalSymbolsDictionary;
+ (void)setGlobalValue:(id)anObject forKey:(NSString *)aKey;
+ (void)removeGlobalValueForKey:(NSString *)aKey;
+ (id)globalValueForKey:(NSString *)aKey;
- (void)setGlobalValue:(id)anObject forKey:(NSString *)aKey;
- (void)removeGlobalValueForKey:(NSString *)aKey;
- (id)globalValueForKey:(NSString *)aKey;

- (void)setEngineValue:(id)anObject forKey:(NSString *)aKey;
- (void)removeEngineValueForKey:(NSString *)aKey;
- (id)engineValueForKey:(NSString *)aKey;

- (void)setMergeValue:(id)anObject forKey:(NSString *)aKey;
- (void)removeMergeValueForKey:(NSString *)aKey;
- (id)mergeValueForKey:(NSString *)aKey;

- (void)setLocalValue:(id)anObject forKey:(NSString *)aKey;
- (void)removeLocalValueForKey:(NSString *)aKey;
- (id)localValueForKey:(NSString *)aKey;

/*" Executing the merge "*/
- (NSString *)execute:sender;
- (NSString *)executeWithObject:(id)anObject sender:sender;

/*" Getting the output "*/
- (NSString *)outputString;

/*" Primitives that may be used by MiscMergeCommands "*/
- (MiscMergeCommandExitType)executeCommand:(MiscMergeCommand *)command;
- (MiscMergeCommandExitType)executeCommandBlock:(MiscMergeCommandBlock *)block;
- (void)addContextObject:(id)anObject andSetLocalSymbols:(BOOL)flag;
- (void)addContextObject:(id)anObject;
- (void)removeContextObject:(id)anObject;
- (id)valueForField:(NSString *)fieldName;
- (id)valueForField:(NSString *)fieldName quoted:(int)quoted;
- (void)appendToOutput:(NSString *)aString;
- (void)abortMerge;
- (void)advanceRecord;

@end
