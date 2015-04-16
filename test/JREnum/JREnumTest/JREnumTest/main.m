#import <Foundation/Foundation.h>
#import "SplitEnums.h"

JREnum(EnumWith1ConstantSansExplicitValues,
       EnumWith1ConstantSansExplicitValues_Constant1);

JREnum(EnumWith1ConstantSansExplicitValuesTrailingComma,
       EnumWith1ConstantSansExplicitValuesTrailingComma_Constant1 , 
       );

JREnum(EnumWith1ConstantWithExplicitValues,
       EnumWith1ConstantWithExplicitValues_Constant1 = 42);

JREnum(EnumWith3BitshiftConstants,
       EnumWith2BitshiftConstants_1           = 1 << 0,
       EnumWith2BitshiftConstants_2           = 1 << 1,
       EnumWith2BitshiftConstants_4           = 1 << 2,
       EnumWith2BitshiftConstants_1073741824  = 1 << 30,
       );

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        {{
            assert([EnumWith1ConstantSansExplicitValuesByLabel() count] == 1);
            assert([[EnumWith1ConstantSansExplicitValuesByLabel() objectForKey:@"EnumWith1ConstantSansExplicitValues_Constant1"] isEqual:[NSNumber numberWithInt:0]]);
            
            assert([EnumWith1ConstantSansExplicitValuesByValue() count] == 1);
            assert([[EnumWith1ConstantSansExplicitValuesByValue() objectForKey:[NSNumber numberWithInt:0]] isEqual:@"EnumWith1ConstantSansExplicitValues_Constant1"]);
            
            EnumWith1ConstantSansExplicitValues a = 0;
            
            assert(EnumWith1ConstantSansExplicitValues_Constant1 == a);
            assert([@"EnumWith1ConstantSansExplicitValues_Constant1" isEqualToString:EnumWith1ConstantSansExplicitValuesToString(a)]);
            assert(EnumWith1ConstantSansExplicitValuesFromString(EnumWith1ConstantSansExplicitValuesToString(EnumWith1ConstantSansExplicitValues_Constant1), &a));
            assert(EnumWith1ConstantSansExplicitValues_Constant1 == a);
            
            a++;
            assert([@"<unknown EnumWith1ConstantSansExplicitValues: 1>" isEqualToString:EnumWith1ConstantSansExplicitValuesToString(a)]);
            assert(!EnumWith1ConstantSansExplicitValuesFromString(@"foo", &a));
        }}
        {{
            assert([EnumWith1ConstantSansExplicitValuesTrailingCommaByLabel() count] == 1);
        }}
        {{
            SplitEnumWith1ConstantSansExplicitValues a = 0;
            
            assert(SplitEnumWith1ConstantSansExplicitValues_Constant1 == a);
            assert([@"SplitEnumWith1ConstantSansExplicitValues_Constant1" isEqualToString:SplitEnumWith1ConstantSansExplicitValuesToString(a)]);
            assert(SplitEnumWith1ConstantSansExplicitValuesFromString(SplitEnumWith1ConstantSansExplicitValuesToString(SplitEnumWith1ConstantSansExplicitValues_Constant1), &a));
            assert(SplitEnumWith1ConstantSansExplicitValues_Constant1 == a);
            
            a++;
            assert([@"<unknown SplitEnumWith1ConstantSansExplicitValues: 1>" isEqualToString:SplitEnumWith1ConstantSansExplicitValuesToString(a)]);
            assert(!SplitEnumWith1ConstantSansExplicitValuesFromString(@"foo", &a));
            
            assert([SplitEnumWith1ConstantSansExplicitValuesByLabel() count] == 1);
        }}
        {{
            assert([SplitEnumWith2ConstantsSansExplicitValuesByLabel() count] == 2);
        }}
        {{
            SplitEnumWith1ConstantWithExplicitValues a = 42;
            
            assert(SplitEnumWith1ConstantWithExplicitValues_Constant1 == a);
            assert([@"SplitEnumWith1ConstantWithExplicitValues_Constant1" isEqualToString:SplitEnumWith1ConstantWithExplicitValuesToString(a)]);
            assert(SplitEnumWith1ConstantWithExplicitValuesFromString(SplitEnumWith1ConstantWithExplicitValuesToString(SplitEnumWith1ConstantWithExplicitValues_Constant1), &a));
            assert(SplitEnumWith1ConstantWithExplicitValues_Constant1 == a);
            
            a++;
            assert([@"<unknown SplitEnumWith1ConstantWithExplicitValues: 43>" isEqualToString:SplitEnumWith1ConstantWithExplicitValuesToString(a)]);
            assert(!SplitEnumWith1ConstantWithExplicitValuesFromString(@"foo", &a));
        }}
        {{
            assert([EnumWith3BitshiftConstantsByLabel() count] == 4);
            
            assert(1 == EnumWith2BitshiftConstants_1);
            assert([@"EnumWith2BitshiftConstants_1" isEqualToString:EnumWith3BitshiftConstantsToString(EnumWith2BitshiftConstants_1)]);
            
            assert(2 == EnumWith2BitshiftConstants_2);
            assert([@"EnumWith2BitshiftConstants_2" isEqualToString:EnumWith3BitshiftConstantsToString(EnumWith2BitshiftConstants_2)]);
            
            assert(4 == EnumWith2BitshiftConstants_4);
            assert([@"EnumWith2BitshiftConstants_4" isEqualToString:EnumWith3BitshiftConstantsToString(EnumWith2BitshiftConstants_4)]);
            
            assert(1073741824 == EnumWith2BitshiftConstants_1073741824);
            assert([@"EnumWith2BitshiftConstants_1073741824" isEqualToString:EnumWith3BitshiftConstantsToString(EnumWith2BitshiftConstants_1073741824)]);
            
            assert([@"<unknown EnumWith3BitshiftConstants: 3>" isEqualToString:EnumWith3BitshiftConstantsToString(3)]);
            
            EnumWith3BitshiftConstants value;
            assert(EnumWith3BitshiftConstantsFromString(@"EnumWith2BitshiftConstants_1", &value));
            assert(value == EnumWith2BitshiftConstants_1);
            
            assert(!EnumWith3BitshiftConstantsFromString(@"bogus", &value));
        }}
        {{
            assert([@"AlignLeft" isEqualToString:AlignToString(1 << 0)]);
            assert([@"AlignRight" isEqualToString:AlignToString(1 << 1)]);
            assert([@"AlignTop" isEqualToString:AlignToString(1 << 2)]);
            assert([@"AlignBottom" isEqualToString:AlignToString(1 << 3)]);
            
            assert([@"AlignTopLeft" isEqualToString:AlignToString(AlignTop | AlignLeft)]);
            assert([@"AlignBottomLeft" isEqualToString:AlignToString(AlignBottom | AlignLeft)]);
            assert([@"AlignTopRight" isEqualToString:AlignToString(AlignTop | AlignRight)]);
            assert([@"AlignBottomRight" isEqualToString:AlignToString(AlignBottom | AlignRight)]);
            
            Align a;
            assert(AlignFromString(AlignToString(AlignLeft), &a));
            assert(AlignLeft == a);
            
            assert([@"<unknown Align: 3>" isEqualToString:AlignToString(3)]);
        }}
    }
    printf("success\n");
    return 0;
}

