//
//  MiscMergeTemplate.m
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

#import "MiscMergeTemplate.h"
#import <Foundation/NSCharacterSet.h>
#import <Foundation/NSArray.h>
//#import <Foundation/NSUtilities.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSObjCRuntime.h>
#import "NSString+MiscAdditions.h"
#import "NSScanner+MiscMerge.h"
#import "MiscMergeCommand.h"
#import "MiscMergeCommandBlock.h"
#import "_MiscMergeFieldCommand.h"
#import "_MiscMergeCopyCommand.h"
#import "_MiscMergeDelayedParseCommand.h"
#import "MiscMergeFunctions.h"

@implementation MiscMergeTemplate
/*"
 * This class contains the template that is used by a merge engine. It
 * performs two functions:  (1) parse a string or text file into the
 * commands required by a merge ending and (2) act as a container for the
 * commands once they have been parsed, providing them to a merge engine as
 * needed.
 *
 * Typically, MiscMergeTemplate objects are used in a very simple way: they
 * are instantiated, given the ASCII text or string to parse, and then
 * passed to MiscMergeEngine instances as needed.  That's it!
 *
 * It should be noted that template text which is simply copied from the
 * template into the merged output (i.e. any text outside of a merge
 * command) is actually turned into a special "copy" command by the parsing
 * algorithm. This allows the merge engine to deal exclusively with
 * MiscMergeCommand subclasses to perform a merge.  This implementation
 * detail should not affect anything that would normally be done with this
 * object, but it is important to understand this fact if attempting to
 * understand the data structure created by the parsing routines.
 *
 * If a command string contains merge commands inside itself, then a
 * special "delayed command" class will used.  That class will, during a
 * merge, create an engine, perform a merge on its text, and then parse
 * itself into the correct type of command.  This allows merges to contain
 * commands that change depending upon the data records.
 *
 * Commands created while parsing are always added to the "current" command
 * block.  By using -#pushCommandBlock: and -#popCommandBlock,
 * MiscMergeCommand subclasses can temporarily substitute their own command
 * block to be the "current" block during the parsing process.  This way,
 * container-type commands such as if clauses and loops can know which
 * commands they hold.
"*/

/*"
 * Returns the default string used to start a merge command, "�".  A
 * subclass of MiscMergeTemplate could override this method.
"*/
+ (NSString *)defaultStartDelimiter
{
    //	return @"(";
    //	return @"�";
    /* This works better for whatever reason. Due to some unknown pecularities,
    a constant NSString doesn't work under Windows with Apple's
    implementation. */
    return [NSString stringWithCString:"�" encoding:NSUTF8StringEncoding];
}

/*"
 * Returns the default string used to end a merge command, "�".  A
 * subclass of MiscMergeTemplate could override this method.
"*/
+ (NSString *)defaultEndDelimiter
{
    //	return @")";
    //	return @"�";
    /* This works better than a constant NSString for whatever reason.  See above. */
    return [NSString stringWithCString:"�" encoding:NSUTF8StringEncoding];
}

/*" Creates a new, autoreleased MiscMergeTemplate. "*/
+ template
{
    return [[[self alloc] init] autorelease];
}

/*"
 * Creates a new, autoreleased MiscMergeTemplate, and parses aString.
"*/
+ templateWithString:(NSString *)aString
{
    return [[[self alloc] initWithString:aString] autorelease];
}

/*"
 * Initializes the MiscMergeTemplate instance and returns self.  This is
 * the designated initializer.  The start and end delimiters are set to the
 * values returned by +#defaultStartDelimiter and +#defaultEndDelimiter.
"*/
- init
{
    [super init];
    topLevelCommands = [[MiscMergeCommandBlock alloc] init];
    commandStack = [[NSMutableArray arrayWithObject:topLevelCommands] retain];
    startDelimiter = [[[self class] defaultStartDelimiter] retain];
    endDelimiter = [[[self class] defaultEndDelimiter] retain];
    return self;
}

/*"
 * Initializes the MiscMergeTemplate, then parses string.
"*/
- initWithString:(NSString *)string
{
    [self init];
    [self parseString:string];
    return self;
}

