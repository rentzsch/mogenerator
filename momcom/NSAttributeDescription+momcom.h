//
//  NSAttributeDescription+momcom.h
//  momc
//
//  Created by Tom Harrington on 4/18/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

@import CoreData;

extern const NSString *const kUsesScalarAttributeType;

@interface NSAttributeDescription (momcom)

+ (NSAttributeDescription *)baseEntityForXML:(NSXMLElement *)xmlNode;

@end
