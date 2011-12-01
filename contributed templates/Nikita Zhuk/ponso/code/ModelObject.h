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
 
 ModelObject.h
 mogenerator / PONSO
 Created by Nikita Zhuk on 22.1.2011.
 */

/**
	Abstract superclass for all of our model classes.
 */

#import <Foundation/Foundation.h>

@interface ModelObject : NSObject <NSCopying>
{
	NSDictionary *sourceDictionaryRepresentation;
}

@property(nonatomic, retain) NSDictionary *sourceDictionaryRepresentation;

/**
 Reads and deserializes a ModelObject from plist at given \c filePath
 \return Newly created ModelObject or nil if any of the following occurs: file doesn't exist, file cannot be read, plist cannot be parsed.
*/
+ (id)createModelObjectFromFile:(NSString *)filePath;

/**
 Serializes the receiver into binary plist and writes it to given \c filePath. Creates any intermediate directories in the path if necessary.
 \return YES on success, NO on error (binary serialization or I/O error).
*/
- (BOOL)writeToFile:(NSString *)filePath;

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;

- (void)awakeFromDictionaryRepresentationInit;

@end


@interface NSMutableDictionary (PONSONSMutableDictionaryAdditions)

- (void)setObjectIfNotNil:(id)obj forKey:(NSString *)key;

@end
