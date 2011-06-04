//
//  MiscMergeEngine.m
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

#import "MiscMergeEngine.h"
#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSAutoreleasePool.h>
#import "MiscMergeTemplate.h"
#import "MiscMergeCommand.h"
#import "MiscMergeCommandBlock.h"
#import "KeyValue+MiscMerge.h"
#import "NSNull.h"
#import "MiscMergeFunctions.h"

#define RECURSIVE_LOOKUP_LIMIT 100

/*
 * We can't #import a header, since we could be using either MiscKeyValue,
 * EOControl, or (on MacOS X) Foundation.
 */
@interface NSObject (WarningAvoidance)
- (id)valueForKeyPath:(NSString *)keyPath;
@end

@implementation MiscMergeEngine
/*"
 * A MiscMergeEngine is the heart of the merging object suite.  It actually
 * performs the merges.  To use it, simply give it a MiscMergeTemplate that
 * has been properly set up with -#{setTemplate:}.  Next, give it a data
 * object (-#{setMainObject:}) that has values for the contents of the
 * merge fields.  Finally, send an -#{execute:} message to start things
 * off.  -#valueForKeyPath: will be called on the main object with the
 * field names in the template, and the values returned will be substituted
 * in the output. An NSString will be returned that contains the results of
 * the merge.
 * 
 * The rest of the methods are an API to the internal state of the engine
 * which may be used in MiscMergeCommand subclass implementations.
 * 
 * To implement MiscMergeCommands, it is important to understand some of
 * the internals of the MiscMergeEngine class.
 * 
 * The main thing to know is that there is an "output" string that is kept
 * throughout the merge and returned at the end.  MiscMergeCommands should
 * append strings to it as necessary with the -#{appendToOutput:} method.
 * 
 * The MiscMergeEngine resolves field names through a series of symbol
 * tables.  Commands can request that arguments be "resolved" through these
 * symbol tables with the -#{valueForField:} method. The process is to walk
 * down the context stack until an object with the desired key is found.
 * The search will look first for local variables, then on the main object,
 * then in the engine variables, and finally in the global variables.  If
 * any context objects are placed on the stack by MiscMergeCommands, they
 * are searched first. If the key is not found, then the "parent" merge, if
 * it exists, is consulted. If the key is not found, then the key itself is
 * returned.
 * 
 * If recursive lookups are turned on, the value returned by a lookup will
 * be used as a field name and the lookup repeated, causing an indirection
 * to take place (if a value is found for the new field name). This process
 * will be repeated as far as possible, so there can be multiple levels of
 * indirection.  Use the -#setUseRecursiveLookups: method to turn this
 * feature on or off.
 * 
 * By doing this extensive resolution, it is possible to use
 * MiscMergeCommands to create aliases for field names.  It is also
 * possible to use the global tables to contain "default" values for any
 * merge fields that might turn up empty on a particular merge.  Note that
 * there are specific methods which may be used to manipulate the local,
 * engine, and global symbol tables, as well as set up the parent merge.
 * 
 * Another special feature of the MiscMergeEngine is that it can carry
 * internal "variables" in its userInfo dictionary.  A variable is some
 * object that contains state and needs to be accessible throughout a
 * merge.  This is useful for groups of MiscMergeCommands that need to pass
 * information between each other, but do not specifically know about each
 * other.  Simply manipulate the userInfo dictionary (returned by the
 * -#userInfo method) to store or retrieve information as desired.  The
 * userInfo dictionary is not consulted during symbol lookups, and is
 * cleared at the start of a new merge, so only data pertaining to a merge
 * should be stored there.  This is the preferred way for MiscMergeCommands
 * to communicate with each other.
 * 
 * The current API should be adequate to perform most things a
 * MiscMergeCommand would want to do.  However, it is possible that more
 * functionality would be helpful or that some bit of information is still
 * inaccessible.  If this is the case, complain to the author (Don
 * Yacktman, don@misckit.com) and he will consider enhancing the API to
 * this object as necessary.  Of course, subclasses and categories might
 * also be workable approaches to such deficiencies.
"*/

static NSMutableDictionary *globalSymbols = nil;

/*"
 * Returns the static NSMutableDictionary used to store global symbols.
 * Global symbols are the last context searched when resolving names, and
 * are valid for every merge done in your program (i.e. the same dictionary
 * is used in all MiscMergeEngine instances).
"*/
+ (NSMutableDictionary *)globalSymbolsDictionary
{
    if (globalSymbols == nil) globalSymbols = [[NSMutableDictionary alloc] init];
    return globalSymbols;
}

