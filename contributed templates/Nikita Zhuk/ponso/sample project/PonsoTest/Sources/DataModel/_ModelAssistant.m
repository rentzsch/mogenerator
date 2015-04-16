//
//  ModelAssistant.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelAssistant.h instead.
//

#import "_ModelAssistant.h"

#import "ModelEmployee.h"
#import "ModelCompany.h"
#import "ModelDepartmentAssistant.h"


@interface _ModelAssistant()
@property (nonatomic, retain, readwrite) NSArray *departments;

@end

/** \ingroup DataModel */

@implementation _ModelAssistant

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
		self.birthDate = [dictionary objectForKey:@"ModelAssistant.birthDate"];
		self.name = [dictionary objectForKey:@"ModelAssistant.name"];
		
		
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.birthDate forKey:@"ModelAssistant.birthDate"];
	[dict setObjectIfNotNil:self.name forKey:@"ModelAssistant.name"];
	
	
	
	
	
	
	
	
	
	if([self.departments count] > 0)
	{
		
	}
	
	
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	


	
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access


- (void)addDepartmentsObject:(ModelDepartmentAssistant*)value_
{
	if(self.departments == nil)
	{
		self.departments = [NSMutableArray array];
	}
		
	[(NSMutableArray *)self.departments addObject:value_];
	value_.assistant = (ModelAssistant*)self;
}

- (void)removeDepartmentsObjects
{
	self.departments = [NSMutableArray array];
}

- (void)removeDepartmentsObject:(ModelDepartmentAssistant*)value_
{
	value_.assistant = nil;
	[(NSMutableArray *)self.departments removeObject:value_];
}



- (void)dealloc
{
	self.birthDate = nil;
	self.name = nil;
	
	self.boss = nil;
	self.company = nil;
	self.departments = nil;
	
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize birthDate;
@synthesize name;

@synthesize boss;
@synthesize company;
@synthesize departments;

@end
