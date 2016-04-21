#import "NSString+MORegEx.h"

@implementation NSString (MORegEx)

- (NSArray *)captureComponentsMatchedByRegex:(NSString *)pattern
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];

    return [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
}

- (NSString *)stringByReplacingOccurrencesOfRegex:(NSString *)pattern withString:(NSString *)replacementString
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];

    NSString *updatedString = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacementString];
    return updatedString;
}

- (BOOL)isMatchedByRegex:(NSString *)pattern
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    
    NSUInteger matchCount = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    return (matchCount > 0);
}

@end
