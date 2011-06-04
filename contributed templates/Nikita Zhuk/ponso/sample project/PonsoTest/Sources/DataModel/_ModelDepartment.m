//
//  ModelDepartment.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelDepartment.h instead.
//

#import "_ModelDepartment.h"

#import "ModelCompany.h"
#import "ModelPerson.h"


@interface _ModelDepartment()
@property (nonatomic, retain, readwrite) NSArray *people;

@end

/** \ingroup DataModel */

@implementation _ModelDepartment

- (id)init
{
	if((self = [super init]))
	{
		
	}
	
	return self;
}

#pragma mark Scalar values



#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
		self.name = [dictionary objectForKey:@"ModelDepartment.name"];
		
		
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.name forKey:@"ModelDepartment.name"];
	
	
	
	
	
	if([self.people count] > 0)
	{
		
		NSMutableArray *peopleRepresentationsForDictionary = [NSMutableArray arrayWithCapacity:[self.people count]];
		for(ModelPerson *obj in self.people)
		{
			[peopleRepresentationsForDictionary addObject:[obj valueForKeyPath:@"id"]];
			
		}
		[dict setObjectIfNotNil:peopleRepresentationsForDictionary forKey:@"ModelDepartment.people"];
		
	}
	
	
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	NSArray *ModelDepartment_peopleIDs = [self.sourceDictionaryRepresentation objectForKey:@"ModelDepartment.people"];
	for(id ModelDepartment_peopleID in ModelDepartment_peopleIDs)
	{
		ModelPerson *peopleObj = [(_ModelDepartment<_ModelDepartment> *)self fetchPersonObjectWithIDForPeopleRelationship:ModelDepartment_peopleID];
		if(peopleObj != nil)
			[self addPeopleObject:peopleObj];
	}
	


	
	for(ModelPerson *peopleObj in self.people)
	{
		[peopleObj awakeFromDictionaryRepresentationInit];
	}
	
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access


- (void)addPeopleObject:(ModelPerson*)value_
{
	if(self.people == nil)
	{
		self.people = [NSMutableArray array];
	}
		
	[(NSMutableArray *)self.people addObject:value_];
	value_.department = (ModelDepartment*)self;
}

- (void)removePeopleObjects
{
	self.people = [NSMutableArray array];
}

- (void)removePeopleObject:(ModelPerson*)value_
{
	value_.department = nil;
	[(NSMutableArray *)self.people removeObject:value_];
}



- (void)dealloc
{
	self.name = nil;
	
	self.company = nil;
	self.people = nil;
	
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize name;

@synthesize company;
@synthesize people;

@end
