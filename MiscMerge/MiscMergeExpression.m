 //
//  MiscMergeEngine.m
//
//	Written by Doug McClure and Carl Lindberg
//
//	Copyright 2002-2004 by Don Yacktman, Doug McClure, and Carl Lindberg.
//	All rights reserved.
//
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//

#import "MiscMergeExpression.h"
#import "MiscMergeFunctions.h"
#import "MiscMergeEngine.h"
#import "NSString+MiscAdditions.h"

static NSNumber *TRUE_VALUE;
static NSNumber *FALSE_VALUE;

@implementation MiscMergeExpression

+ (void)initialize
{
    if ( TRUE_VALUE == nil ) {
        TRUE_VALUE = [[NSNumber numberWithBool:YES] retain];
        FALSE_VALUE = [[NSNumber numberWithBool:NO] retain];
    }
}

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine
{
    return nil;
}

- (BOOL)evaluateAsBoolWithEngine:(MiscMergeEngine *)anEngine
{
    return MMBoolValueOfObject([self evaluateWithEngine:anEngine]);
}

- (int)evaluateAsIntWithEngine:(MiscMergeEngine *)anEngine
{
    return MMIntegerValueOfObject([self evaluateWithEngine:anEngine]);
}

@end


@implementation MiscMergeValueExpression

- (id)initWithValueName:(NSString *)string quotes:(int)number
{
    self = [super init];
    if ( self ) {
        valueName = [string copy];
        quotes = number;
    }
    return self;
}

- (void)dealloc
{
    [valueName release];
    [super dealloc];
}

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine
{
    return [anEngine valueForField:valueName quoted:quotes];
}

- (NSString *)description
{
    if ( quotes > 0 )
        return [NSString stringWithFormat:@"MEValue(value='%@',quotes=%d)", valueName, quotes];
    else
        return [NSString stringWithFormat:@"MEValue(value='%@')", valueName];
}

+ (MiscMergeValueExpression *)valueName:(NSString *)string quotes:(int)number
{
    return [[[self alloc] initWithValueName:string quotes:number] autorelease];
}

@end


@implementation MiscMergeUnaryOpExpression

- (id)initWithExpression:(MiscMergeExpression *)anExpression
{
    self = [super init];
    if ( self ) {
        expression = [anExpression retain];
    }
    return self;
}

- (void)dealloc
{
    [expression release];
    [super dealloc];
}

- (NSString *)nameDescription
{
    return @"MEUnary";
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@(exp=%@)", [self nameDescription], expression];
}

+ (MiscMergeUnaryOpExpression *)expression:(MiscMergeExpression *)anExpression
{
    return [[[self alloc] initWithExpression:anExpression] autorelease];
}

@end

@implementation MiscMergeNegativeExpression

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine
{
    return [NSNumber numberWithDouble:-MMDoubleValueForObject([expression evaluateWithEngine:anEngine])];
}

- (NSString *)nameDescription
{
    return @"MENegative";
}

@end

@implementation MiscMergeNegateExpression

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine
{
    return [NSNumber numberWithBool:!MMDoubleValueForObject([expression evaluateWithEngine:anEngine])];
}

- (NSString *)nameDescription
{
    return @"MENegate";
}

@end


@implementation MiscMergeBinaryOpExpression

- (id)initWithLeftExpression:(MiscMergeExpression *)lExpression
                    operator:(MiscMergeOperator)anOperator
             rightExpression:(MiscMergeExpression *)rExpression
{
    self = [super init];
    if ( self ) {
        leftExpression = [lExpression retain];
        rightExpression = [rExpression retain];
        operator = anOperator;
    }
    return self;
}

- (void)dealloc
{
    [leftExpression release];
    [rightExpression release];
    [super dealloc];
}

- (NSString *)nameDescription
{
    return @"MEBinary";
}
- (NSString *)operatorDescription
{
    return [NSString stringWithFormat:@"%d", operator];
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@(lexp=%@,op='%@',rexp=%@)", [self nameDescription],
        leftExpression, [self operatorDescription], rightExpression];
}

+ (MiscMergeBinaryOpExpression *)leftExpression:(MiscMergeExpression *)lExpression
                                       operator:(MiscMergeOperator)anOperator
                                rightExpression:(MiscMergeExpression *)rExpression
{
    return [[[self alloc] initWithLeftExpression:lExpression operator:anOperator rightExpression:rExpression] autorelease];
}

@end

