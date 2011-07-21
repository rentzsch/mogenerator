//
//  MiscMergeCommand.m
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

#import "MiscMergeCommand.h"
#import <Foundation/NSCharacterSet.h>
//#import <Foundation/NSUtilities.h>
#import <Foundation/NSArray.h>
#import <stdlib.h>  // NULL on OSX
#import "NSScanner+MiscMerge.h"
#import "MiscMergeExpression.h"
#import "NSString+MiscAdditions.h"
#import "MiscMergeFunctions.h"

@implementation MiscMergeCommand
/*"
 * The MiscMergeCommand class implements a merge command.  Since the
 * MiscKit merge engine can dynamically add new commands, it is possible to
 * create custom subclasses of MiscMergeCommand to implement new
 * functionality in the engine.  The merge engine already implements most
 * of the commands a user would want, but certain applications may wish to
 * override those commands, replace them, or add new commands.
 *
 * To create a subclass, two methods, -#{executeForMerge:} and either
 * -#{parseFromString:template} or -#parseFromScanner:template: need to be
 * implemented.  The parse method is expected to break up a text string
 * into whatever arguments a particular MiscMergeCommand subclass needs in
 * order to function.  The execute method performs, during a merge,
 * whatever special task the command is designed to do.
 *
 * The other methods in this object may be used by subclasses to aid in
 * parsing the command string.  They can grab key words, conditional
 * operators, an arguments (single word or quoted string).  A special kind
 * of argument, promptable, is also supported.  A promptable argument is
 * expected to have its actual value determined at run time.
 *
 * When implementing commands, the full API of the MiscMergeEngine object
 * is available.  This allows the programmer to store information in the
 * engine, manipulate the symbol tables used for resolving fields, and
 * alter the output being created by the merge.
 *
 * The MiscKit source code is a good place to look for examples of how to
 * implement various MiscMergeCommand subclasses.
"*/

/*"
 * This method is called while parsing a merge template.  The text of the
 * full merge command is contained in %{aString}.  The default
 * implementation creates an NSScanner with aString and calls
 * -#parseFromScanner:template:.  If there is no need to parse the string,
 * then override this method; otherwise override the scanner method.
"*/
- (BOOL)parseFromString:(NSString *)aString template:(MiscMergeTemplate *)template
{
    static NSCharacterSet *whiteSet = nil;
    NSScanner *scanner = [NSScanner scannerWithString:aString];

    /* +whitespaceAndNewlineCharacterSet doesn't have \r ! */
    if (whiteSet == nil)
        whiteSet = [[NSCharacterSet characterSetWithCharactersInString:@" \t\n\r\v\f"] retain];
    [scanner setCharactersToBeSkipped:whiteSet];

    return [self parseFromScanner:scanner template:template];
}

/*"
 * This method is called while parsing a merge template, typically by
 * -#parseFromString:template:. This method should break %{aScanner}'s
 * string up into keywords, conditionals, and arguments as needed and store
 * the results in instance variables for later use during merges.  Note
 * that returning YES tells the template parsing machinery that all is
 * well.  Return NO if there is an error or the command cannot be properly
 * initialized.  The default implementation returns NO; either this method
 * or -#parseFromString:template: needs to be overridden in subclasses.
"*/
- (BOOL)parseFromScanner:(NSScanner *)aScanner template:(MiscMergeTemplate *)template
{
    return NO;
}

/*"
 * This method is called by the merge engine while it is performing a
 * merge.  The command is expected to perform its specified function when
 * this call is received.
"*/
- (MiscMergeCommandExitType)executeForMerge:(MiscMergeEngine *)aMerger
{
    // subclass responsibility
    return MiscMergeCommandExitNormal;
}


