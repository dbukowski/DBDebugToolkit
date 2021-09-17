//
//  CarMO+CoreDataProperties.h
//  
//
//  Created by Dariusz Bukowski on 05.03.2017.
//
//  This file was automatically generated and should not be edited.
//

#import "CarMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CarMO (CoreDataProperties)

+ (NSFetchRequest<CarMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *color;
@property (nonatomic) BOOL hasAirConditioning;
@property (nullable, nonatomic, copy) NSString *manufacturer;
@property (nonatomic) int16_t modelYear;
@property (nonatomic) int16_t numberOfDoors;
@property (nullable, nonatomic, copy) NSString *plateNumber;
@property (nullable, nonatomic, retain) NSSet<PersonMO *> *owners;

@end

@interface CarMO (CoreDataGeneratedAccessors)

- (void)addOwnersObject:(PersonMO *)value;
- (void)removeOwnersObject:(PersonMO *)value;
- (void)addOwners:(NSSet<PersonMO *> *)values;
- (void)removeOwners:(NSSet<PersonMO *> *)values;

@end

NS_ASSUME_NONNULL_END
