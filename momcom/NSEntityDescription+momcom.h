//
//  NSEntityDescription+momcom.h
//  momc
//
//  Created by Tom Harrington on 4/17/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSEntityDescription (momcom)

+ (NSEntityDescription *)baseEntityForXML:(NSXMLElement *)xmlNode;

- (void)postProcessEntityRelationshipsWithXML:(NSXMLElement *)xmlElement;
@end
