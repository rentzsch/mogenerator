#import <Foundation/Foundation.h>
#import "JREnum.h"

JREnumDeclare(SplitEnumWith1ConstantSansExplicitValues,
              SplitEnumWith1ConstantSansExplicitValues_Constant1);

JREnumDeclare(SplitEnumWith2ConstantsSansExplicitValues,
              SplitEnumWith2ConstantsSansExplicitValues_Constant1,
              SplitEnumWith2ConstantsSansExplicitValues_Constant2);

JREnumDeclare(SplitEnumWith1ConstantWithExplicitValues,
              SplitEnumWith1ConstantWithExplicitValues_Constant1 = 42);

JREnumDeclare(TestClassState,
              TestClassState_Closed,
              TestClassState_Opening,
              TestClassState_Open,
              TestClassState_Closing);

JREnumDeclare(Align,
              AlignLeft         = 1 << 0,
              AlignRight        = 1 << 1,
              AlignTop          = 1 << 2,
              AlignBottom       = 1 << 3,
              AlignTopLeft      = 0x05,
              AlignBottomLeft   = 0x09,
              AlignTopRight     = 0x06,
              AlignBottomRight  = 0x0A,
              );