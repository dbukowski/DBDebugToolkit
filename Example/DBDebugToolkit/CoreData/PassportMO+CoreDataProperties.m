//
//  PassportMO+CoreDataProperties.m
//  
//
//  Created by Dariusz Bukowski on 05.03.2017.
//
//  This file was automatically generated and should not be edited.
//

#import "PassportMO+CoreDataProperties.h"

@implementation PassportMO (CoreDataProperties)

+ (NSFetchRequest<PassportMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Passport"];
}

@dynamic dateOfIssue;
@dynamic number;
@dynamic owner;

@end
