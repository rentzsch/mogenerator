//
//  NSAttributeDescription+momc.m
//  momc
//
//  Created by Tom Harrington on 4/18/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

#import "NSAttributeDescription+momcom.h"
#import "NSPropertyDescription+momcom.h"

static NSDictionary *attributeTypeForString;
const NSString *const kUsesScalarAttributeType = @"mogenerator.usesScalarAttributeType";
const NSString *const kAttributeValueClassName = @"attributeValueClassName";

@implementation NSAttributeDescription (momcom)

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        attributeTypeForString = @{
                              @"Integer 16"     : @(NSInteger16AttributeType),
                              @"Integer 32"     : @(NSInteger32AttributeType),
                              @"Integer 64"     : @(NSInteger64AttributeType),
                              @"Binary"         : @(NSBinaryDataAttributeType),
                              @"Boolean"        : @(NSBooleanAttributeType),
                              @"Date"           : @(NSDateAttributeType),
                              @"Decimal"        : @(NSDecimalAttributeType),
                              @"Double"         : @(NSDoubleAttributeType),
                              @"Float"          : @(NSFloatAttributeType),
                              @"String"         : @(NSStringAttributeType),
                              @"Transformable"  : @(NSTransformableAttributeType),
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
                              @"URI"            : @(NSURIAttributeType),
                              @"UUID"           : @(NSUUIDAttributeType),
#pragma clang diagnostic pop
                              };
    });
}

