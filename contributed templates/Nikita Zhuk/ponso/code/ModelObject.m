/*
 Copyright 2011 Marko Karppinen & Co. LLC.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 ModelObject.m
 mogenerator / PONSO
 Created by Nikita Zhuk on 22.1.2011.
 */

#import "ModelObject.h"

@implementation ModelObject

+ (id)createModelObjectFromFile:(NSString *)filePath
{
	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		return nil;
	}
	
	NSError *error = nil;
	NSData *plistData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingUncached error:&error];
	if(!plistData)
	{
		NSLog(@"Couldn't read '%@' data from '%@': %@.", NSStringFromClass([self class]), filePath, error);
		return nil;
	}
	
	if([plistData length] == 0)
	{
		NSLog(@"Empty '%@' data found from '%@'.", NSStringFromClass([self class]), filePath);
		return nil;
	}
	
	NSString *errorString = nil;
	NSDictionary *plist = [NSPropertyListSerialization propertyListFromData:plistData
														   mutabilityOption:0
																	 format:NULL
														   errorDescription:&errorString];
	if(!plist)
	{
		NSLog(@"Couldn't load '%@' data from '%@': %@.", NSStringFromClass([self class]), filePath, errorString);
		[errorString release];
		
		return nil;
	}
	
	id modelObject = [[[self alloc] initWithDictionaryRepresentation:plist] autorelease];
	[modelObject awakeFromDictionaryRepresentationInit];
	
	return modelObject;
}

- (BOOL)writeToFile:(NSString *)filePath
{
    if(filePath == nil)
    {
        NSLog(@"File path was nil - cannot write to file.");
        return NO;
    }
	
	// Save this modelObject into plist
	NSDictionary *dict = [self dictionaryRepresentation];
	NSString *errorDesc = nil;
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListBinaryFormat_v1_0 errorDescription:&errorDesc];
	if(!plistData)
	{
		NSLog(@"Error while serializing model object of class '%@' into plist. Error: '%@'.", NSStringFromClass([self class]), errorDesc);
		
		[errorDesc release]; // From docs: "If you receive a string, you must release it."
		return NO;
	}
	
    BOOL isDir = NO;
	if(![[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByDeletingLastPathComponent] isDirectory:&isDir] || !isDir)
	{
		NSError *error = nil;
		if(![[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error])
		{
			NSLog(@"Couldn't create parent directory of file path '%@' for saving model object of class '%@': %@.", filePath,  NSStringFromClass([self class]), error);
			return NO;
		}
	}
	
	if(![plistData writeToFile:filePath atomically:YES])
	{
		NSLog(@"Error while saving model object of class '%@' into plist file %@.",  NSStringFromClass([self class]), filePath);
		return NO;
		
	}
	
	return YES;
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super init]))
	{
		self.sourceDictionaryRepresentation = dictionary;
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	return [NSDictionary dictionary];
}

- (void)awakeFromDictionaryRepresentationInit
{
	self.sourceDictionaryRepresentation = nil;
}

- (void) dealloc
{
	self.sourceDictionaryRepresentation = nil;
	
	[super dealloc];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	// Note: ModelObject is not autoreleased because we are in copy method.
	ModelObject *copy = [[[self class] alloc] initWithDictionaryRepresentation:[self dictionaryRepresentation]];
	[copy awakeFromDictionaryRepresentationInit];
	
	return copy;
}

@synthesize sourceDictionaryRepresentation;

@end


@implementation NSMutableDictionary (PONSONSMutableDictionaryAdditions)

- (void)setObjectIfNotNil:(id)obj forKey:(NSString *)key
{
	if(obj == nil)
		return;
	
	[self setObject:obj forKey:key];
}

@end