/*"
 * Attempts to scan past of %{aKeyWord} in %{scanner}. If %{optional} is
 * YES, then no complaint will be made if %{aKeyWord} is missing.  YES or
 * NO is returned to tell the caller if the required key word was found or
 * not, no matter what the value of %{optional} was.
"*/
- (BOOL)eatKeyWord:(NSString *)aKeyWord fromScanner:(NSScanner *)scanner
        isOptional:(BOOL)optional
{
    NSCharacterSet *letterSet = [NSCharacterSet letterCharacterSet];
    NSUInteger origLocation = [scanner scanLocation];
    BOOL isAlphaKeyword = [aKeyWord length] > 0 && [letterSet characterIsMember:[aKeyWord characterAtIndex:0]];
    BOOL wasCaseSensitive = [scanner caseSensitive];
    BOOL foundKeyword;

    [scanner setCaseSensitive:NO];
    foundKeyword = [scanner scanString:aKeyWord intoString:NULL];

    /* Make sure we got the whole word, not just a prefix of the keyword */
    if (foundKeyword && isAlphaKeyword)
    {
        NSString *string = [scanner string];
        NSUInteger currLocation = [scanner scanLocation];

        /* If we're at the end of the string, or the next char is not a letter, we're good. Otherwise abort. */
        if (currLocation < [string length] &&
            [letterSet characterIsMember:[string characterAtIndex:currLocation]])
        {
            foundKeyword = NO;
            [scanner setScanLocation:origLocation];
        }
    }

    if (!foundKeyword && !optional) [self error_keyword:aKeyWord];
    [scanner setCaseSensitive:wasCaseSensitive];

    return foundKeyword;
}

- _getQuotedArgumentStringFromScanner:(NSScanner *)scanner toEnd:(BOOL)endFlag quoteCharacter:(char)quoteCharacter
{
    NSMutableString *parsedString = [[[NSMutableString alloc] init] autorelease];
    NSCharacterSet *stopSet = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"\\%c", quoteCharacter]];
    NSCharacterSet *origSkipSet = [[[scanner charactersToBeSkipped] retain] autorelease];
    NSString *workString = nil;
    NSString *quoteCharString = [NSString stringWithFormat:@"%c", quoteCharacter];

    [scanner setCharactersToBeSkipped:nil]; //Don't skip spaces inside of quotes
    [scanner scanCharacter:quoteCharacter]; //scan past open quote if its there

    while (![scanner isAtEnd]) {
        if ([scanner scanUpToCharactersFromSet:stopSet intoString:&workString])
            [parsedString appendString:workString];

        if ([scanner scanCharacter:'\\'])
        {
            if ([scanner scanLetterIntoString:&workString])
            {
                /*" Leave the backslash if not quoting the '"' character */
                // Need to allow quoted delimiters here as well?
                if (![workString isEqualToString:quoteCharString])
                    [parsedString appendString:@"\\"];

                [parsedString appendString:workString];
           }
        }
        else if ([scanner scanCharacter:quoteCharacter])
        {
            if (endFlag && ![scanner isAtEnd])
            {
                [self error_closequote];
                //[parsedString appendString:[scanner remainingString]];
                [scanner remainingString];
            }

            [scanner setCharactersToBeSkipped:origSkipSet];
            return parsedString;
        }
    }

    [scanner setCharactersToBeSkipped:origSkipSet];
    [self error_closequote];
    return parsedString;
}

- _getQuotedArgumentStringFromScanner:(NSScanner *)scanner toEnd:(BOOL)endFlag
{
    return [self _getQuotedArgumentStringFromScanner:scanner toEnd:endFlag quoteCharacter:'\"'];
}

/*"
 * Attempts to parse an argument from %{scanner}.  If %{endFlag} is set,
 * then the remaining string of %{scanner} will be assumend to be the
 * required argument.  Otherwise, if an argument contains whitespace, it
 * should be surrounded by quotation marks (" or '). If the argument is
 * quoted, the size of the quotes (0, 1, 2) will be returned in %{quotes}.
 * The parsed argument will scanned past in %{scanner}.
"*/
- getArgumentStringFromScanner:(NSScanner *)scanner toEnd:(BOOL)endFlag quotes:(int *)quotes
{
    char nextCharacter = [scanner peekNextCharacter];

    if ( quotes != NULL )
        *quotes = 0;

    if ( nextCharacter == '\'' || nextCharacter == '\"' ) {
        if ( quotes != NULL )
            *quotes = ( nextCharacter == '\'' ) ? 1 : 2;
        return [self _getQuotedArgumentStringFromScanner:scanner toEnd:endFlag quoteCharacter:nextCharacter];
    }
    else if (endFlag)
    {
        return [scanner remainingString];
    }
    else
    {
        NSCharacterSet *stopSet;
        NSString *workString;

        stopSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\r\n\v\f<>!=()|&,"];
        if ([scanner scanUpToCharactersFromSet:stopSet intoString:&workString])
            return workString;
    }

    return nil;
}

