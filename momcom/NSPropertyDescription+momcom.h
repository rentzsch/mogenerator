//
//  NSPropertyDescription+momcom.h
//  momc
//
//  Created by Tom Harrington on 4/18/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

@import CoreData;

@interface NSPropertyDescription (momcom)

+ (id)baseEntityForXML:(NSXMLElement *)xmlNode;

@end