/* helper method to load string contents of filenames */
- (NSString *) contentsOfFileWithName:(NSString *)filename {
    NSError *error = nil;
    NSString *fileString = [NSString stringWithContentsOfFile:filename
                                                     encoding:NSASCIIStringEncoding
                                                        error:&error];
    
    if (error != nil) {
        NSLog(@"%@: Could not read template file %@ because %@", [self class], filename, [error localizedDescription]);   
    }
    return fileString;
}

/*"
 * Loads the contents of filename, then calls -#initWithString:.
"*/
- initWithContentsOfFile:(NSString *)filename
{
    NSString *fileString = [self contentsOfFileWithName:filename];
    return [self initWithString:fileString];
}

- (void)dealloc
{
    [commandStack release];
    [topLevelCommands release];
    [startDelimiter release];
    [endDelimiter release];
    [_parseStopChars release];
    [_filename release];
    [super dealloc];
}


- (id)delegate
{
    return _delegate;
}

- (void)setDelegate:(id)anObject
{
    _delegate = anObject;
}


/*" Returns the string used to start a merge command. "*/
- (NSString *)startDelimiter
{
    return startDelimiter;
}

/*" Returns the string used to end a merge command. "*/
- (NSString *)endDelimiter
{
    return endDelimiter;
}


/*"
 * Sets the strings used to start and end a merge command. %{startDelim}
 * and %{endDelim} can be the same strings, but if they are the same (or
 * one is a prefix of the other), then there will be no ability to have
 * nested commands, so the "delayed" feature will not be available.
"*/
- (void)setStartDelimiter:(NSString *)startDelim endDelimiter:(NSString *)endDelim
{
    NSString *charString;
    
    [startDelimiter autorelease];
    startDelimiter = [startDelim retain];

    [endDelimiter   autorelease];
    endDelimiter   = [endDelim retain];
    
    [_parseStopChars release];
    charString = [NSString stringWithFormat:@"\"\\%@%@", [startDelimiter substringToIndex:1], [endDelimiter substringToIndex:1]];
    _parseStopChars = [NSCharacterSet characterSetWithCharactersInString:charString];
    [_parseStopChars retain];
}


- (MiscMergeTrimWhitespaceBehavior)trimWhitespaceBehavior
{
    return _trimWhitespaceBehavior;
}
- (void)setTrimWhitespaceBehavior:(MiscMergeTrimWhitespaceBehavior)flag
{
    _trimWhitespaceBehavior = flag;
}


/*"
 * Returns the filename that was used to create the template, or nil if not
 * parsed from a file.  Used for reporting errors.
"*/
- (NSString *)filename
{
    return _filename;
}

/*"
 * Sets the filename the template was created from, which is used in
 * reporting errors.  This is normally set by -#parseContentsOfFile:, but
 * this method can be used if -#parseString: needs to be called directly
 * but the original source did come from a file.
"*/
- (void)setFilename:(NSString *)filename
{
    [_filename autorelease];
    _filename = [filename retain];
}

/*"
 * Pushes aBlock on the command stack.  aBlock becomes the current command
 * block until popped off (or another block is placed on top of it).
"*/
- (void)pushCommandBlock:(MiscMergeCommandBlock *)aBlock
{
    [commandStack addObject:aBlock];
}

/*"
 * Pops the command block aBlock off of the command stack, so the previous
 * command block will again be the "current" command block.  If aBlock is
 * not at the top of the command stack, logs an error and does nothing.
 * Basically the same as -#popCommandBlock except it does the extra sanity
 * check.
"*/
- (void)popCommandBlock:(MiscMergeCommandBlock *)aBlock
{
    if (aBlock && [commandStack lastObject] != aBlock)
    {
        [self reportParseError:@"Error, command stack mismatch"];
        return;
    }

    [self popCommandBlock];
}

/*"
 * Pops the top command block off the command stack, so the previous
 * command block will again be the "current" command block.
"*/
- (void)popCommandBlock
{
    if ([commandStack count] <= 1)
    {
        [self reportParseError:@"Error, cannot pop last command block"];
        return;
    }

    [commandStack removeLastObject];
}

/*"
 * Returns the "current" command block, i.e. the command block at the top
 * of the command stack.  As they are parsed, commands are always added to
 * the command block returned by this method.
"*/
- (MiscMergeCommandBlock *)currentCommandBlock
{
    return [commandStack lastObject];
}

