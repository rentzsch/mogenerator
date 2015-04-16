//
//  ModelDepartmentEmployee.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelDepartmentEmployee.h instead.
//


#import "_ModelDepartmentEmployee.h"

#import "ModelDepartment.h"
#import "ModelEmployee.h"

@interface _ModelDepartmentEmployee()
@end

/** \ingroup DataModel */

NS_INLINE NSMutableSet* NonretainingNSMutableSetMake()
{
    CFSetCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual, CFHash};
    return [(NSMutableSet*) CFSetCreateMutable(0, 0, &callbacks) autorelease];
}

@implementation _ModelDepartmentEmployee
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
        self.department = [aDecoder decodeObjectForKey: @"department"];
        self.employee = [aDecoder decodeObjectForKey: @"employee"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.startedWorking forKey: @"startedWorking"];
    [aCoder encodeObject: self.department forKey: @"department"];
    [aCoder encodeObject: self.employee forKey: @"employee"];
}

#pragma mark Scalar values


#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
		self.startedWorking = [dictionary objectForKey:@"ModelDepartmentEmployee.startedWorking"];
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.startedWorking forKey:@"ModelDepartmentEmployee.startedWorking"];
	[dict setObjectIfNotNil:[self.employee valueForKeyPath:@"name"] forKey:@"ModelDepartmentEmployee.employee"];
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	self.employee = [(_ModelDepartmentEmployee<_ModelDepartmentEmployee> *)self fetchEmployeeObjectWithIDForEmployeeRelationship:[self.sourceDictionaryRepresentation objectForKey:@"ModelDepartmentEmployee.employee"]];
	[self.employee addDepartmentsObject:(ModelDepartmentEmployee*)self];
	[self.employee awakeFromDictionaryRepresentationInit];
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access

- (void) setDepartment: (ModelDepartment*) department_ settingInverse: (BOOL) setInverse
{
    if (department_ == nil && setInverse == YES) {
        [department removeEmployeesObject: (ModelDepartmentEmployee*)self settingInverse: NO];
    }
    department = department_;
    if (setInverse == YES) {
        [department addEmployeesObject: (ModelDepartmentEmployee*)self settingInverse: NO];
    }    
}

- (void) setDepartment: (ModelDepartment*) department_
{
    [self setDepartment: department_ settingInverse: YES];
}

- (ModelDepartment*) department{
    return department;
}

- (void) setEmployee: (ModelEmployee*) employee_ settingInverse: (BOOL) setInverse
{
    if (employee_ == nil && setInverse == YES) {
        [employee removeDepartmentsObject: (ModelDepartmentEmployee*)self settingInverse: NO];
    }
    if (employee != employee_) {
        [employee release];
        employee = [employee_ retain];
    }
    if (setInverse == YES) {
        [employee addDepartmentsObject: (ModelDepartmentEmployee*)self settingInverse: NO];
    }    
}

- (void) setEmployee: (ModelEmployee*) employee_
{
    [self setEmployee: employee_ settingInverse: YES];
}

- (ModelEmployee*) employee{
    return employee;
}


- (void)dealloc
{
	self.startedWorking = nil;
	self.employee = nil;
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize startedWorking;

@end
