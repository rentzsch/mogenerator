@import Foundation;

NS_ASSUME_NONNULL_BEGIN
@interface NSString (MORegEx)

- (NSArray *)captureComponentsMatchedByRegex:(NSString *)pattern;

- (NSString *)stringByReplacingOccurrencesOfRegex:(NSString *)pattern withString:(NSString *)replacementString;

- (BOOL)isMatchedByRegex:(NSString *)pattern;

@end
NS_ASSUME_NONNULL_END