/*"
 * Sets the global symbol aKey to anObject.  A value of nil is the same as
 * removing the value.
"*/
+ (void)setGlobalValue:(id)anObject forKey:(NSString *)aKey
{
    if (anObject == nil)
        [self removeGlobalValueForKey:aKey];
    else
        [[self globalSymbolsDictionary] setObject:anObject forKey:aKey];
}

/*" Removes the global value associated with aKey. "*/
+ (void)removeGlobalValueForKey:(NSString *)aKey
{
    [[self globalSymbolsDictionary] removeObjectForKey:aKey];
}

/*" Returns the global value for aKey. "*/
+ (id)globalValueForKey:(NSString *)aKey
{
    return [globalSymbols objectForKey:aKey];
}


/*" The designated initializer. "*/
- init
{
    [super init];
    userInfo      = [[NSMutableDictionary alloc] init];
    engineSymbols = [[NSMutableDictionary alloc] init];
    mergeSymbols  = [[NSMutableDictionary alloc] init];
    localSymbols = mergeSymbols;
    contextStack  = [[NSMutableArray alloc] init];
    commandStack  = [[NSMutableArray alloc] init];
    return self;
}

/*"
 * Initializes a new MiscMergeEngine instance, setting the current template
 * to %{aTemplate}.
"*/
- initWithTemplate:(MiscMergeTemplate *)aTemplate
{
    [self init];
    [self setTemplate:aTemplate];
    return self;
}

- (void)dealloc
{
    [userInfo release];
    [contextStack release];
    [commandStack release];
    [engineSymbols release];
    [mergeSymbols release];
    [template release];
    [currentObject release];
    [outputString release];
    [super dealloc];
}

/*"
 * Returns whether delimiters around unresolvable field names will be left
 * in the generated output, or if just the field name itself will be left.
 * The default is NO; i.e. the field name will remain.  Setting this to YES
 * can be helpful during debugging.
"*/
- (BOOL)keepsDelimiters
{
    return keepDelimiters;
}

/*"
 * Sets whether to leave the delimiters in the generated output around
 * field names that could not be resolved.
"*/
- (void)setKeepsDelimiters:(BOOL)shouldKeep
{
    keepDelimiters = shouldKeep;
}


- (MiscMergeFailedLookupResultType)failedLookupResult
{
    return failedLookupResult;
}
- (void)setFailedLookupResult:(MiscMergeFailedLookupResultType)type
{
    failedLookupResult = type;
}

- (MiscMergeNilLookupResultType)nilLookupResult
{
    return nilLookupResult;
}
- (void)setNilLookupResult:(MiscMergeNilLookupResultType)type
{
    nilLookupResult = type;
}


/*"
 * Returns YES if recursive lookups are being used.  During symbol
 * resolution, if a resolved value is an NSString object and recursive
 * lookups are turned on, then the value is used as a key itself and the
 * symbol lookup is repeated.  This process repeats until a value is not
 * found or it's not an NSString object, at which point the last valid
 * value will be returned.  This allows for multiple levels of indirection.
 * Be careful when using this feature, as it can lead to unexpected
 * problems.  For example, if the main object is not a dictionary,
 * returning a string that has the same name as a method on that object
 * (such as "description" or "zone") can lead to interesting (unintended)
 * results or even exceptions being raised.  Also, if an indirect value is
 * the same as a previously-resolved key, then the merge engine will go
 * into an infinite loop. By default, recursive lookups are turned off.
"*/
- (BOOL)useRecursiveLookups
{
    return useRecursiveLookups;
}

/*"
 * Set whether to use recursive lookups when resolving field names.
 * setUseRecursiveLookup
"*/
- (void)setUseRecursiveLookups:(BOOL)shouldRecurse
{
    useRecursiveLookups = shouldRecurse;
    recursiveLookupLimit = RECURSIVE_LOOKUP_LIMIT;
}


- (int)recursiveLookupLimit
{
    return recursiveLookupLimit;
}
- (void)setRecursiveLookupLimit:(int)recurseLimit
{
    recursiveLookupLimit = recurseLimit;
}


- (void)setUseRecursiveLookups:(BOOL)shouldRecurse limit:(int)recurseLimit
{
    useRecursiveLookups = shouldRecurse;
    recursiveLookupLimit = recurseLimit;
}



/*"
 * Returns the output string from the latest merge, the same string
 * returned by the -#execute: method.
"*/
- (NSString *)outputString
{
    return outputString;
}

