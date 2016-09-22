// JREnum.h semver:1.1
//   Original implementation by Benedict Cohen: http://benedictcohen.co.uk
//   Copyright (c) 2012-2014 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/mit
//   https://github.com/rentzsch/JREnum

#define JREnum(ENUM_TYPENAME, ENUM_CONSTANTS...)    \
    typedef enum {  \
        ENUM_CONSTANTS  \
    } ENUM_TYPENAME;    \
    static NSString *_##ENUM_TYPENAME##_constants_string = @"" #ENUM_CONSTANTS; \
    _JREnum_GenerateImplementation(ENUM_TYPENAME)

//--

#define JREnumDeclare(ENUM_TYPENAME, ENUM_CONSTANTS...) \
    typedef enum {  \
        ENUM_CONSTANTS  \
    } ENUM_TYPENAME;    \
    extern NSDictionary* ENUM_TYPENAME##ByValue();  \
    extern NSDictionary* ENUM_TYPENAME##ByLabel();  \
    extern NSString* ENUM_TYPENAME##ToString(int enumValue);    \
    extern BOOL ENUM_TYPENAME##FromString(NSString *enumLabel, ENUM_TYPENAME *enumValue);   \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wunused-variable\"") \
    static NSString *_##ENUM_TYPENAME##_constants_string = @"" #ENUM_CONSTANTS; \
    _Pragma("clang diagnostic pop")

//--

#define JREnumDefine(ENUM_TYPENAME) \
    _JREnum_GenerateImplementation(ENUM_TYPENAME)

//--

#define _JREnum_GenerateImplementation(ENUM_TYPENAME)  \
    NSArray* _JREnumParse##ENUM_TYPENAME##ConstantsString() {	\
        NSString *constantsString = _##ENUM_TYPENAME##_constants_string; \
        constantsString = [[constantsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""]; \
        if ([constantsString hasSuffix:@","]) { \
            constantsString = [constantsString substringToIndex:[constantsString length]-1]; \
        } \
        NSArray *stringPairs = [constantsString componentsSeparatedByString:@","];	\
        NSMutableArray *labelsAndValues = [NSMutableArray arrayWithCapacity:[stringPairs count]];	\
        int nextDefaultValue = 0;	\
        for (NSString *stringPair in stringPairs) {	\
            NSArray *labelAndValueString = [stringPair componentsSeparatedByString:@"="];	\
            NSString *label = [labelAndValueString objectAtIndex:0];	\
            NSString *valueString = [labelAndValueString count] > 1 ? [labelAndValueString objectAtIndex:1] : nil;	\
            int value; \
            if (valueString) { \
                NSRange shiftTokenRange = [valueString rangeOfString:@"<<"]; \
                if (shiftTokenRange.location != NSNotFound) { \
                    valueString = [valueString substringFromIndex:shiftTokenRange.location + 2]; \
                    value = 1 << [valueString intValue]; \
                } else if ([valueString hasPrefix:@"0x"]) { \
                    [[NSScanner scannerWithString:valueString] scanHexInt:(unsigned int*)&value]; \
                } else { \
                    value = [valueString intValue]; \
                } \
            } else { \
                value = nextDefaultValue; \
            } \
            nextDefaultValue = value + 1;	\
            [labelsAndValues addObject:label];	\
            [labelsAndValues addObject:[NSNumber numberWithInt:value]];	\
        }	\
        return labelsAndValues;	\
    }	\
        \
    NSDictionary* ENUM_TYPENAME##ByValue() {	\
        NSArray *constants = _JREnumParse##ENUM_TYPENAME##ConstantsString();	\
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[constants count] / 2];	\
        for (NSUInteger i = 0; i < [constants count]; i += 2) {	\
            NSString *label = [constants objectAtIndex:i];	\
            NSNumber *value = [constants objectAtIndex:i+1];	\
            [result setObject:label forKey:value];	\
        }	\
        return result;	\
    }	\
        \
    NSDictionary* ENUM_TYPENAME##ByLabel() {	\
        NSArray *constants = _JREnumParse##ENUM_TYPENAME##ConstantsString();	\
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[constants count] / 2];	\
        for (NSUInteger i = 0; i < [constants count]; i += 2) {	\
            NSString *label = [constants objectAtIndex:i];	\
            NSNumber *value = [constants objectAtIndex:i+1];	\
            [result setObject:value forKey:label];	\
        }	\
        return result;	\
    }	\
        \
    NSString* ENUM_TYPENAME##ToString(int enumValue) {	\
        NSString *result = [ENUM_TYPENAME##ByValue() objectForKey:[NSNumber numberWithInt:enumValue]];	\
        if (!result) {	\
            result = [NSString stringWithFormat:@"<unknown "#ENUM_TYPENAME": %d>", enumValue];	\
        }	\
        return result;	\
    }	\
        \
    BOOL ENUM_TYPENAME##FromString(NSString *enumLabel, ENUM_TYPENAME *enumValue) {	\
        NSNumber *value = [ENUM_TYPENAME##ByLabel() objectForKey:enumLabel];	\
        if (value) {	\
            *enumValue = (ENUM_TYPENAME)[value intValue];	\
            return YES;	\
        } else {	\
            return NO;	\
        }	\
    }