/*"
 * Returns the "top level" command block of the MiscMergeTemplate, which is
 * basically the series of commands to be executed to generate the merge
 * file.  The top level block is always at the bottom of the command stack.
"*/
- (MiscMergeCommandBlock *)topLevelCommandBlock
{
    return topLevelCommands;
}

- (NSString *)resolveTemplateFilename:(NSString *)resolveName
{
    NSString *resolvedName = nil;
    
    if ( [_delegate respondsToSelector:@selector(mergeTemplate:resolveTemplateFilename:)] )
        resolvedName = [_delegate mergeTemplate:self resolveTemplateFilename:resolveName];

    return ( [resolvedName length] > 0 ) ? resolvedName : resolveName;
}
        

- (Class)_classForCommand:(NSString *)realCommand
{
    NSString *className = [NSString stringWithFormat:@"MiscMerge%@Command", realCommand];
    Class theClass = NSClassFromString(className);

    if (theClass == Nil)
    {
        className = [NSString stringWithFormat:@"_MiscMerge%@Command", realCommand];
        theClass = NSClassFromString(className);
    }

    if (theClass == Nil)
    {
        theClass = [self classForCommand:@"Field"];
    }

    return theClass;
}

/*"
 * Given the command string %{aCommand}, this method determines which
 * MiscMergeCommand subclass implements the merge command.  It returns the
 * class object needed to create instances of the MiscMergeCommand
 * subclass.
 *
 * This method works by asking the runtime if it can find Objective-C
 * classes with specific names.  The name that is looked up is build from
 * the first word found in %{aCommand}.  The first word is turned to all
 * lower case, with the first letter upper case, and then sandwiched
 * between "Merge" and "Command".  For example, the merge command "쳃f xxx
 * = y�" has the word "if" as the first word.  Thus, the class
 * "MergeIfCommand" will be searched for. If the desired class cannot be
 * found, then it is assumed that the merge command is giving the name of a
 * field which should be inserted into the output document.
 *
 * To avoid name space conflicts, all internal merge commands actually use
 * a slightly different name.  Thus, there really is no "MergeIfCommand" to
 * be found.  This method, when it doesn't find the "MergeIfCommand" class,
 * will search for another class, with a private name.  That class will be
 * found. (If it wasn't found, then the default "field" command class would
 * be returned.)  This allows a programmer to override any built in
 * command. To override the "if" command, simply create a "MergeIfCommand"
 * class and it will be found before the built in class.  If a programmer
 * wishes to make a particular command, such as "omit", inoperative, this
 * technique may be used to override with a MiscMergeCommand subclass that
 * does nothing.
"*/
- (Class)classForCommand:(NSString *)aCommand
{
    return [self _classForCommand:[[aCommand firstWord] capitalizedString]];
}


/*"
 * Reports the given error message, prefixed with filename and current line
 * number.
"*/
- (void)reportParseError:(NSString *)format, ...
{
    NSString *errorMessage;
    va_list args;

    va_start(args, format);
    errorMessage = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    if (_filename != nil)
        NSLog(@"%@: %d: %@", _filename, _lineNumber, errorMessage);
    else
        NSLog(@"Line %d: %@", _lineNumber, errorMessage);

    [errorMessage release];
}

- (void)_addCommand:(MiscMergeCommand *)command
{
    [[self currentCommandBlock] addCommand:command];
}

- (void)_addBetweenString:(NSString *)betweenString
{
    NSString *copyString = betweenString;

    switch ( _trimWhitespaceBehavior ) {
        case MiscMergeKeepNonBlankWhitespace:
            if ( [betweenString isBlank] )
                copyString = nil;
            break;
            
        case MiscMergeTrimWhitespace:
            copyString = [copyString stringByTrimmingWhitespace];
            break;

        case MiscMergeIgnoreCommandSpaces:
            copyString = MMStringByTrimmingCommandSpace(copyString);
            break;
            
        default:
            break;
    }

    /* Check to see if we are ignoring completely blank space or wanting to trim
    the space off of between strings. In both cases we then see if the trimmed string
    would result in no data written to the output, then we don't do anything here. */
    if ( [copyString length] > 0 ) {
        id command = [[[self _classForCommand:@"Copy"] alloc] init];
        /* Pass the trimmed string, or the passed in string depending if we are trimming strings */
        [command parseFromRawString:copyString];
        [self _addCommand:command];
        [command release];
    }

    _lineNumber += [betweenString numOfString:@"\n"];
}