@implementation MiscMergeMathExpression

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine
{
    double lValue = MMDoubleValueForObject([leftExpression evaluateWithEngine:anEngine]);
    double rValue = MMDoubleValueForObject([rightExpression evaluateWithEngine:anEngine]);

    switch ( operator ) {
        case MiscMergeOperatorAdd:
            return [NSNumber numberWithDouble:(lValue + rValue)];
        case MiscMergeOperatorSubtract:
            return [NSNumber numberWithDouble:(lValue - rValue)];
        case MiscMergeOperatorMultiply:
            return [NSNumber numberWithDouble:(lValue * rValue)];
        case MiscMergeOperatorDivide:
            return [NSNumber numberWithDouble:(lValue / rValue)];
        case MiscMergeOperatorModulus:
            return [NSNumber numberWithInt:((int)lValue % (int)rValue)];
        default:
            return [NSNumber numberWithInt:0];
    }
}

- (NSString *)nameDescription
{
    return @"MEMath";
}

- (NSString *)operatorDescription
{
    switch ( operator ) {
        case MiscMergeOperatorAdd:      return @"+";
        case MiscMergeOperatorSubtract: return @"-";
        case MiscMergeOperatorMultiply: return @"*";
        case MiscMergeOperatorDivide:   return @"/";
        case MiscMergeOperatorModulus:  return @"%";
        default:                        return @"";
    }
}

@end

@implementation MiscMergeConditionalExpression

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine
{
    id leftOperand = [leftExpression evaluateWithEngine:anEngine];
    id rightOperand = [rightExpression evaluateWithEngine:anEngine];
    NSComparisonResult comparison;
    int returnValue;

    if (leftOperand == nil && rightOperand == nil) {
        comparison = NSOrderedSame;
    }
    else if (leftOperand == nil && rightOperand != nil) {
        comparison = NSOrderedAscending;
    }
    else if (leftOperand != nil && rightOperand == nil) {
        comparison = NSOrderedDescending;
    }
    else if (MMIsObjectANumber(leftOperand) && MMIsObjectANumber(rightOperand)) {
        comparison = MMCompareFloats([leftOperand floatValue], [rightOperand floatValue]);
    }
    else if ([leftOperand isEqual:rightOperand]) {
        comparison = NSOrderedSame;
    }
    /* Short-circuit for "==" and "!=", since -isEqual: should have done the necessary check. */
    else if (operator == MiscMergeOperatorEqual) {
        return FALSE_VALUE;
    }
    else if (operator == MiscMergeOperatorNotEqual) {
        return TRUE_VALUE;
    }
    else if ([MMCommonAnscestorClass(leftOperand, rightOperand) instancesRespondToSelector:@selector(compare:)]) {
        comparison = [(NSString*)leftOperand compare:rightOperand];
    }
    else { //??
        comparison = [[leftOperand description] compare:[rightOperand description]];
    }

    /*
     * now that we have comparison results, turn them into a YES/NO
     * depending upon the chosen operator.
     */
    switch ( operator ) {
        case MiscMergeOperatorEqual:
            returnValue = (comparison == NSOrderedSame);
            break;
            
        case MiscMergeOperatorNotEqual:
            returnValue = (comparison != NSOrderedSame);
            break;
            
        case MiscMergeOperatorLessThanOrEqual:
            returnValue = (comparison != NSOrderedDescending);
            break;
            
        case MiscMergeOperatorGreaterThanOrEqual:
            returnValue = (comparison != NSOrderedAscending);
            break;
            
        case MiscMergeOperatorLessThan:
            returnValue = (comparison == NSOrderedAscending);
            break;
            
        case MiscMergeOperatorGreaterThan:
            returnValue = (comparison == NSOrderedDescending);
            break;
            
        default:
            returnValue = NO; // handled above
    }

    return (returnValue) ? TRUE_VALUE : FALSE_VALUE;
}

- (NSString *)nameDescription
{
    return @"MEConditional";
}

- (NSString *)operatorDescription
{
    NSString *operatorDescription;
    
    switch ( operator ) {
        case MiscMergeOperatorEqual:              return @"==";
        case MiscMergeOperatorNotEqual:           return @"!=";
        case MiscMergeOperatorLessThanOrEqual:    return @"<=";
        case MiscMergeOperatorGreaterThanOrEqual: return @">=";
        case MiscMergeOperatorLessThan:           return @"<";
        case MiscMergeOperatorGreaterThan:        return @">";
        default:                                  return @"";
    }

    return operatorDescription;
}

@end

