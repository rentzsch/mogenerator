//
//  NSFetchRequest+momc.m
//  momc
//
//  Created by Tom Harrington on 4/23/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

#import "NSFetchRequest+momcom.h"

@implementation NSFetchRequest (momcom)

+ (NSFetchRequest *)fetchRequestForXML:(NSXMLElement *)fetchRequestXMLNode inManagedObjectModel:(NSManagedObjectModel *)model
{
    NSFetchRequest *fetchRequest = nil;
    
    if ([[fetchRequestXMLNode name] isEqualToString:@"fetchRequest"]) {
        NSString *targetEntityName = [[fetchRequestXMLNode attributeForName:@"entity"] stringValue];
        if (targetEntityName != nil) {
            NSEntityDescription *targetEntity = [[model entitiesByName] objectForKey:targetEntityName];
            fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:targetEntity];
        }
        NSString *predicateString = [[fetchRequestXMLNode attributeForName:@"predicateString"] stringValue];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        [fetchRequest setPredicate:predicate];
    }
    return fetchRequest;
}

@end
