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
@property (nonatomic, retain, readwrite) NSSet *departments;
@end

/** \ingroup DataModel */

NS_INLINE NSMutableSet* NonretainingNSMutableSetMake()
{
    CFSetCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual, CFHash};
    return [(NSMutableSet*) CFSetCreateMutable(0, 0, &callbacks) autorelease];
}

@implementation _ModelAssistant
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
        self.birthDate = [aDecoder decodeObjectForKey: @"birthDate"];
        self.name = [aDecoder decodeObjectForKey: @"name"];
        self.boss = [aDecoder decodeObjectForKey: @"boss"];
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
    [aCoder encodeObject: self.name forKey: @"name"];
    [aCoder encodeObject: self.boss forKey: @"boss"];
    [aCoder encodeObject: self.company forKey: @"company"];
    [aCoder encodeObject: self.departments forKey: @"departments"];
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

- (void)addDepartmentsObject:(ModelDepartmentAssistant*)value_ settingInverse: (BOOL) setInverse
{
    if(self.departments == nil)
	{
	    self.departments = NonretainingNSMutableSetMake();
	}
		
	[(NSMutableSet *)self.departments addObject:value_];
	if (setInverse == YES) {
	    [value_ setAssistant: (ModelAssistant*)self settingInverse: NO];
	}
}

- (void)addDepartmentsObject:(ModelDepartmentAssistant*)value_
{
    [self addDepartmentsObject:(ModelDepartmentAssistant*)value_ settingInverse: YES];
}

- (void)removeDepartmentsObjects
{
    self.departments = NonretainingNSMutableSetMake();
}

- (void)removeDepartmentsObject:(ModelDepartmentAssistant*)value_ settingInverse: (BOOL) setInverse
{
    if (setInverse == YES) {
        [value_ setAssistant: nil settingInverse: NO];
    }
    [(NSMutableSet *)self.departments removeObject:value_];
}

- (void)removeDepartmentsObject:(ModelDepartmentAssistant*)value_
{
    [self removeDepartmentsObject:(ModelDepartmentAssistant*)value_ settingInverse: YES];
}

- (void) setBoss: (ModelEmployee*) boss_ settingInverse: (BOOL) setInverse
{
    if (boss_ == nil && setInverse == YES) {
        [boss setAssistant: nil settingInverse: NO];
    }
    boss = boss_;
    if (setInverse == YES) {
        [boss setAssistant: (ModelAssistant*)self settingInverse: NO];
    }    
}

- (void) setBoss: (ModelEmployee*) boss_
{
    [self setBoss: boss_ settingInverse: YES];
}

- (ModelEmployee*) boss{
    return boss;
}

- (void) setCompany: (ModelCompany*) company_ settingInverse: (BOOL) setInverse
{
    if (company_ == nil && setInverse == YES) {
        [company removeAssistantsObject: (ModelAssistant*)self settingInverse: NO];
    }
    company = company_;
    if (setInverse == YES) {
        [company addAssistantsObject: (ModelAssistant*)self settingInverse: NO];
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
	self.name = nil;
	[super dealloc];
}

#pragma mark Synthesizes

@synthesize birthDate;
@synthesize name;
@synthesize departments;

@end
