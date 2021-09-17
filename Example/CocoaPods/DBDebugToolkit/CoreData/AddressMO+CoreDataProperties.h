//
//  AddressMO+CoreDataProperties.h
//  
//
//  Created by Dariusz Bukowski on 05.03.2017.
//
//  This file was automatically generated and should not be edited.
//

#import "AddressMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AddressMO (CoreDataProperties)

+ (NSFetchRequest<AddressMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *city;
@property (nullable, nonatomic, copy) NSString *postcode;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *street;
@property (nullable, nonatomic, retain) NSSet<PersonMO *> *residents;

@end

@interface AddressMO (CoreDataGeneratedAccessors)

- (void)addResidentsObject:(PersonMO *)value;
- (void)removeResidentsObject:(PersonMO *)value;
- (void)addResidents:(NSSet<PersonMO *> *)values;
- (void)removeResidents:(NSSet<PersonMO *> *)values;

@end

NS_ASSUME_NONNULL_END
