//
//  NSRelationshipDescription+momc.m
//  momc
//
//  Created by Tom Harrington on 4/18/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

#import "NSRelationshipDescription+momcom.h"
#import "NSPropertyDescription+momcom.h"

@implementation NSRelationshipDescription (momcom)

+ (NSRelationshipDescription *)baseEntityForXML:(NSXMLElement *)xmlNode;
{
    NSRelationshipDescription *relationshipDescription = [super baseEntityForXML:xmlNode];
    
    NSXMLNode *minCountNode = [xmlNode attributeForName:@"minCount"];
    if (minCountNode != nil) {
        [relationshipDescription setMinCount:[[minCountNode stringValue] integerValue]];
    }
    NSXMLNode *maxCountNode = [xmlNode attributeForName:@"maxCount"];
    if (maxCountNode != nil) {
        [relationshipDescription setMaxCount:[[maxCountNode stringValue] integerValue]];
    }
    NSXMLNode *deletionRuleNode = [xmlNode attributeForName:@"deletionRule"];
    if (deletionRuleNode != nil) {
        NSString *deletionRuleString = [deletionRuleNode stringValue];
        if ([deletionRuleString isEqualToString:@"Nullify"]) {
            [relationshipDescription setDeleteRule:NSNullifyDeleteRule];
        } else if ([deletionRuleString isEqualToString:@"Cascade"]) {
            [relationshipDescription setDeleteRule:NSCascadeDeleteRule];
        } else if ([deletionRuleString isEqualToString:@"Deny"]) {
            [relationshipDescription setDeleteRule:NSDenyDeleteRule];
        }
    }

    // Destination entity and inverse are not handled here, they get post processed once related entities exist.
    
    return relationshipDescription;
}

@end