+ (NSAttributeDescription *)baseEntityForXML:(NSXMLElement *)xmlNode
{
    NSAttributeDescription *attributeDescription = [super baseEntityForXML:xmlNode];
    
    NSXMLNode *attributeElement = [xmlNode attributeForName:@"attributeType"];
    if (attributeElement != nil) {
        NSNumber *attributeType = [attributeTypeForString objectForKey:[attributeElement stringValue]];
        if (attributeType != nil) {
            [attributeDescription setAttributeType:[attributeType integerValue]];
        }
    }
    
    NSXMLNode *customClassNameElement = [xmlNode attributeForName:@"customClassName"];
    if (customClassNameElement != nil) {
        NSMutableDictionary *userInfo = [[attributeDescription userInfo] mutableCopy];
        userInfo[kAttributeValueClassName] = [customClassNameElement stringValue];
        [attributeDescription setUserInfo:userInfo.copy];
    }

    NSXMLNode *userScalarElement = [xmlNode attributeForName:@"usesScalarValueType"];
    if (userScalarElement != nil) {
        NSMutableDictionary *userInfo = [[attributeDescription userInfo] mutableCopy];
        userInfo[kUsesScalarAttributeType] = [userScalarElement stringValue];
        [attributeDescription setUserInfo:userInfo.copy];
    }

    NSXMLNode *defaultValueElement = [xmlNode attributeForName:@"defaultValueString"];
    if (defaultValueElement != nil) {
        NSString *defaultValueString = [defaultValueElement stringValue];
        switch ([attributeDescription attributeType]) {
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType:
            {
                NSInteger defaultValue = [defaultValueString integerValue];
                [attributeDescription setDefaultValue:@(defaultValue)];
                break;
            }
            case NSBooleanAttributeType:
            {
                BOOL defaultValue = [defaultValueString boolValue];
                [attributeDescription setDefaultValue:@(defaultValue)];
                break;
            }
            case NSDecimalAttributeType:
            {
                NSDecimalNumber *defaultValue = [NSDecimalNumber decimalNumberWithString:defaultValueString];
                [attributeDescription setDefaultValue:defaultValue];
                break;
            }
            case NSFloatAttributeType:
            {
                float defaultValue = [defaultValueString floatValue];
                [attributeDescription setDefaultValue:@(defaultValue)];
                break;
            }
            case NSDoubleAttributeType:
            {
                double defaultValue = [defaultValueString doubleValue];
                [attributeDescription setDefaultValue:@(defaultValue)];
                break;
            }
            case NSDateAttributeType:
            {
                // defaultValueElement is an NSString representation of the date, but the defaultDateTimeInterval
                // provides the same information in a more convenient form.
                NSXMLNode *defaultDateTimeIntervalAttribute = [xmlNode attributeForName:@"defaultDateTimeInterval"];
                NSTimeInterval defaultDateTimeInterval = [[defaultDateTimeIntervalAttribute stringValue] doubleValue];
                NSDate *defaultValue = [NSDate dateWithTimeIntervalSinceReferenceDate:defaultDateTimeInterval];
                [attributeDescription setDefaultValue:defaultValue];

                break;
            }
                
            default:
                break;
        }
    }
    
    // Min/max values, validation predicates
    NSXMLNode *minValueElement = [xmlNode attributeForName:@"minValueString"];
    NSXMLNode *maxValueElement = [xmlNode attributeForName:@"maxValueString"];
    if ((minValueElement != nil) || (maxValueElement != nil)) {
        NSMutableArray *validationPredicates = [NSMutableArray array];
        NSMutableArray *validationWarnings = [NSMutableArray array];
        NSString *minValueString = [minValueElement stringValue];
        NSString *maxValueString = [maxValueElement stringValue];
        NSNumber *minValue = nil;
        NSNumber *maxValue = nil;
        switch ([attributeDescription attributeType]) {
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType:
            {
                if (minValueElement != nil) {
                    minValue = [NSNumber numberWithInteger:[minValueString integerValue]];
                }
                if (maxValueElement != nil) {
                    maxValue = [NSNumber numberWithInteger:[maxValueString integerValue]];
                }
                break;
            }
            case NSDecimalAttributeType:
            case NSDoubleAttributeType:
            case NSFloatAttributeType:
            {
                if (minValueElement != nil) {
                    minValue = [NSNumber numberWithDouble:[minValueString doubleValue]];
                }
                if (maxValueElement != nil) {
                    maxValue = [NSNumber numberWithDouble:[maxValueString doubleValue]];
                }
                break;
            }
            case NSDateAttributeType:
            {
                // minValueString and maxValueString contain string representations of dates,
                // but fortunately minDateTimeInterval and maxDateTimeInterval provide the
                // same information in a more convenient form.
                NSXMLNode *minDateTimeIntervalElement = [xmlNode attributeForName:@"minDateTimeInterval"];
                if (minDateTimeIntervalElement != nil) {
                    NSTimeInterval minDateTimeInterval = [[minDateTimeIntervalElement stringValue] doubleValue];
                    NSExpression *minDateKeyExpression = [NSExpression expressionForKeyPath:@"timeIntervalSinceReferenceDate"];
                    NSExpression *minValueExpression = [NSExpression expressionForConstantValue:@(minDateTimeInterval)];
                    NSPredicate *minDateTimePredicate = [NSComparisonPredicate predicateWithLeftExpression:minDateKeyExpression
                                                                                           rightExpression:minValueExpression
                                                                                                  modifier:0
                                                                                                      type:NSGreaterThanOrEqualToPredicateOperatorType
                                                                                                   options:0];
                    [validationPredicates addObject:minDateTimePredicate];
                    [validationWarnings addObject:@(NSValidationDateTooSoonError)];
                }
                NSXMLNode *maxDateTimeIntervalElement = [xmlNode attributeForName:@"maxDateTimeInterval"];
                if (maxDateTimeIntervalElement != nil) {
                    NSTimeInterval maxDateTimeInterval = [[maxDateTimeIntervalElement stringValue] doubleValue];
                    NSExpression *maxDateKeyExpression = [NSExpression expressionForKeyPath:@"timeIntervalSinceReferenceDate"];
                    NSExpression *maxValueExpression = [NSExpression expressionForConstantValue:@(maxDateTimeInterval)];
                    NSPredicate *maxDateTimePredicate = [NSComparisonPredicate predicateWithLeftExpression:maxDateKeyExpression
                                                                                           rightExpression:maxValueExpression
                                                                                                  modifier:0
                                                                                                      type:NSLessThanOrEqualToPredicateOperatorType
                                                                                                   options:0];
                    [validationPredicates addObject:maxDateTimePredicate];
                    [validationWarnings addObject:@(NSValidationDateTooLateError)];
                }
                break;
            }
                
            
            default:
                break;
        }
        NSExpression *selfExpression = [NSExpression expressionForEvaluatedObject];
        if (minValue != nil) {
            NSExpression *minValueExpression = [NSExpression expressionForConstantValue:minValue];
            NSPredicate *minValuePredicate = [NSComparisonPredicate predicateWithLeftExpression:selfExpression
                                                                                rightExpression:minValueExpression
                                                                                       modifier:0
                                                                                           type:NSGreaterThanOrEqualToPredicateOperatorType
                                                                                        options:0];
            [validationPredicates addObject:minValuePredicate];
            [validationWarnings addObject:@(NSValidationNumberTooSmallError)];
        }
        if (maxValue != nil) {
            NSExpression *maxValueExpression = [NSExpression expressionForConstantValue:maxValue];
            NSPredicate *maxValuePredicate = [NSComparisonPredicate predicateWithLeftExpression:selfExpression
                                                                                rightExpression:maxValueExpression
                                                                                       modifier:0
                                                                                           type:NSLessThanOrEqualToPredicateOperatorType
                                                                                        options:0];
            [validationPredicates addObject:maxValuePredicate];
            [validationWarnings addObject:@(NSValidationNumberTooLargeError)];
        }
        [attributeDescription setValidationPredicates:validationPredicates withValidationWarnings:validationWarnings];
    }
    
    NSXMLNode *valueTransformerNameElement = [xmlNode attributeForName:@"valueTransformerName"];
    if (valueTransformerNameElement != nil) {
        [attributeDescription setValueTransformerName:[valueTransformerNameElement stringValue]];
    }
    NSXMLNode *allowsExternalBinaryDataStorageElement = [xmlNode attributeForName:@"allowsExternalBinaryDataStorage"];
    if (allowsExternalBinaryDataStorageElement != nil) {
        [attributeDescription setAllowsExternalBinaryDataStorage:[[allowsExternalBinaryDataStorageElement stringValue] boolValue]];
    }
    NSXMLNode *spotlightIndexingEnabledElement = [xmlNode attributeForName:@"spotlightIndexingEnabled"];
    if (spotlightIndexingEnabledElement != nil) {
        [attributeDescription setIndexedBySpotlight:[[spotlightIndexingEnabledElement stringValue] boolValue]];
    }
    NSXMLNode *storedInTruthFileElement = [xmlNode attributeForName:@"storedInTruthFile"];
    if (storedInTruthFileElement != nil) {
        [attributeDescription setStoredInExternalRecord:[[storedInTruthFileElement stringValue] boolValue]];
    }
    
    return attributeDescription;
}

@end
