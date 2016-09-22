/* MiscMergeFunctions.h created by akira on Tue 03-Sep-2002 */

#import <Foundation/NSString.h>

extern BOOL MMBoolValueOfObject(id anObject);
extern int MMIntegerValueOfObject(id anObject);
extern double MMDoubleValueForObject(id anObject);

extern BOOL MMIsObjectANumber(id anObject);
extern BOOL MMIsObjectAString(id anObject);
extern BOOL MMIsBooleanTrueString(NSString *anObject);

extern NSComparisonResult MMCompareFloats(float num1, float num2);

extern Class MMCommonAnscestorClass(id obj1, id obj2);

extern NSString *MMStringByTrimmingCommandSpace(NSString *string);
