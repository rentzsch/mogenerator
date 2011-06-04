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
		self.firstName = [dictionary objectForKey:@"ModelPerson.firstName"];
		self.id = [dictionary objectForKey:@"ModelPerson.id"];
		self.lastName = [dictionary objectForKey:@"ModelPerson.lastName"];
		self.isOnVacation = [dictionary objectForKey:@"ModelPerson.isOnVacation"];
		self.birthDate = [dictionary objectForKey:@"ModelPerson.birthDate"];
		
		
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	[dict setObjectIfNotNil:self.firstName forKey:@"ModelPerson.firstName"];
	[dict setObjectIfNotNil:self.id forKey:@"ModelPerson.id"];
	[dict setObjectIfNotNil:self.lastName forKey:@"ModelPerson.lastName"];
	[dict setObjectIfNotNil:self.isOnVacation forKey:@"ModelPerson.isOnVacation"];
	[dict setObjectIfNotNil:self.birthDate forKey:@"ModelPerson.birthDate"];
	
	
	
	
	
	
	
	
	
	
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
	self.firstName = nil;
	self.id = nil;
	self.lastName = nil;
	self.isOnVacation = nil;
	self.birthDate = nil;
	
	self.company = nil;
	self.department = nil;
	
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize firstName;
@synthesize id;
@synthesize lastName;
@synthesize isOnVacation;
@synthesize birthDate;

@synthesize company;
@synthesize department;

@end