/*"
 * Attempts to parse an argument from %{scanner}.  If %{endFlag} is set,
 * then the remaining string of %{scanner} will be assumend to be the
 * required argument.  Otherwise, if an argument contains whitespace, it
 * should be surrounded by quotation marks ("). The parsed argument will
 * scanned past in %{scanner}.
"*/
- getArgumentStringFromScanner:(NSScanner *)scanner toEnd:(BOOL)endFlag
{
    return [self getArgumentStringFromScanner:scanner toEnd:endFlag quotes:NULL];
}


/*"
 * Attempts to parse a promptable argument from %{scanner}.  If the
 * argument begins with a "?" then the argument is a "prompt".  Scans past
 * the parsed argument in %{scanner} and returns it.  Returns nil if the
 * wrong kind of argument was found.  It is expected that a promptable
 * argument's value will be determined at run time by asking the user for
 * the value that should be stored for it.
"*/
- getPromptFromScanner:(NSScanner *)scanner toEnd:(BOOL)endFlag
{
    if ([scanner scanCharacter:'?'])
    {
        return [self getArgumentStringFromScanner:scanner toEnd:endFlag];
    }
    else
    {
        [self error_noprompt];
        return nil;
    }
}

/*"
 * Attempts to parse an argument, which could be promptable, from
 * %{scanner}. If the argument begins with a "?" then the argument is a
 * "prompt".  Otherwise, a regular argument is parsed.  Scans past the
 * parsed argument in %{scanner} and returns it.  %{prompt} is set to YES
 * or NO depending upon what was parsed.
"*/
- getPromptableArgumentStringFromScanner:(NSScanner *)scanner wasPrompt:(BOOL *)prompt toEnd:(BOOL)endFlag
{
    if ([scanner peekNextCharacter] == '?') {
        *prompt = YES;
        return [self getPromptFromScanner:scanner toEnd:endFlag];
    } else {
        *prompt = NO;
        return [self getArgumentStringFromScanner:scanner toEnd:endFlag];
    }
    return nil;
}


/* Expression parsing */

- (MiscMergeExpression *)getPrimaryExpressionFromScanner:(NSScanner *)aScanner
{
    if ( [self eatKeyWord:@"(" fromScanner:aScanner isOptional:YES] ) {
        MiscMergeExpression *expression = [self getExpressionFromScanner:aScanner];
        
        if (![self eatKeyWord:@")" fromScanner:aScanner isOptional:YES])
            [self error_closeparens];

        return expression;
    }
    else {
        int quote = 0;
        NSString *value = [self getArgumentStringFromScanner:aScanner toEnd:NO quotes:&quote];

        if ( value == nil )
            return nil;
        else
            return [MiscMergeValueExpression valueName:value quotes:quote];
    }
}

- (MiscMergeExpression *)_getUnaryExpressionFromScanner:(NSScanner *)aScanner
{
    if ( [self eatKeyWord:@"-" fromScanner:aScanner isOptional:YES] ) {
        MiscMergeExpression *expression = [self _getUnaryExpressionFromScanner:aScanner];

        if ( expression == nil )
            NSLog(@"No expression found on right side of Negative expression.");
        else
            return [MiscMergeNegativeExpression expression:expression];
    }
    else if ( [self eatKeyWord:@"!" fromScanner:aScanner isOptional:YES] ) {
        MiscMergeExpression *expression = [self _getUnaryExpressionFromScanner:aScanner];

        if ( expression == nil )
            NSLog(@"No expression found on right side of Negation expression.");
        else
            return [MiscMergeNegateExpression expression:expression];
    }
    else
        return [self getPrimaryExpressionFromScanner:aScanner];

    return nil;
}

