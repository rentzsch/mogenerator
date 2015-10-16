//
//  NSManagedObjectModel+momcom.h
//  momc
//
//  Created by Tom Harrington on 4/17/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectModel (momcom)

+ (NSManagedObjectModel *)compileFromDocument:(NSXMLDocument *)sourceModelDocument error:(NSError **)error;
+ (NSString *)compileModelAtPath:(NSString *)modelPath inDirectory:(NSString *)resultDirectoryPath error:(NSError **)error;

@end
