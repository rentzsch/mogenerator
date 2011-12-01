//
//  ModelEmployee.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelEmployee.h instead.
//


#import "_ModelEmployee.h"

#import "ModelAssistant.h"
#import "ModelCompany.h"
#import "ModelDepartmentEmployee.h"

@interface _ModelEmployee()
@property (nonatomic, retain, readwrite) NSSet *departments;
@end

/** \ingroup DataModel */

NS_INLINE NSMutableSet* NonretainingNSMutableSetMake()
{
    CFSetCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual, CFHash};
    return [(NSMutableSet*) CFSetCreateMutable(0, 0, &callbacks) autorelease];
}

@implementation _ModelEmployee
- (id)init
{
	if((self = [super init]))
	{
		self.isOnVacation = [NSNumber numberWithBool:0];
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
        self.birthDate = [aDecoder decodeObjectForKey: @"birthDate"];
        self.isOnVacation = [aDecoder decodeObjectForKey: @"isOnVacation"];
        self.name = [aDecoder decodeObjectForKey: @"name"];
        self.assistant = [aDecoder decodeObjectForKey: @"assistant"];
        self.company = [aDecoder decodeObjectForKey: @"company"];
        {
            NSSet *set = [aDecoder decodeObjectForKey: @"departments"];
            NSMutableSet *nonretainingSet = NonretainingNSMutableSetMake();
	        [nonretainingSet unionSet: set];
	        self.departments = nonretainingSet;
	    }
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.birthDate forKey: @"birthDate"];
    [aCoder encodeObject: self.isOnVacation forKey: @"isOnVacation"];
    [aCoder encodeObject: self.name forKey: @"name"];
    [aCoder encodeObject: self.assistant forKey: @"assistant"];
    [aCoder encodeObject: self.company forKey: @"company"];
    [aCoder encodeObject: self.departments forKey: @"departments"];
}

#pragma mark Scalar values
- (BOOL)isOnVacationValue
{
	return [self.isOnVacation boolValue];
}

- (void)setIsOnVacationValue:(BOOL)value_
{
	self.isOnVacation = [NSNumber numberWithBool:value_];
}


#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
		self.birthDate = [dictionary objectForKey:@"ModelEmployee.birthDate"];
		self.isOnVacation = [dictionary objectForKey:@"ModelEmployee.isOnVacation"];
		self.name = [dictionary objectForKey:@"ModelEmployee.name"];
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.birthDate forKey:@"ModelEmployee.birthDate"];
	[dict setObjectIfNotNil:self.isOnVacation forKey:@"ModelEmployee.isOnVacation"];
	[dict setObjectIfNotNil:self.name forKey:@"ModelEmployee.name"];
	[dict setObjectIfNotNil:[self.assistant valueForKeyPath:@"name"] forKey:@"ModelEmployee.assistant"];
	if([self.departments count] > 0)
	{
	}
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	self.assistant = [(_ModelEmployee<_ModelEmployee> *)self fetchAssistantObjectWithIDForAssistantRelationship:[self.sourceDictionaryRepresentation objectForKey:@"ModelEmployee.assistant"]];
	self.assistant.boss = (ModelEmployee*)self;
	[self.assistant awakeFromDictionaryRepresentationInit];
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access

- (void)addDepartmentsObject:(ModelDepartmentEmployee*)value_ settingInverse: (BOOL) setInverse
{
    if(self.departments == nil)
	{
	    self.departments = NonretainingNSMutableSetMake();
	}
		
	[(NSMutableSet *)self.departments addObject:value_];
	if (setInverse == YES) {
	    [value_ setEmployee: (ModelEmployee*)self settingInverse: NO];
	}
}

- (void)addDepartmentsObject:(ModelDepartmentEmployee*)value_
{
    [self addDepartmentsObject:(ModelDepartmentEmployee*)value_ settingInverse: YES];
}

- (void)removeDepartmentsObjects
{
    self.departments = NonretainingNSMutableSetMake();
}

- (void)removeDepartmentsObject:(ModelDepartmentEmployee*)value_ settingInverse: (BOOL) setInverse
{
    if (setInverse == YES) {
        [value_ setEmployee: nil settingInverse: NO];
    }
    [(NSMutableSet *)self.departments removeObject:value_];
}

- (void)removeDepartmentsObject:(ModelDepartmentEmployee*)value_
{
    [self removeDepartmentsObject:(ModelDepartmentEmployee*)value_ settingInverse: YES];
}

- (void) setAssistant: (ModelAssistant*) assistant_ settingInverse: (BOOL) setInverse
{
    if (assistant_ == nil && setInverse == YES) {
        [assistant setBoss: nil settingInverse: NO];
    }
    if (assistant != assistant_) {
        [assistant release];
        assistant = [assistant_ retain];
    }
    if (setInverse == YES) {
        [assistant setBoss: (ModelEmployee*)self settingInverse: NO];
    }    
}

- (void) setAssistant: (ModelAssistant*) assistant_
{
    [self setAssistant: assistant_ settingInverse: YES];
}

- (ModelAssistant*) assistant{
    return assistant;
}

- (void) setCompany: (ModelCompany*) company_ settingInverse: (BOOL) setInverse
{
    if (company_ == nil && setInverse == YES) {
        [company removeEmployeesObject: (ModelEmployee*)self settingInverse: NO];
    }
    company = company_;
    if (setInverse == YES) {
        [company addEmployeesObject: (ModelEmployee*)self settingInverse: NO];
    }    
}

- (void) setCompany: (ModelCompany*) company_
{
    [self setCompany: company_ settingInverse: YES];
}

- (ModelCompany*) company{
    return company;
}


- (void)dealloc
{
	self.birthDate = nil;
	self.isOnVacation = nil;
	self.name = nil;
	self.assistant = nil;
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize birthDate;
@synthesize isOnVacation;
@synthesize name;
@synthesize departments;

@end
