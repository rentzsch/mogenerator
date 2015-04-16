//
//  ModelCompany.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelCompany.h instead.
//


#import "_ModelCompany.h"

#import "ModelAssistant.h"
#import "ModelDepartment.h"
#import "ModelEmployee.h"

@interface _ModelCompany()
@property (nonatomic, retain, readwrite) NSSet *assistants;
@property (nonatomic, retain, readwrite) NSSet *departments;
@property (nonatomic, retain, readwrite) NSSet *employees;
@end

/** \ingroup DataModel */

NS_INLINE NSMutableSet* NonretainingNSMutableSetMake()
{
    CFSetCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual, CFHash};
    return [(NSMutableSet*) CFSetCreateMutable(0, 0, &callbacks) autorelease];
}

@implementation _ModelCompany
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
        self.yearFounded = [aDecoder decodeObjectForKey: @"yearFounded"];
        self.assistants = [aDecoder decodeObjectForKey: @"assistants"];
        self.departments = [aDecoder decodeObjectForKey: @"departments"];
        self.employees = [aDecoder decodeObjectForKey: @"employees"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.name forKey: @"name"];
    [aCoder encodeObject: self.yearFounded forKey: @"yearFounded"];
    [aCoder encodeObject: self.assistants forKey: @"assistants"];
    [aCoder encodeObject: self.departments forKey: @"departments"];
    [aCoder encodeObject: self.employees forKey: @"employees"];
}

#pragma mark Scalar values
- (int)yearFoundedValue
{
	return [self.yearFounded intValue];
}

- (void)setYearFoundedValue:(int)value_
{
	self.yearFounded = [NSNumber numberWithInt:value_];
}


#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
		self.name = [dictionary objectForKey:@"ModelCompany.name"];
		self.yearFounded = [dictionary objectForKey:@"ModelCompany.yearFounded"];
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelCompany.assistants"])
		{
            ModelAssistant *assistantsObj = [[[ModelAssistant alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addAssistantsObject:assistantsObj];
		}
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelCompany.departments"])
		{
            ModelDepartment *departmentsObj = [[[ModelDepartment alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addDepartmentsObject:departmentsObj];
		}
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelCompany.employees"])
		{
            ModelEmployee *employeesObj = [[[ModelEmployee alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addEmployeesObject:employeesObj];
		}
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.name forKey:@"ModelCompany.name"];
	[dict setObjectIfNotNil:self.yearFounded forKey:@"ModelCompany.yearFounded"];
	if([self.assistants count] > 0)
	{
		NSMutableSet *assistantsRepresentationsForDictionary = [NSMutableSet setWithCapacity:[self.assistants count]];
		for(ModelAssistant *obj in self.assistants)
		{
			[assistantsRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:assistantsRepresentationsForDictionary forKey:@"ModelCompany.assistants"];
	}
	if([self.departments count] > 0)
	{
		NSMutableSet *departmentsRepresentationsForDictionary = [NSMutableSet setWithCapacity:[self.departments count]];
		for(ModelDepartment *obj in self.departments)
		{
			[departmentsRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:departmentsRepresentationsForDictionary forKey:@"ModelCompany.departments"];
	}
	if([self.employees count] > 0)
	{
		NSMutableSet *employeesRepresentationsForDictionary = [NSMutableSet setWithCapacity:[self.employees count]];
		for(ModelEmployee *obj in self.employees)
		{
			[employeesRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:employeesRepresentationsForDictionary forKey:@"ModelCompany.employees"];
	}
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	for(ModelDepartment *departmentsObj in self.departments)
	{
		[departmentsObj awakeFromDictionaryRepresentationInit];
	}
	for(ModelAssistant *assistantsObj in self.assistants)
	{
		[assistantsObj awakeFromDictionaryRepresentationInit];
	}
	for(ModelEmployee *employeesObj in self.employees)
	{
		[employeesObj awakeFromDictionaryRepresentationInit];
	}
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access

- (void)addAssistantsObject:(ModelAssistant*)value_ settingInverse: (BOOL) setInverse
{
    if(self.assistants == nil)
	{
		self.assistants = [NSMutableSet set];
	}
		
	[(NSMutableSet *)self.assistants addObject:value_];
	if (setInverse == YES) {
	    [value_ setCompany: (ModelCompany*)self settingInverse: NO];
	}
}

- (void)addAssistantsObject:(ModelAssistant*)value_
{
    [self addAssistantsObject:(ModelAssistant*)value_ settingInverse: YES];
}

- (void)removeAssistantsObjects
{
	self.assistants = [NSMutableSet set];
}

- (void)removeAssistantsObject:(ModelAssistant*)value_ settingInverse: (BOOL) setInverse
{
    if (setInverse == YES) {
        [value_ setCompany: nil settingInverse: NO];
    }
    [(NSMutableSet *)self.assistants removeObject:value_];
}

- (void)removeAssistantsObject:(ModelAssistant*)value_
{
    [self removeAssistantsObject:(ModelAssistant*)value_ settingInverse: YES];
}

- (void)addDepartmentsObject:(ModelDepartment*)value_ settingInverse: (BOOL) setInverse
{
    if(self.departments == nil)
	{
		self.departments = [NSMutableSet set];
	}
		
	[(NSMutableSet *)self.departments addObject:value_];
	if (setInverse == YES) {
	    [value_ setCompany: (ModelCompany*)self settingInverse: NO];
	}
}

- (void)addDepartmentsObject:(ModelDepartment*)value_
{
    [self addDepartmentsObject:(ModelDepartment*)value_ settingInverse: YES];
}

- (void)removeDepartmentsObjects
{
	self.departments = [NSMutableSet set];
}

- (void)removeDepartmentsObject:(ModelDepartment*)value_ settingInverse: (BOOL) setInverse
{
    if (setInverse == YES) {
        [value_ setCompany: nil settingInverse: NO];
    }
    [(NSMutableSet *)self.departments removeObject:value_];
}

- (void)removeDepartmentsObject:(ModelDepartment*)value_
{
    [self removeDepartmentsObject:(ModelDepartment*)value_ settingInverse: YES];
}

- (void)addEmployeesObject:(ModelEmployee*)value_ settingInverse: (BOOL) setInverse
{
    if(self.employees == nil)
	{
		self.employees = [NSMutableSet set];
	}
		
	[(NSMutableSet *)self.employees addObject:value_];
	if (setInverse == YES) {
	    [value_ setCompany: (ModelCompany*)self settingInverse: NO];
	}
}

- (void)addEmployeesObject:(ModelEmployee*)value_
{
    [self addEmployeesObject:(ModelEmployee*)value_ settingInverse: YES];
}

- (void)removeEmployeesObjects
{
	self.employees = [NSMutableSet set];
}

- (void)removeEmployeesObject:(ModelEmployee*)value_ settingInverse: (BOOL) setInverse
{
    if (setInverse == YES) {
        [value_ setCompany: nil settingInverse: NO];
    }
    [(NSMutableSet *)self.employees removeObject:value_];
}

- (void)removeEmployeesObject:(ModelEmployee*)value_
{
    [self removeEmployeesObject:(ModelEmployee*)value_ settingInverse: YES];
}


- (void)dealloc
{
	self.name = nil;
	self.yearFounded = nil;
	self.assistants = nil;
	self.departments = nil;
	self.employees = nil;
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize name;
@synthesize yearFounded;
@synthesize assistants;
@synthesize departments;
@synthesize employees;

@end
