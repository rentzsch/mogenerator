//
//  NSFetchedPropertyDescription+momc.m
//  momc
//
//  Created by Tom Harrington on 4/18/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

#import "NSFetchedPropertyDescription+momcom.h"
#import "NSPropertyDescription+momcom.h"

@implementation NSFetchedPropertyDescription (momcom)

+ (NSFetchedPropertyDescription *)baseEntityForXML:(NSXMLElement *)xmlNode
{
    NSFetchedPropertyDescription *fetchedPropertyDescription = [super baseEntityForXML:xmlNode];
    
    // Nothing much happens here because it's impossible to create the fetch request without a reference
    // to the target entity. That happens in NSEntityDescription's post-process phase.
    // And no, +[NSFetchRequest fetchRequestWithEntityName:] here would not be not a convenient workaround,
    // it's a good way to get an exception thrown at you.
    
    return fetchedPropertyDescription;
}

@end
