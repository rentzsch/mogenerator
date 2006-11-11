// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChildMO.h instead.

#import <CoreData/CoreData.h>
#import "HumanMO.h"


@class ParentMO;


@interface _ChildMO : HumanMO {}




- (NSData*)hairColorStorage;
- (void)setHairColorStorage:(NSData*)value_;

//- (BOOL)validateHairColorStorage:(id*)value_ error:(NSError**)error_;



- (NSString*)childName;
- (void)setChildName:(NSString*)value_;

//- (BOOL)validateChildName:(id*)value_ error:(NSError**)error_;



- (NSString*)humanName;
- (void)setHumanName:(NSString*)value_;

//- (BOOL)validateHumanName:(id*)value_ error:(NSError**)error_;




- (ParentMO*)parent;
- (void)setParent:(ParentMO*)value_;
//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;


@end
