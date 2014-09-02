//
//  NSEntityDescription+MOGenerator.h
//  mogenerator
//
//  Created by Rudolph van Graan on 02/09/2014.
//
//

#import <CoreData/CoreData.h>

@interface NSEntityDescription (MOGenerator)
@property (nonatomic) BOOL isSwiftClass ;

- (NSString *)derivedManagedObjectClassName;

@end
