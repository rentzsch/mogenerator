//
//  ModelDepartmentAssistant.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelDepartmentAssistant.h instead.
//


#import "_ModelDepartmentAssistant.h"

#import "ModelAssistant.h"
#import "ModelDepartment.h"

@interface _ModelDepartmentAssistant()
@end

/** \ingroup DataModel */

NS_INLINE NSMutableSet* NonretainingNSMutableSetMake()
{
    CFSetCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual, CFHash};
    return [(NSMutableSet*) CFSetCreateMutable(0, 0, &callbacks) autorelease];
}

@implementation _ModelDepartmentAssistant
- (id)init
{
	if((self = [super init]))
	{
	}
	
	return self;
}

- (id) initWithCoder: (NSCoder*) aDecoder
{
    if ([[super class] instancesRespondToSelector: @selector(initWithCoder:)]) {
        self = [super initWithCoder: aDecoder];
    } else {
        self = [super init];
    }
    if (self) {
        self.startedWorking = [aDecoder decodeObjectForKey: @"startedWorking"];
        self.assistant = [aDecoder decodeObjectForKey: @"assistant"];
        self.department = [aDecoder decodeObjectForKey: @"department"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.startedWorking forKey: @"startedWorking"];
    [aCoder encodeObject: self.assistant forKey: @"assistant"];
    [aCoder encodeObject: self.department forKey: @"department"];
}

#pragma mark Scalar values


#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
		self.startedWorking = [dictionary objectForKey:@"ModelDepartmentAssistant.startedWorking"];
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.startedWorking forKey:@"ModelDepartmentAssistant.startedWorking"];
	[dict setObjectIfNotNil:[self.assistant valueForKeyPath:@"name"] forKey:@"ModelDepartmentAssistant.assistant"];
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	self.assistant = [(_ModelDepartmentAssistant<_ModelDepartmentAssistant> *)self fetchAssistantObjectWithIDForAssistantRelationship:[self.sourceDictionaryRepresentation objectForKey:@"ModelDepartmentAssistant.assistant"]];
	[self.assistant addDepartmentsObject:(ModelDepartmentAssistant*)self];
	[self.assistant awakeFromDictionaryRepresentationInit];
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access

- (void) setAssistant: (ModelAssistant*) assistant_ settingInverse: (BOOL) setInverse
{
    if (assistant_ == nil && setInverse == YES) {
        [assistant removeDepartmentsObject: (ModelDepartmentAssistant*)self settingInverse: NO];
    }
    if (assistant != assistant_) {
        [assistant release];
        assistant = [assistant_ retain];
    }
    if (setInverse == YES) {
        [assistant addDepartmentsObject: (ModelDepartmentAssistant*)self settingInverse: NO];
    }    
}

- (void) setAssistant: (ModelAssistant*) assistant_
{
    [self setAssistant: assistant_ settingInverse: YES];
}

- (ModelAssistant*) assistant{
    return assistant;
}

- (void) setDepartment: (ModelDepartment*) department_ settingInverse: (BOOL) setInverse
{
    if (department_ == nil && setInverse == YES) {
        [department removeAssistantsObject: (ModelDepartmentAssistant*)self settingInverse: NO];
    }
    department = department_;
    if (setInverse == YES) {
        [department addAssistantsObject: (ModelDepartmentAssistant*)self settingInverse: NO];
    }    
}

- (void) setDepartment: (ModelDepartment*) department_
{
    [self setDepartment: department_ settingInverse: YES];
}

- (ModelDepartment*) department{
    return department;
}


- (void)dealloc
{
	self.startedWorking = nil;
	self.assistant = nil;
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize startedWorking;

@end