- (void)_addCommandString:(NSString *)commandString
{
    Class commandClass = [self classForCommand:commandString];
    id command = [[commandClass alloc] init];
    [self _addCommand:command];
    [command parseFromString:commandString template:self];
    [command release];
    _lineNumber += [commandString numOfString:@"\n"];
}

/*"
 * Loads the contents of filename and calls -#parseString:.
"*/
- (void)parseContentsOfFile:(NSString *)filename
{
    NSString *string = [self contentsOfFileWithName:filename];
    [self setFilename:filename];
    [self parseString:string];
}

/*"
 * Parses the template in %{string}.
"*/
- (void)parseString:(NSString *)string
{
    NSMutableString *accumString = [[[NSMutableString alloc] init] autorelease];
    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSString *currString;
    int nestingLevel = 0;
    int maxNestingLevel = 0;
    BOOL inQuotes = NO;

    [scanner setCharactersToBeSkipped:nil];
    _lineNumber = 1;

    // may want to flush localPool every 50 loops or so...
    while (![scanner isAtEnd])
    {
        if ([scanner scanUpToCharactersFromSet:_parseStopChars intoString:&currString])
            [accumString appendString:currString];

        if ([scanner scanString:@"\\"])
        {
            BOOL     foundDelimiter;
            NSString *delimiter = nil;

            /* Look for the delimiters.  As a side effect, move scanner along */
            foundDelimiter = [scanner scanString:startDelimiter intoString:&delimiter] ||
                [scanner scanString:endDelimiter intoString:&delimiter];

            /*
             * Leave the backslash if we are not quoting a delimiter string
             * -- we would wreak havoc on RTF template files otherwise.
             * Also leave the backslash if we are deeply nesting or inside
             * quotes, as those sections will get reduced later.
             */
            if (nestingLevel > 1 || (nestingLevel == 1 && inQuotes) || !foundDelimiter)
            {
                [accumString appendString:@"\\"];
            }

            if (foundDelimiter)
                [accumString appendString:delimiter];
        }
        else if ([scanner scanString:@"\""])
        {
            [accumString appendString:@"\""];
            if (nestingLevel == 1) inQuotes = !inQuotes;
        }
        else if (nestingLevel > 0 && [scanner scanString:endDelimiter])
        {
            if (nestingLevel > 1)
            {
                [accumString appendString:endDelimiter];
            }
            else
            {
                /* Special hack for the delayed parsing stuff. Hm. */
                if (maxNestingLevel > 1)
                {
                    id command = [[[self _classForCommand:@"DelayedParse"] alloc] init];
                    _lineNumber += [accumString numOfString:@"\n"];
                    [command parseFromString:accumString template:self];
                    [self _addCommand:command];
                    [command release];
                }
                else
                {
                    if ([accumString length] > 0)
                        [self _addCommandString:[[accumString copy] autorelease]];
                }
                [accumString setString:@""];
                inQuotes = NO;
                maxNestingLevel = 0;
            }

            nestingLevel--;
        }
        else if ([scanner scanString:startDelimiter])
        {
            if (nestingLevel > 0)
            {
                [accumString appendString:startDelimiter];
            }
            else
            {
                if ([accumString length] > 0)
                    [self _addBetweenString:[[accumString copy] autorelease]];
                [accumString setString:@""];
            }

            nestingLevel++;
            if (nestingLevel > maxNestingLevel) maxNestingLevel = nestingLevel;
        }
        else if ([scanner scanLetterIntoString:&currString])
        {
            // If we can scan the end delimiter, it's an error, otherwise
            // it's just a string that starts with the same char as a
            // delimiter.
            [accumString appendString:currString];
        }
    }

    if ([accumString length] > 0)
    {
        [self _addBetweenString:[[accumString copy] autorelease]];
    }

    [localPool drain];
}

@end