@implementation MiscMergeContainsExpression

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine
{
    id leftOperand = [leftExpression evaluateWithEngine:anEngine];
    id rightOperand;
    BOOL returnValue = NO;

    if ( [rightExpression isKindOfClass:[MiscMergeListExpression class]] )
        rightOperand = [(MiscMergeListExpression *)rightExpression evaluateAsListWithEngine:anEngine];
    else
        rightOperand = [rightExpression evaluateWithEngine:anEngine];

    if ( [rightOperand isKindOfClass:[NSArray class]] ) {
        NSEnumerator *enumerator = [rightOperand objectEnumerator];
        id object;

        while ( !returnValue && (object = [enumerator nextObject]) ) {
            if (leftOperand == nil && object == nil) {
                returnValue = YES;
            }
            else if (leftOperand == nil && object != nil) {
                returnValue = NO;
            }
            else if (leftOperand != nil && object == nil) {
                returnValue = NO;
            }
            else if (MMIsObjectANumber(leftOperand) && MMIsObjectANumber(object)) {
                returnValue = (NSOrderedSame == MMCompareFloats([leftOperand floatValue], [object floatValue]));
            }
            else {
                returnValue = [leftOperand isEqual:object];
            }
        }
    }

    if ( operator == MiscMergeOperatorNotIn )
        returnValue = !returnValue;

    return returnValue ? TRUE_VALUE : FALSE_VALUE;
}

- (NSString *)nameDescription
{
    return @"MEContains";
}

- (NSString *)operatorDescription
{
    NSString *operatorDescription;

    switch ( operator ) {
        case MiscMergeOperatorIn:    return @"==";
        case MiscMergeOperatorNotIn: return @"!=";
        default:                     return @"";
    }

    return operatorDescription;
}

@end



@implementation MiscMergeGroupExpression

- (id)initWithExpression:(MiscMergeExpression *)lExpression
           andExpression:(MiscMergeExpression *)rExpression
{
    self = [super init];
    if ( self ) {
        expressions = [[NSMutableArray alloc] init];
        [expressions addObject:lExpression];
        [expressions addObject:rExpression];
    }
    return self;
}

- (id)initWithExpressions:(NSArray *)list
{
    self = [super init];
    if ( self ) {
        expressions = [list mutableCopy];
    }
    return self;
}

- (void)dealloc
{
    [expressions release];
    [super dealloc];
}

- (void)addExpression:(MiscMergeExpression *)expression
{
    [expressions addObject:expression];
}

- (NSString *)nameDescription
{
    return @"MEGroup";
}

- (NSString *)description
{
    NSInteger index, count = [expressions count];
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@(", [self nameDescription]];
    
    for ( index = 0; index < count; index++ ) {
        if ( index > 0 )
            [string appendString:@","];

        [string appendFormat:@"%d=%@", index, [expressions objectAtIndex:index]];
    }

    [string appendString:@")"];
    return string;
}

+ (MiscMergeGroupExpression *)expression:(MiscMergeExpression *)lExpression
                           andExpression:(MiscMergeExpression *)rExpression
{
    return [[[self alloc] initWithExpression:lExpression andExpression:rExpression] autorelease];
}

+ (MiscMergeGroupExpression *)expressions:(NSArray *)list
{
    return [[[self alloc] initWithExpressions:list] autorelease];
}

@end

@implementation MiscMergeAndExpression

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine
{
    NSEnumerator *enumerator = [expressions objectEnumerator];
    MiscMergeExpression *expression;
    BOOL returnValue = YES;

    while ( returnValue && (expression = (MiscMergeExpression *)[enumerator nextObject]) ) {
        returnValue = MMDoubleValueForObject([expression evaluateWithEngine:anEngine]);
    }

    return (returnValue) ? TRUE_VALUE : FALSE_VALUE;
}

- (NSString *)nameDescription
{
    return @"MEAnd";
}

@end

@implementation MiscMergeOrExpression

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine
{
    NSEnumerator *enumerator = [expressions objectEnumerator];
    MiscMergeExpression *expression;
    BOOL returnValue = NO;

    while ( !returnValue && (expression = (MiscMergeExpression *)[enumerator nextObject]) ) {
        returnValue = MMDoubleValueForObject([expression evaluateWithEngine:anEngine]);
    }

    return (returnValue) ? TRUE_VALUE : FALSE_VALUE;
}

- (NSString *)nameDescription
{
    return @"MEOr";
}

@end

@implementation MiscMergeListExpression

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine
{
    return [[expressions lastObject] evaluateWithEngine:anEngine];
}

- (NSArray *)evaluateAsListWithEngine:(MiscMergeEngine *)anEngine
{
    NSMutableArray *array = [NSMutableArray array];
    NSEnumerator *enumerator = [expressions objectEnumerator];
    MiscMergeExpression *expression;
    
    while (( expression = (MiscMergeExpression *)[enumerator nextObject] )) {
        [array addObject:[expression evaluateWithEngine:anEngine]];
    }

    return array;
}

- (NSString *)nameDescription
{
    return @"MEList";
}

@end
