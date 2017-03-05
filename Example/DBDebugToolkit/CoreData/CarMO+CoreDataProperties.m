//
//  CarMO+CoreDataProperties.m
//  
//
//  Created by Dariusz Bukowski on 05.03.2017.
//
//  This file was automatically generated and should not be edited.
//

#import "CarMO+CoreDataProperties.h"

@implementation CarMO (CoreDataProperties)

+ (NSFetchRequest<CarMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Car"];
}

@dynamic color;
@dynamic hasAirConditioning;
@dynamic manufacturer;
@dynamic modelYear;
@dynamic numberOfDoors;
@dynamic plateNumber;
@dynamic owners;

@end
