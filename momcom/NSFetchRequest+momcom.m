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
        
        NSString *resultTypeString = [[fetchRequestXMLNode attributeForName:@"resultType"] stringValue];
        if (resultTypeString != 0) {
            switch ([resultTypeString integerValue]) {
                case 0: [fetchRequest setResultType:NSManagedObjectResultType];     break;
                case 1: [fetchRequest setResultType:NSManagedObjectIDResultType];   break;
                case 2: [fetchRequest setResultType:NSDictionaryResultType];        break;
                default: break;
            }
        }
        
        NSString *fetchLimitString = [[fetchRequestXMLNode attributeForName:@"fetchLimit"] stringValue];
        if (fetchLimitString != nil) {
            NSInteger fetchLimit = [fetchLimitString integerValue];
            [fetchRequest setFetchLimit:fetchLimit];
        }
        NSString *fetchBatchSizeString = [[fetchRequestXMLNode attributeForName:@"fetchBatchSize"] stringValue];
        if (fetchBatchSizeString != nil) {
            NSInteger fetchBatchSize = [fetchBatchSizeString integerValue];
            [fetchRequest setFetchBatchSize:fetchBatchSize];
        }
        
        // Some of the following fetch request properties are supposed to default to YES, but are represented in Xcode's
        // model editor with a checkbox that's off by default. Fetch templates therefore effectively default to NO for
        // these properties, since if you do nothing you're allowing the checkbox to indicate a NO value.
        NSString *includeSubentitiesString = [[fetchRequestXMLNode attributeForName:@"includeSubentities"] stringValue];
        if ((includeSubentitiesString != nil) && [includeSubentitiesString isEqualToString:@"YES"]) {
            [fetchRequest setIncludesSubentities:YES];
        }
        NSString *includePropertyValuesString = [[fetchRequestXMLNode attributeForName:@"includePropertyValues"] stringValue];
        if ((includePropertyValuesString != nil) && [includePropertyValuesString isEqualToString:@"YES"]) {
            [fetchRequest setIncludesPropertyValues:YES];
        }
        NSString *returnObjectsAsFaultsString = [[fetchRequestXMLNode attributeForName:@"returnObjectsAsFaults"] stringValue];
        if ((returnObjectsAsFaultsString != nil) && [returnObjectsAsFaultsString isEqualToString:@"YES"]) {
            [fetchRequest setReturnsObjectsAsFaults:YES];
        }
        NSString *includesPendingChangesString = [[fetchRequestXMLNode attributeForName:@"includesPendingChanges"] stringValue];
        if ((includesPendingChangesString != nil) && [includesPendingChangesString isEqualToString:@"YES"]) {
            [fetchRequest setIncludesPendingChanges:YES];
        }
        NSString *returnDistinctResultsString = [[fetchRequestXMLNode attributeForName:@"returnDistinctResults"] stringValue];
        if ((returnDistinctResultsString != nil) && [returnDistinctResultsString isEqualToString:@"YES"]) {
            [fetchRequest setReturnsDistinctResults:YES];
        }
    }
    return fetchRequest;
}

@end
