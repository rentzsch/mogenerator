//
//  ModelDepartment.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelDepartment.h instead.
//


#import "_ModelDepartment.h"

#import "ModelDepartmentAssistant.h"
#import "ModelCompany.h"
#import "ModelDepartmentEmployee.h"

@interface _ModelDepartment()
@property (nonatomic, retain, readwrite) NSSet *assistants;
@property (nonatomic, retain, readwrite) NSSet *employees;
@end

/** \ingroup DataModel */

NS_INLINE NSMutableSet* NonretainingNSMutableSetMake()
{
    CFSetCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual, CFHash};
    return [(NSMutableSet*) CFSetCreateMutable(0, 0, &callbacks) autorelease];
}

@implementation _ModelDepartment
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
        self.name = [aDecoder decodeObjectForKey: @"name"];
        self.assistants = [aDecoder decodeObjectForKey: @"assistants"];
        self.company = [aDecoder decodeObjectForKey: @"company"];
        self.employees = [aDecoder decodeObjectForKey: @"employees"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.name forKey: @"name"];
    [aCoder encodeObject: self.assistants forKey: @"assistants"];
    [aCoder encodeObject: self.company forKey: @"company"];
    [aCoder encodeObject: self.employees forKey: @"employees"];
}

#pragma mark Scalar values


#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
		self.name = [dictionary objectForKey:@"ModelDepartment.name"];
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelDepartment.assistants"])
		{
            ModelDepartmentAssistant *assistantsObj = [[[ModelDepartmentAssistant alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addAssistantsObject:assistantsObj];
		}
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelDepartment.employees"])
		{
            ModelDepartmentEmployee *employeesObj = [[[ModelDepartmentEmployee alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addEmployeesObject:employeesObj];
		}
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.name forKey:@"ModelDepartment.name"];
	if([self.assistants count] > 0)
	{
		NSMutableSet *assistantsRepresentationsForDictionary = [NSMutableSet setWithCapacity:[self.assistants count]];
		for(ModelDepartmentAssistant *obj in self.assistants)
		{
			[assistantsRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:assistantsRepresentationsForDictionary forKey:@"ModelDepartment.assistants"];
	}
	if([self.employees count] > 0)
	{
		NSMutableSet *employeesRepresentationsForDictionary = [NSMutableSet setWithCapacity:[self.employees count]];
		for(ModelDepartmentEmployee *obj in self.employees)
		{
			[employeesRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:employeesRepresentationsForDictionary forKey:@"ModelDepartment.employees"];
	}
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	for(ModelDepartmentAssistant *assistantsObj in self.assistants)
	{
		[assistantsObj awakeFromDictionaryRepresentationInit];
	}
	for(ModelDepartmentEmployee *employeesObj in self.employees)
	{
		[employeesObj awakeFromDictionaryRepresentationInit];
	}
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access

- (void)addAssistantsObject:(ModelDepartmentAssistant*)value_ settingInverse: (BOOL) setInverse
{
    if(self.assistants == nil)
	{
		self.assistants = [NSMutableSet set];
	}
		
	[(NSMutableSet *)self.assistants addObject:value_];
	if (setInverse == YES) {
	    [value_ setDepartment: (ModelDepartment*)self settingInverse: NO];
	}
}

- (void)addAssistantsObject:(ModelDepartmentAssistant*)value_
{
    [self addAssistantsObject:(ModelDepartmentAssistant*)value_ settingInverse: YES];
}

- (void)removeAssistantsObjects
{
	self.assistants = [NSMutableSet set];
}

- (void)removeAssistantsObject:(ModelDepartmentAssistant*)value_ settingInverse: (BOOL) setInverse
{
    if (setInverse == YES) {
        [value_ setDepartment: nil settingInverse: NO];
    }
    [(NSMutableSet *)self.assistants removeObject:value_];
}

- (void)removeAssistantsObject:(ModelDepartmentAssistant*)value_
{
    [self removeAssistantsObject:(ModelDepartmentAssistant*)value_ settingInverse: YES];
}

- (void)addEmployeesObject:(ModelDepartmentEmployee*)value_ settingInverse: (BOOL) setInverse
{
    if(self.employees == nil)
	{
		self.employees = [NSMutableSet set];
	}
		
	[(NSMutableSet *)self.employees addObject:value_];
	if (setInverse == YES) {
	    [value_ setDepartment: (ModelDepartment*)self settingInverse: NO];
	}
}

- (void)addEmployeesObject:(ModelDepartmentEmployee*)value_
{
    [self addEmployeesObject:(ModelDepartmentEmployee*)value_ settingInverse: YES];
}

- (void)removeEmployeesObjects
{
	self.employees = [NSMutableSet set];
}

- (void)removeEmployeesObject:(ModelDepartmentEmployee*)value_ settingInverse: (BOOL) setInverse
{
    if (setInverse == YES) {
        [value_ setDepartment: nil settingInverse: NO];
    }
    [(NSMutableSet *)self.employees removeObject:value_];
}

- (void)removeEmployeesObject:(ModelDepartmentEmployee*)value_
{
    [self removeEmployeesObject:(ModelDepartmentEmployee*)value_ settingInverse: YES];
}

- (void) setCompany: (ModelCompany*) company_ settingInverse: (BOOL) setInverse
{
    if (company_ == nil && setInverse == YES) {
        [company removeDepartmentsObject: (ModelDepartment*)self settingInverse: NO];
    }
    company = company_;
    if (setInverse == YES) {
        [company addDepartmentsObject: (ModelDepartment*)self settingInverse: NO];
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
	self.name = nil;
	self.assistants = nil;
	self.employees = nil;
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize name;
@synthesize assistants;
@synthesize employees;

@end
