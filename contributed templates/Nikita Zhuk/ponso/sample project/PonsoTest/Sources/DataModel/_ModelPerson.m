//
//  ModelPerson.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ModelPerson.h instead.
//

#import "_ModelPerson.h"

#import "ModelCompany.h"
#import "ModelDepartment.h"


@interface _ModelPerson()

@end

/** \ingroup DataModel */

@implementation _ModelPerson

- (id)init
{
	if((self = [super init]))
	{
		
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
		self.birthDate = [dictionary objectForKey:@"ModelPerson.birthDate"];
		self.firstName = [dictionary objectForKey:@"ModelPerson.firstName"];
		self.id = [dictionary objectForKey:@"ModelPerson.id"];
		self.isOnVacation = [dictionary objectForKey:@"ModelPerson.isOnVacation"];
		self.lastName = [dictionary objectForKey:@"ModelPerson.lastName"];
		
		
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.birthDate forKey:@"ModelPerson.birthDate"];
	[dict setObjectIfNotNil:self.firstName forKey:@"ModelPerson.firstName"];
	[dict setObjectIfNotNil:self.id forKey:@"ModelPerson.id"];
	[dict setObjectIfNotNil:self.isOnVacation forKey:@"ModelPerson.isOnVacation"];
	[dict setObjectIfNotNil:self.lastName forKey:@"ModelPerson.lastName"];
	
	
	
	
	
	
	
	
	
	
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.
	
	


	
	
	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access



- (void)dealloc
{
	self.birthDate = nil;
	self.firstName = nil;
	self.id = nil;
	self.isOnVacation = nil;
	self.lastName = nil;
	
	self.company = nil;
	self.department = nil;
	
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize birthDate;
@synthesize firstName;
@synthesize id;
@synthesize isOnVacation;
@synthesize lastName;

@synthesize company;
@synthesize department;

@end
