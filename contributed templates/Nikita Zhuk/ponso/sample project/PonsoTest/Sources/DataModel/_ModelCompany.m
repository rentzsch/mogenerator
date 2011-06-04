//
//  ModelCompany.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelCompany.h instead.
//

#import "_ModelCompany.h"

#import "ModelDepartment.h"
#import "ModelPerson.h"


@interface _ModelCompany()
@property (nonatomic, retain, readwrite) NSArray *departments;
@property (nonatomic, retain, readwrite) NSArray *people;

@end

/** \ingroup DataModel */

@implementation _ModelCompany

- (id)init
{
	if((self = [super init]))
	{
		
	}
	
	return self;
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
		
		
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelCompany.departments"])
		{
			ModelDepartment *departmentsObj = [[[ModelDepartment alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addDepartmentsObject:departmentsObj];
		}
		for(id objectRepresentationForDict in [dictionary objectForKey:@"ModelCompany.people"])
		{
			ModelPerson *peopleObj = [[[ModelPerson alloc] initWithDictionaryRepresentation:objectRepresentationForDict] autorelease];
			[self addPeopleObject:peopleObj];
		}
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.name forKey:@"ModelCompany.name"];
	[dict setObjectIfNotNil:self.yearFounded forKey:@"ModelCompany.yearFounded"];
	
	if([self.departments count] > 0)
	{
		
		NSMutableArray *departmentsRepresentationsForDictionary = [NSMutableArray arrayWithCapacity:[self.departments count]];
		for(ModelDepartment *obj in self.departments)
		{
			[departmentsRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:departmentsRepresentationsForDictionary forKey:@"ModelCompany.departments"];
		
	}
	
	if([self.people count] > 0)
	{
		
		NSMutableArray *peopleRepresentationsForDictionary = [NSMutableArray arrayWithCapacity:[self.people count]];
		for(ModelPerson *obj in self.people)
		{
			[peopleRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
		}
		[dict setObjectIfNotNil:peopleRepresentationsForDictionary forKey:@"ModelCompany.people"];
		
	}
	
	
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	


	
	for(ModelPerson *peopleObj in self.people)
	{
		[peopleObj awakeFromDictionaryRepresentationInit];
	}
	
	for(ModelDepartment *departmentsObj in self.departments)
	{
		[departmentsObj awakeFromDictionaryRepresentationInit];
	}
	
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access


- (void)addDepartmentsObject:(ModelDepartment*)value_
{
	if(self.departments == nil)
	{
		self.departments = [NSMutableArray array];
	}
		
	[(NSMutableArray *)self.departments addObject:value_];
	value_.company = (ModelCompany*)self;
}

- (void)removeDepartmentsObjects
{
	self.departments = [NSMutableArray array];
}

- (void)removeDepartmentsObject:(ModelDepartment*)value_
{
	value_.company = nil;
	[(NSMutableArray *)self.departments removeObject:value_];
}


- (void)addPeopleObject:(ModelPerson*)value_
{
	if(self.people == nil)
	{
		self.people = [NSMutableArray array];
	}
		
	[(NSMutableArray *)self.people addObject:value_];
	value_.company = (ModelCompany*)self;
}

- (void)removePeopleObjects
{
	self.people = [NSMutableArray array];
}

- (void)removePeopleObject:(ModelPerson*)value_
{
	value_.company = nil;
	[(NSMutableArray *)self.people removeObject:value_];
}



- (void)dealloc
{
	self.name = nil;
	self.yearFounded = nil;
	
	self.departments = nil;
	self.people = nil;
	
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize name;
@synthesize yearFounded;

@synthesize departments;
@synthesize people;

@end