- (MiscMergeExpression *)_getMultiplicativeExpressionFromScanner:(NSScanner *)aScanner
{
    MiscMergeExpression *expression = [self _getUnaryExpressionFromScanner:aScanner];

    while ( 1 ) {
        if ( [self eatKeyWord:@"*" fromScanner:aScanner isOptional:YES] ) {
            MiscMergeExpression *rightExpression = [self _getUnaryExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of Multiplication expression.");
            else
                expression = [MiscMergeMathExpression leftExpression:expression
                                                            operator:MiscMergeOperatorMultiply
                                                     rightExpression:rightExpression];
        }
        else if ( [self eatKeyWord:@"/" fromScanner:aScanner isOptional:YES] ) {
            MiscMergeExpression *rightExpression = [self _getUnaryExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of Division expression.");
            else
                expression = [MiscMergeMathExpression leftExpression:expression
                                                            operator:MiscMergeOperatorDivide
                                                     rightExpression:rightExpression];
        }
        else if ( [self eatKeyWord:@"%" fromScanner:aScanner isOptional:YES] ) {
            MiscMergeExpression *rightExpression = [self _getUnaryExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of Modulus expression.");
            else
                expression = [MiscMergeMathExpression leftExpression:expression
                                                            operator:MiscMergeOperatorModulus
                                                     rightExpression:rightExpression];
        }
        else
            return expression;
    }
}

- (MiscMergeExpression *)_getAdditiveExpressionFromScanner:(NSScanner *)aScanner
{
    MiscMergeExpression *expression = [self _getMultiplicativeExpressionFromScanner:aScanner];

    while ( 1 ) {
        if ( [self eatKeyWord:@"+" fromScanner:aScanner isOptional:YES] ) {
            MiscMergeExpression *rightExpression = [self _getMultiplicativeExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of Addition expression.");
            else
                expression = [MiscMergeMathExpression leftExpression:expression
                                                            operator:MiscMergeOperatorAdd
                                                     rightExpression:rightExpression];
        }
        else if ( [self eatKeyWord:@"-" fromScanner:aScanner isOptional:YES] ) {
            MiscMergeExpression *rightExpression = [self _getMultiplicativeExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of Subtraction expression.");
            else
                expression = [MiscMergeMathExpression leftExpression:expression
                                                            operator:MiscMergeOperatorSubtract
                                                     rightExpression:rightExpression];
        }
        else
            return expression;
    }
}

- (MiscMergeExpression *)_getRelationalExpressionFromScanner:(NSScanner *)aScanner
{
    MiscMergeExpression *expression = [self _getAdditiveExpressionFromScanner:aScanner];

    while ( 1 ) {
        if ( [self eatKeyWord:@"<=" fromScanner:aScanner isOptional:YES] ||
             [self eatKeyWord:@"=<" fromScanner:aScanner isOptional:YES] ||
             [self eatKeyWord:@"le" fromScanner:aScanner isOptional:YES] )
        {
            MiscMergeExpression *rightExpression = [self _getAdditiveExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of Less Than Or Equal expression.");
            else
                expression = [MiscMergeConditionalExpression leftExpression:expression
                                                                   operator:MiscMergeOperatorLessThanOrEqual
                                                            rightExpression:rightExpression];
        }
        else if ( [self eatKeyWord:@">=" fromScanner:aScanner isOptional:YES] ||
                  [self eatKeyWord:@"=>" fromScanner:aScanner isOptional:YES] ||
                  [self eatKeyWord:@"ge" fromScanner:aScanner isOptional:YES] )
        {
            MiscMergeExpression *rightExpression = [self _getAdditiveExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of Greater Than Or Equal expression.");
            else
                expression = [MiscMergeConditionalExpression leftExpression:expression
                                                                   operator:MiscMergeOperatorGreaterThanOrEqual
                                                            rightExpression:rightExpression];
        }
        else if ( [self eatKeyWord:@"<" fromScanner:aScanner isOptional:YES] ||
                  [self eatKeyWord:@"lt" fromScanner:aScanner isOptional:YES] )
        {
            MiscMergeExpression *rightExpression = [self _getAdditiveExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of Less Than expression.");
            else
                expression = [MiscMergeConditionalExpression leftExpression:expression
                                                                   operator:MiscMergeOperatorLessThan
                                                            rightExpression:rightExpression];
        }
        else if ( [self eatKeyWord:@">" fromScanner:aScanner isOptional:YES] ||
                  [self eatKeyWord:@"gt" fromScanner:aScanner isOptional:YES] )
        {
            MiscMergeExpression *rightExpression = [self _getAdditiveExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of Greater Than expression.");
            else
                expression = [MiscMergeConditionalExpression leftExpression:expression
                                                                   operator:MiscMergeOperatorGreaterThan
                                                            rightExpression:rightExpression];
        }
        else
            return expression;
    }
}

- (MiscMergeExpression *)_getEqualExpressionFromScanner:(NSScanner *)aScanner
{
    MiscMergeExpression *expression = [self _getRelationalExpressionFromScanner:aScanner];

    while ( 1 ) {
        if ( [self eatKeyWord:@"<>" fromScanner:aScanner isOptional:YES] ||
             [self eatKeyWord:@"><" fromScanner:aScanner isOptional:YES] ||
             [self eatKeyWord:@"!=" fromScanner:aScanner isOptional:YES] ||
             [self eatKeyWord:@"neq" fromScanner:aScanner isOptional:YES] ||
             [self eatKeyWord:@"ne" fromScanner:aScanner isOptional:YES] )
        {
            MiscMergeExpression *rightExpression = [self _getRelationalExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of inequality expression.");
            else
                expression = [MiscMergeConditionalExpression leftExpression:expression
                                                                   operator:MiscMergeOperatorNotEqual
                                                            rightExpression:rightExpression];
        }
        else if ( [self eatKeyWord:@"==" fromScanner:aScanner isOptional:YES] ||
                  [self eatKeyWord:@"=" fromScanner:aScanner isOptional:YES] ||
                  [self eatKeyWord:@"eq" fromScanner:aScanner isOptional:YES] )
        {
            MiscMergeExpression *rightExpression = [self _getRelationalExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of equality expression.");
            else
                expression = [MiscMergeConditionalExpression leftExpression:expression
                                                                   operator:MiscMergeOperatorEqual
                                                            rightExpression:rightExpression];
        }
        else if ( [self eatKeyWord:@"in" fromScanner:aScanner isOptional:YES] ) {
            MiscMergeExpression *rightExpression = [self _getRelationalExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of in expression.");
            else
                expression = [MiscMergeContainsExpression leftExpression:expression
                                                                operator:MiscMergeOperatorIn
                                                         rightExpression:rightExpression];
        }
        else if ( [self eatKeyWord:@"notin" fromScanner:aScanner isOptional:YES] ) {
            MiscMergeExpression *rightExpression = [self _getRelationalExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No expression found on right side of notin expression.");
            else
                expression = [MiscMergeContainsExpression leftExpression:expression
                                                                operator:MiscMergeOperatorNotIn
                                                         rightExpression:rightExpression];
        }
        else
            return expression;
    }
}

- (MiscMergeExpression *)_getAndExpressionFromScanner:(NSScanner *)aScanner
{
    MiscMergeExpression *expression = [self _getEqualExpressionFromScanner:aScanner];
    NSMutableArray *array = [NSMutableArray arrayWithObject:expression];

    while ( 1 ) {
        if ( [self eatKeyWord:@"&&" fromScanner:aScanner isOptional:YES] ||
             [self eatKeyWord:@"and" fromScanner:aScanner isOptional:YES] )
        {
            MiscMergeExpression *rightExpression = [self _getEqualExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No trailing expression found for OR conditional.");
            else
                [array addObject:rightExpression];
        }
        else if ( [array count] > 1 )
            return [MiscMergeAndExpression expressions:array];
        else
            return expression;
    }
}

- (MiscMergeExpression *)_getOrExpressionFromScanner:(NSScanner *)aScanner
{
    MiscMergeExpression *expression = [self _getAndExpressionFromScanner:aScanner];
    NSMutableArray *array = [NSMutableArray arrayWithObject:expression];

    while ( 1 ) {
        if ( [self eatKeyWord:@"||" fromScanner:aScanner isOptional:YES] ||
             [self eatKeyWord:@"or" fromScanner:aScanner isOptional:YES] )
        {
            MiscMergeExpression *rightExpression = [self _getAndExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No trailing expression found for AND conditional.");
            else
                [array addObject:rightExpression];
        }
        else if ( [array count] > 1 )
            return [MiscMergeOrExpression expressions:array];
        else
            return expression;
    }
}

- (MiscMergeExpression *)getExpressionFromScanner:(NSScanner *)aScanner
{
    MiscMergeExpression *expression = [self _getOrExpressionFromScanner:aScanner];
    NSMutableArray *array = [NSMutableArray arrayWithObject:expression];
    
    while ( 1 ) {
        if ( [self eatKeyWord:@"," fromScanner:aScanner isOptional:YES] ) {
            MiscMergeExpression *rightExpression = [self _getOrExpressionFromScanner:aScanner];

            if ( rightExpression == nil )
                NSLog(@"No right side of comma separated expression.");
            else
                [array addObject:rightExpression];
        }
        else if ( [array count] > 1 )
            return [MiscMergeListExpression expressions:array];
        else
            return expression;
    }
}


- (BOOL)isKindOfCommandClass:(NSString *)aCommand
{
    NSString *realCommand = [[aCommand firstWord] capitalizedString];
    NSString *className = [NSString stringWithFormat:@"_MiscMerge%@Command", realCommand];
    Class theClass = NSClassFromString(className);

    if ( [self isKindOfClass:theClass] )
        return YES;

    className = [NSString stringWithFormat:@"MiscMerge%@Command", realCommand];
    theClass = NSClassFromString(className);
    return [self isKindOfClass:theClass];
}


/*"
 * This method is called if, while parsing, it is discovered that a
 * conditional is unrecognized.  Prints the name of the merge command
 * class, the text "Unrecognized conditional:", and the -#description of
 * %{theCond} to the console using NSLog().
"*/
- (void)error_conditional:(NSString *)theCond
{
    NSLog(@"%@:  Unrecognized conditional:  \"%@\".", [self class], theCond);
}

/*"
 * This method is called if, while parsing, it is discovered that a
 * required key word is missing.  Prints the name of the merge command
 * class, the text "Missing key word:", and %{aKeyWord} to the console
 * using NSLog().
"*/
- (void)error_keyword:(NSString *)aKeyWord
{
    NSLog(@"%@:  Missing key word:  \"%@\".", [self class], aKeyWord);
}

/*"
 * This method is called if, while parsing, it is discovered that the
 * required prompt is missing.  (Referring to arguments that are
 * promptable.)  Prints the name of the merge command class and the text
 * "Missing prompt." to the console using NSLog().
"*/
- (void)error_noprompt
{
    NSLog(@"%@:  Missing prompt.", [self class]);
}

/*"
 * This method is called if, while parsing, it is discovered that
 * quotations are not matched up properly.  Prints the name of the merge
 * command class and the text "Closing quote missing or spurious extra
 * argument added." to the console using NSLog().
"*/
- (void)error_closequote
{
    NSLog(@"%@:  Closing quote missing or spurious extra argument added.", [self class]);
}

/*"
 * This method is called if, while parsing condition strings, it is discovered
 * that a closing parenthesis is missing. Prints the name of the merge command
 * class and the text "Closing parenthesis missing." to the console using
 * NSLog().
"*/
- (void)error_closeparens
{
    NSLog(@"%@:  Closing parenthesis missing.", [self class]);
}

/*"
 * This method is called if, while parsing a command that requires a specific argument
 * that the argument was not valid. Prints the name of the merge command class and the text
 * "Invalid argument:.", and the -#description of %{theArgument} to the console using NSLog().
"*/
- (void)error_argument:(NSString *)theArgument
{
    NSLog(@"%@:  Unrecognized argument:  \"%@\".", [self class], theArgument);
}

@end
