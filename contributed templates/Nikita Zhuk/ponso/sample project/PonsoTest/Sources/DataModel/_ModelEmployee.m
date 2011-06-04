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
@property (nonatomic, retain, readwrite) NSArray *departments;

@end

/** \ingroup DataModel */

@implementation _ModelEmployee

- (id)init
{
	if((self = [super init]))
	{
		self.isOnVacation = [NSNumber numberWithBool:0];
		
	}
	
	return self;
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


- (void)addDepartmentsObject:(ModelDepartmentEmployee*)value_
{
	if(self.departments == nil)
	{
		self.departments = [NSMutableArray array];
	}
		
	[(NSMutableArray *)self.departments addObject:value_];
	value_.employee = (ModelEmployee*)self;
}

- (void)removeDepartmentsObjects
{
	self.departments = [NSMutableArray array];
}

- (void)removeDepartmentsObject:(ModelDepartmentEmployee*)value_
{
	value_.employee = nil;
	[(NSMutableArray *)self.departments removeObject:value_];
}



- (void)dealloc
{
	self.birthDate = nil;
	self.isOnVacation = nil;
	self.name = nil;
	
	self.assistant = nil;
	self.company = nil;
	self.departments = nil;
	
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize birthDate;
@synthesize isOnVacation;
@synthesize name;

@synthesize assistant;
@synthesize company;
@synthesize departments;

@end
