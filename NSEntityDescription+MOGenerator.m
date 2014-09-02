//
//  NSEntityDescription+MOGenerator.m
//  mogenerator
//
//  Created by Rudolph van Graan on 02/09/2014.
//
//

#import "NSEntityDescription+MOGenerator.h"
#import <objc/runtime.h>

static char const * const SwiftKey = "SwiftKeyTag";
@implementation NSEntityDescription (MOGenerator)

- (NSString *)derivedManagedObjectClassName {
    if ([self isSwiftClass]) {
        NSString *className = [self managedObjectClassName];
        
        NSError *error = NULL;
        //Project.ClassName format
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"^(\\w+)\\.(\\w+)$"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
        NSArray *matches = [regex matchesInString:className options:0 range:NSMakeRange(0, [className length])];
        if (matches.count == 1) {
            NSTextCheckingResult *result = matches[0];
            NSRange classNameRange = [result rangeAtIndex:2];
            NSString *actualClassname = [className substringWithRange:classNameRange];
            return actualClassname;
        }
    }
    
    return [self managedObjectClassName];
}


- (BOOL)isSwiftClass
{
    NSNumber *swiftClass = objc_getAssociatedObject(self, SwiftKey);
    if (swiftClass) return [swiftClass boolValue];
    return NO;
}


- (void)setIsSwiftClass:(BOOL )isSwiftClass {
    NSNumber *swiftClass = [NSNumber numberWithBool:isSwiftClass];
    objc_setAssociatedObject(self, SwiftKey, swiftClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
