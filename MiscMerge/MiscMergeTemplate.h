//
//  MiscMergeTemplate.h
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

@class NSMutableArray, NSCharacterSet;
@class MiscMergeCommandBlock;

typedef enum _MiscMergeTrimWhitespaceBehavior {
    MiscMergeKeepWhitespace,
    MiscMergeKeepNonBlankWhitespace,
    MiscMergeTrimWhitespace,
    MiscMergeIgnoreCommandSpaces
} MiscMergeTrimWhitespaceBehavior;

@interface MiscMergeTemplate : NSObject
{
    MiscMergeCommandBlock *topLevelCommands;
    NSMutableArray        *commandStack;
    NSString              *startDelimiter;
    NSString              *endDelimiter;
    int                   _lineNumber;
    NSString              *_filename;
    NSCharacterSet        *_parseStopChars;
    MiscMergeTrimWhitespaceBehavior _trimWhitespaceBehavior;
    id                    _delegate;
}

/*" Creating a MiscMergeTemplate "*/
+ template;
+ templateWithString:(NSString *)aString;

/*" Initializing a MiscMergeTemplate "*/
- init;
- initWithString:(NSString *)string;
- initWithContentsOfFile:(NSString *)filename;

- (id)delegate;
- (void)setDelegate:(id)anObject;

- (NSString *)resolveTemplateFilename:(NSString *)resolveName;

/*" Accessing/setting the delimiters "*/
+ (NSString *)defaultStartDelimiter;
+ (NSString *)defaultEndDelimiter;
- (NSString *)startDelimiter;
- (NSString *)endDelimiter;
- (void)setStartDelimiter:(NSString *)startDelim endDelimiter:(NSString *)endDelim;

/*" Change behavior of blank space between commands "*/
- (MiscMergeTrimWhitespaceBehavior)trimWhitespaceBehavior;
- (void)setTrimWhitespaceBehavior:(MiscMergeTrimWhitespaceBehavior)flag;

/*" Command block manipulation "*/
- (void)pushCommandBlock:(MiscMergeCommandBlock *)aBlock;
- (void)popCommandBlock:(MiscMergeCommandBlock *)aBlock;
- (void)popCommandBlock;
- (MiscMergeCommandBlock *)currentCommandBlock;
- (MiscMergeCommandBlock *)topLevelCommandBlock;

/*" Loading the template "*/
- (void)parseContentsOfFile:(NSString *)filename;
- (void)parseString:(NSString *)string;
- (void)reportParseError:(NSString *)format, ...;
- (void)setFilename:(NSString *)filename;
- (NSString *)filename;

/*" Deriving the class for a command string "*/
- (Class)classForCommand:(NSString *)aCommand;

@end


@interface MiscMergeTemplateDelegate

- (NSString *)mergeTemplate:(MiscMergeTemplate *)template resolveTemplateFilename:(NSString *)filename;

@end
