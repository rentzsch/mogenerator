//
//  MiscMergeCommand.h
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
#import "MiscMergeEngine.h"
#import "MiscMergeTemplate.h"

@class NSScanner;
@class NSNumber;
@class MiscMergeExpression;

@interface MiscMergeCommand : NSObject
{}

/*" Basic methods "*/
- (BOOL)parseFromString:(NSString *)aString template:(MiscMergeTemplate *)template;
- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template;
- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger;

- (BOOL)isKindOfCommandClass:(NSString *)command;

/*" Help with parsing "*/
- (BOOL)eatKeyWord:(NSString *)aKeyWord fromScanner:(NSScanner *)scanner isOptional:(BOOL)flag;
- getArgumentStringFromScanner:(NSScanner *)scanner toEnd:(BOOL)endFlag quotes:(int *)quotes;
- getArgumentStringFromScanner:(NSScanner *)scanner toEnd:(BOOL)endFlag;
- getPromptFromScanner:(NSScanner *)scanner toEnd:(BOOL)endFlag;
- getPromptableArgumentStringFromScanner:(NSScanner *)scanner wasPrompt:(BOOL *)prompt toEnd:(BOOL)endFlag;

- (MiscMergeExpression *)getPrimaryExpressionFromScanner:(NSScanner *)aScanner;
- (MiscMergeExpression *)getExpressionFromScanner:(NSScanner *)aScanner;

/*" Error reporting "*/
- (void)error_conditional:(NSString *)theCond;
- (void)error_keyword:(NSString *)aKeyWord;
- (void)error_noprompt;
- (void)error_closequote;
- (void)error_closeparens;
- (void)error_argument:(NSString *)theArgument;

@end