/*" Returns the "parent" merge engine, or nil if not set. "*/
- (MiscMergeEngine *)parentMerge
{
    return parentMerge;
}

/*"
 * Returns the userInfo dictionary, which can be manipulated by commands
 * for their needs.
"*/
- (NSMutableDictionary *)userInfo
{
    return userInfo;
}

/*"
 * Sets the "parent" merge for this merge engine.  If a symbol cannot be
 * found in the receiving instance's symbol table during lookup, the parent
 * will be consulted to see if it is defined there.
"*/
- (void)setParentMerge:(MiscMergeEngine *)anEngine
{
    parentMerge = anEngine;
}

/*" An instance method convenience for +#setGlobalValue:forKey:. "*/
- (void)setGlobalValue:(id)anObject forKey:(NSString *)aKey
{
    [[self class] setGlobalValue:anObject forKey:aKey];
}
/*" An instance method convenience for +#removeGlobalValueForKey:. "*/
- (void)removeGlobalValueForKey:(NSString *)aKey
{
    [[self class] removeGlobalValueForKey:aKey];
}
/*" An instance method convenience for +#globalValueForKey:. "*/
- (id)globalValueForKey:(NSString *)aKey
{
    return [[self class] globalValueForKey:aKey];
}


/*"
 * Sets the engine symbol aKey to anObject.  A value of nil is the same as
 * removing the value.  The engine symbols are searched after the main
 * object but before the global symbols when resolving a name.  They remain
 * valid for every merge executed by the receiving MiscMergeEngine instance.
"*/
- (void)setEngineValue:(id)anObject forKey:(NSString *)aKey
{
    if (anObject)
        [engineSymbols setObject:anObject forKey:aKey];
    else
        [self removeGlobalValueForKey:aKey];
}

/*" Removes the engine value associated with aKey "*/
- (void)removeEngineValueForKey:(NSString *)aKey
{
    [engineSymbols removeObjectForKey:aKey];
}
/*" Returns the engine value associated with aKey "*/
- (id)engineValueForKey:(NSString *)aKey
{
    return [engineSymbols objectForKey:aKey];
}


/*"
 * Sets the merge symbol aKey to anObject.  A value of nil is the same as
 * removing the value.  The engine symbols are searched before the main
 * object when resolving a name.  Local symbols are only valid for the
 * current merge; the local symbol table is emptied before executing a
 * merge.
"*/
- (void)setMergeValue:(id)anObject forKey:(NSString *)aKey
{
    if (anObject)
        [mergeSymbols setObject:anObject forKey:aKey];
    else
        [self removeMergeValueForKey:aKey];
}
/*" Removes the merge value associated with aKey "*/
- (void)removeMergeValueForKey:(NSString *)aKey
{
    [mergeSymbols removeObjectForKey:aKey];
}
/*" Returns the merge value associated with aKey "*/
- (id)mergeValueForKey:(NSString *)aKey
{
    return [mergeSymbols objectForKey:aKey];
}


/*"
 * Sets the local symbol aKey to anObject.  A value of nil is the same as
 * removing the value.  The engine symbols are searched before the main
 * object when resolving a name.  Local symbols are only valid for the
 * current merge; the local symbol table is emptied before executing a
 * merge.
"*/
- (void)setLocalValue:(id)anObject forKey:(NSString *)aKey
{
    if (anObject)
        [localSymbols setObject:anObject forKey:aKey];
    else
        [self removeLocalValueForKey:aKey];
}
/*" Removes the local value associated with aKey "*/
- (void)removeLocalValueForKey:(NSString *)aKey
{
    [localSymbols removeObjectForKey:aKey];
}
/*" Returns the local value associated with aKey "*/
- (id)localValueForKey:(NSString *)aKey
{
    return [localSymbols objectForKey:aKey];
}


/*"
 * Adds a new context for symbol lookups.  MiscMergeCommands can use this
 * to add their own contexts to define variables that last only during the
 * execution of that command.
"*/
- (void)addContextObject:(id)anObject andSetLocalSymbols:(BOOL)flag
{
    [contextStack addObject:anObject];

    if ( flag && [anObject isKindOfClass:[NSMutableDictionary class]] )
        localSymbols = anObject;
}
- (void)addContextObject:(id)anObject
{
    [self addContextObject:anObject andSetLocalSymbols:NO];
}

