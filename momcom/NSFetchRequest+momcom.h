//
//  NSFetchRequest+momcom.h
//  momc
//
//  Created by Tom Harrington on 4/23/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest (momcom)

+ (NSFetchRequest *)fetchRequestForXML:(NSXMLElement *)fetchRequestXMLNode inManagedObjectModel:(NSManagedObjectModel *)model;
@end
