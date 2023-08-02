//
//  AddressMO+CoreDataProperties.m
//  
//
//  Created by Dariusz Bukowski on 05.03.2017.
//
//  This file was automatically generated and should not be edited.
//

#import "AddressMO+CoreDataProperties.h"

@implementation AddressMO (CoreDataProperties)

+ (NSFetchRequest<AddressMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Address"];
}

@dynamic city;
@dynamic postcode;
@dynamic state;
@dynamic street;
@dynamic residents;

@end