/*" Removes anObject from the context stack. "*/
- (void)removeContextObject:(id)anObject
{
    if (anObject && anObject != currentObject
        && anObject != globalSymbols
        && anObject != engineSymbols
        && anObject != mergeSymbols)
    {
        // should only remove last occurrence, not all FIXME
        [contextStack removeObjectIdenticalTo:anObject];

        if ( anObject == localSymbols ) {
            NSInteger i;

            localSymbols = nil;

            for ( i = [contextStack count] - 1; i >= 0; i-- ) {
                id object = [contextStack objectAtIndex:i];

                if ( [object isKindOfClass:[NSMutableDictionary class]] ) {
                    localSymbols = object;
                    break;
                }
            }

            if ( localSymbols == nil ) {
                localSymbols = mergeSymbols;
            }
        }
    }
}

/*" Returns the main data object to be used in the next merge. "*/
- (id)mainObject
{
    return currentObject;
}

/*" Returns the MiscMergeTemplate to be used for the next merge. "*/
- (MiscMergeTemplate *)template
{
    return template;
}

/*"
 * Sets the main data object.  The next invocation of -#{execute:} will use
 * %{anObject} as the main data object for the merge.  Can be called during
 * a merge to change the main object.
"*/
- (void)setMainObject:(id)anObject
{
    NSUInteger oldIndex = NSNotFound;

    if (currentObject != nil)
    {
        oldIndex = [contextStack indexOfObject:currentObject];
        if (oldIndex != NSNotFound)
            [contextStack removeObjectAtIndex:oldIndex];
    }

    /* Insert the new object; if there was no previous object put before local symbols. */
    if (anObject != nil) {
        if (oldIndex == NSNotFound)
            oldIndex = [contextStack indexOfObject:mergeSymbols];
        if (oldIndex != NSNotFound)
            [contextStack insertObject:anObject atIndex:oldIndex];
    }

    [anObject retain];
    [currentObject release];
    currentObject = anObject;
}

/*"
 * Sets the current merge template.  All future invocations of -#{execute:}
 * will use %{aTemplate} as the merge template, until this method is called
 * again.
"*/
- (void)setTemplate:(MiscMergeTemplate *)aTemplate
{
    [aTemplate retain];
    [template release];
    template = aTemplate;
}

/*"
 * Performs a merge using the current data object and template.  If
 * successful, then an NSString containing the results of the merge is
 * returned.  If unsuccessful, nil is returned.  The argument %{sender}
 * should be the initiating driver.  If not, some commands, such as "next"
 * will not work properly.
"*/
- (NSString *)execute:sender
{
    driver = sender;

    aborted = NO;
    [outputString release];
    outputString = [[NSMutableString alloc] init];
    [contextStack removeAllObjects];
    [commandStack removeAllObjects];
    [mergeSymbols removeAllObjects];

    [contextStack addObject:[[self class] globalSymbolsDictionary]];
    [contextStack addObject:engineSymbols];
    if (currentObject) [contextStack addObject:currentObject];
    [contextStack addObject:mergeSymbols];

    [self executeCommandBlock:[template topLevelCommandBlock]];

    driver = nil;

    if (aborted) return @"";
    return outputString;
}

/*"
 * Initiates a merge with the current template and %{anObject}.  Returns an
 * NSString containing the output of the merge if successful and nil
 * otherwise.  The argument %{sender} should be the initiating driver.  If
 * not, some commands, such as "next" will not work properly.  This method
 * is just a convenience method that calls -#setMainObject: and then
 * -#execute:.
"*/
- (NSString *)executeWithObject:(id)anObject sender:sender
{
    [self setMainObject:anObject];
    return [self execute:sender];
}

/*"
 * Executes a single command.  MiscMergeCommand subclasses should always
 * call this method instead of calling -executeForMerge: on the command
 * itself if they need to execute a command.
"*/
- (MiscMergeCommandExitType)executeCommand:(MiscMergeCommand *)command
{
    /*
     * Just execute the command.  This is meant to be a hook where we can
     * insert other stuff to be done on each command execution, such as
     * logging for debug purposes.
     */
    return [command executeForMerge:self];
}

/*"
 * Executes all the commands in block.  MiscMergeCommand subclasses should
 * use this method when they need to execute a command block.  A local
 * autorelease pool is used during execution of the block.
"*/
- (MiscMergeCommandExitType)executeCommandBlock:(MiscMergeCommandBlock *)block
{
    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
    NSArray *commandArray = [block commandArray];
    NSInteger i, count = [commandArray count];
    MiscMergeCommandExitType exitCode = MiscMergeCommandExitNormal;
    /*
     * Maintain the execution stack.  This stack isn't being used at the
     * moment, but command implementations may in the future make use of it
     * (a break command, for example).
     */
    [commandStack addObject:block];

    for (i=0; (exitCode == MiscMergeCommandExitNormal) && (i<count); i++)
    {
        exitCode = [self executeCommand:[commandArray objectAtIndex:i]];
    }

    [commandStack removeLastObject];
    [localPool drain];
    return exitCode;
}

