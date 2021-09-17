//
//  PersonMO+CoreDataProperties.h
//  
//
//  Created by Dariusz Bukowski on 05.03.2017.
//
//  This file was automatically generated and should not be edited.
//

#import "PersonMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PersonMO (CoreDataProperties)

+ (NSFetchRequest<PersonMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateOfBirth;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, retain) AddressMO *address;
@property (nullable, nonatomic, retain) NSSet<CarMO *> *cars;
@property (nullable, nonatomic, retain) NSSet<PersonMO *> *friends;
@property (nullable, nonatomic, retain) PassportMO *passport;

@end

@interface PersonMO (CoreDataGeneratedAccessors)

- (void)addCarsObject:(CarMO *)value;
- (void)removeCarsObject:(CarMO *)value;
- (void)addCars:(NSSet<CarMO *> *)values;
- (void)removeCars:(NSSet<CarMO *> *)values;

- (void)addFriendsObject:(PersonMO *)value;
- (void)removeFriendsObject:(PersonMO *)value;
- (void)addFriends:(NSSet<PersonMO *> *)values;
- (void)removeFriends:(NSSet<PersonMO *> *)values;

@end

NS_ASSUME_NONNULL_END
