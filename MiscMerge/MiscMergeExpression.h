//
//  MiscMergeExpression.h
//
//	Written by Doug McClure and Carl Lindberg
//
//	Copyright 2002-2004 by Don Yacktman and Doug McClure.
//	All rights reserved.
//
//      This notice may not be removed from this source code.
//
//	This header is included in the MiscKit by permission from the author
//	and its use is governed by the MiscKit license, found in the file
//	"License.rtf" in the MiscKit distribution.  Please refer to that file
//	for a list of all applicable permissions and restrictions.
//

#import <Foundation/Foundation.h>

@class MiscMergeEngine;

#define MiscMergeConditionalOperator 16
#define MiscMergeMathOperator 32

typedef enum _MiscMergeOperator {
    MiscMergeOperatorNone = 0,
    MiscMergeOperatorIn,
    MiscMergeOperatorNotIn, 

    MiscMergeOperatorEqual = MiscMergeConditionalOperator,
    MiscMergeOperatorNotEqual,
    MiscMergeOperatorLessThan,
    MiscMergeOperatorLessThanOrEqual,
    MiscMergeOperatorGreaterThan,
    MiscMergeOperatorGreaterThanOrEqual,

    MiscMergeOperatorAdd = MiscMergeMathOperator,
    MiscMergeOperatorSubtract,
    MiscMergeOperatorMultiply,
    MiscMergeOperatorDivide,
    MiscMergeOperatorModulus

} MiscMergeOperator;


@interface MiscMergeExpression : NSObject

- (id)evaluateWithEngine:(MiscMergeEngine *)anEngine;
- (BOOL)evaluateAsBoolWithEngine:(MiscMergeEngine *)anEngine;
- (int)evaluateAsIntWithEngine:(MiscMergeEngine *)anEngine;

@end


@interface MiscMergeValueExpression : MiscMergeExpression
{
    NSString *valueName;
    int quotes;
}

+ (MiscMergeValueExpression *)valueName:(NSString *)string quotes:(int)number;

@end


@interface MiscMergeUnaryOpExpression : MiscMergeExpression
{
    MiscMergeExpression *expression;
}

+ (MiscMergeUnaryOpExpression *)expression:(MiscMergeExpression *)expression;

@end

@interface MiscMergeNegativeExpression : MiscMergeUnaryOpExpression
@end

@interface MiscMergeNegateExpression : MiscMergeUnaryOpExpression
@end


@interface MiscMergeBinaryOpExpression : MiscMergeExpression
{
    MiscMergeExpression *leftExpression;
    MiscMergeExpression *rightExpression;
    MiscMergeOperator operator; 
}

+ (MiscMergeBinaryOpExpression *)leftExpression:(MiscMergeExpression *)lExpression
                                       operator:(MiscMergeOperator)operator
                                rightExpression:(MiscMergeExpression *)rExpression;

@end

@interface MiscMergeMathExpression : MiscMergeBinaryOpExpression
@end

@interface MiscMergeConditionalExpression : MiscMergeBinaryOpExpression
@end

@interface MiscMergeContainsExpression : MiscMergeBinaryOpExpression
@end


@interface MiscMergeGroupExpression : MiscMergeExpression
{
    NSMutableArray *expressions;
}

+ (MiscMergeGroupExpression *)expression:(MiscMergeExpression *)lExpression
                           andExpression:(MiscMergeExpression *)rExpression;
+ (MiscMergeGroupExpression *)expressions:(NSArray *)list;

- (void)addExpression:(MiscMergeExpression *)expression;

@end

@interface MiscMergeAndExpression : MiscMergeGroupExpression
@end

@interface MiscMergeOrExpression : MiscMergeGroupExpression
@end

@interface MiscMergeListExpression : MiscMergeGroupExpression

- (NSArray *)evaluateAsListWithEngine:(MiscMergeEngine *)anEngine;

@end