/*"
 * Attempts to resolve a field name, by going down the context stack until
 * an object containing that key is found, at which point the
 * -#valueForKeyPath: is returned, thus treating the fieldName as a key
 * path.  If recursive lookups are turned on, then a resolved value that is
 * an NSString objects is treated as a field name, and the lookup process
 * is started again.  This will be repeated until a value is not found or
 * the resolved value is not an NSString object, at which point the last
 * valid result will be returned. If the field name is not found at all,
 * then the field string itself is returned (unless keepDelimiters is set
 * to YES, in which case the field string surrounded by the original field
 * delimiters will be returned).
"*/
- (id)valueForField:(NSString *)fieldName quoted:(int)quoted
{
    NSInteger  i;
    id   value = nil;
    id   prevValue = nil;
    id   returnValue = nil;
    BOOL found = NO;
    BOOL prevFound = NO;
    int lookupCount = 0;

    if ( quoted == 1 )
        return fieldName;

    for (i=[contextStack count]; i > 0 && !found; i--)
    {
        id currContext = [contextStack objectAtIndex:i-1];

        if ([currContext hasMiscMergeKeyPath:fieldName])
        {
            value = [currContext valueForKeyPath:fieldName];
            found = YES;
        }

        /*
         * If recursive lookup is on, use the current value as a fieldName
         * and restart the search.  Store the last found value, so we know
         * which one to return.
         */
        if (found && useRecursiveLookups && (lookupCount < recursiveLookupLimit) && [value isKindOfClass:[NSString class]])
        {
            fieldName = value;
            prevValue = value;
            prevFound = YES;
            found = NO;
            i = [contextStack count];
            lookupCount++;
        }
        else if ( useRecursiveLookups && (lookupCount >= recursiveLookupLimit) )
            NSLog(@"Recursion limit %d reached for %@.", recursiveLookupLimit, fieldName);
    }

    if (value == [NSNull null]) value = nil;

    /* If we found it, return it. */
    if (found) returnValue = value;

    /* If the previous iteration of the recursive search found it, return it */
    else if (prevFound) returnValue = prevValue;

    if ( found || prevFound ) {
        if ( returnValue == nil ) {
            switch ( nilLookupResult ) {
                case MiscMergeNilLookupResultKeyIfQuoted:
                    if ( quoted == 2 )
                        returnValue = fieldName;
                    break;
                    
                case MiscMergeNilLookupResultKey:
                    returnValue = fieldName;
                    break;
                    
                case MiscMergeNilLookupResultKeyWithDelims:
                    returnValue = [NSString stringWithFormat:@"%@%@%@", [template startDelimiter], fieldName, [template endDelimiter]];
                    break;

                default:
                    break;
            }
        }

        return returnValue;
    }

    /* If not found, try our parent merge */
    if (parentMerge) return [parentMerge valueForField:fieldName quoted:quoted];

    switch ( failedLookupResult ) {            
        case MiscMergeFailedLookupResultKeyWithDelims:
            return [NSString stringWithFormat:@"%@%@%@", [template startDelimiter], fieldName, [template endDelimiter]];

        case MiscMergeFailedLookupResultNil:
            return nil;
            
        case MiscMergeFailedLookupResultKeyIfNumeric:
            return MMIsObjectANumber(fieldName) ? fieldName : nil;

        case MiscMergeFailedLookupResultKey:
        default:
            return fieldName;
    }
}

- (id)valueForField:(NSString *)fieldName
{
    return [self valueForField:fieldName quoted:0];
}

/*"
 * Appends %{aString} to the merge output.
"*/
- (void)appendToOutput:(NSString *)aString
{
    if ( aString != nil )
        [outputString appendString:[aString description]];
}

/*"
 * Aborts the current merge.  This means that the merge output will be nil,
 * as well.
"*/
- (void)abortMerge
{
    aborted = YES;
}

/*"
 * Attempts to advance to the next merge object while still working with
 * the current output string.  This might be used to allow two merges to
 * appear on the same "page" or document, for example. For it to work
 * properly, the driver that started the merge must respond to the
 * -#{advanceRecord} method.
"*/
- (void)advanceRecord
{
    if ([driver respondsToSelector:@selector(advanceRecord)])
        [driver advanceRecord];
}

@end
