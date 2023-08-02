//
//  PersonMO+CoreDataProperties.m
//  
//
//  Created by Dariusz Bukowski on 05.03.2017.
//
//  This file was automatically generated and should not be edited.
//

#import "PersonMO+CoreDataProperties.h"

@implementation PersonMO (CoreDataProperties)

+ (NSFetchRequest<PersonMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic dateOfBirth;
@dynamic firstName;
@dynamic lastName;
@dynamic address;
@dynamic cars;
@dynamic friends;
@dynamic passport;

@end
