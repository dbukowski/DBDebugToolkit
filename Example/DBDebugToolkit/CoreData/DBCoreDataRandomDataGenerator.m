//
//  DBCoreDataRandomDataGenerator.m
//  DBDebugToolkit
//
//  Created by Dariusz Bukowski on 05.03.2017.
//  Copyright © 2017 Dariusz Bukowski. All rights reserved.
//

#import "DBCoreDataRandomDataGenerator.h"
#import "PersonMO+CoreDataClass.h"
#import "PassportMO+CoreDataClass.h"
#import "CarMO+CoreDataClass.h"
#import "AddressMO+CoreDataClass.h"

static const NSTimeInterval DBCoreDataRandomDataGeneratorSecondsInAYear = 60.0 * 60.0 * 24.0 * 365.0;

@implementation DBCoreDataRandomDataGenerator

+ (void)addNewRandomDataWithManagedObjectContext:(NSManagedObjectContext *)context peopleCount:(NSInteger)peopleCount {
    for (NSInteger personIndex = 0; personIndex < peopleCount; personIndex++) {
        [self addNewRandomPersonWithManagedObjectContext:context];
    }
}

#pragma mark - Private helpers

+ (void)addNewRandomPersonWithManagedObjectContext:(NSManagedObjectContext *)context {
    PersonMO *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    person.firstName = [self randomFirstName];
    person.lastName = [self randomLastName];
    person.dateOfBirth = [self randomDateOfBirth];
    person.passport = [self randomPassportInManagedObjectContext:context];
    NSInteger numberOfCars = [self randomNumberOfCars];
    for (NSInteger carIndex = 0; carIndex < numberOfCars; carIndex++) {
        [person addCarsObject:[self randomCarInManagedObjectContext:context]];
    }
    person.address = [self randomAddressInManagedObjectContext:context];
    [self addRandomFriendsTo:person withContext:context];
    [context save:nil];
}

+ (id)randomObjectFromArray:(NSArray *)array {
    NSInteger count = array.count;
    if (count == 0) {
        return nil;
    }
    NSInteger randomIndex = arc4random() % count;
    return [array objectAtIndex:randomIndex];
}

+ (NSInteger)randomNumberBetween:(NSInteger)from and:(NSInteger)to {
    NSInteger randomNumber = arc4random() % (to - from) + 1;
    return from + randomNumber;
}

+ (BOOL)trueWithProbability:(CGFloat)probability {
    NSInteger randomNumber = arc4random();
    return randomNumber < probability * UINT32_MAX;
}

+ (NSString *)randomNameWithLengthBetween:(NSInteger)from and:(NSInteger)to {
    NSInteger nameLength = [self randomNumberBetween:5 and:9];
    NSMutableString *randomName = [NSMutableString stringWithCapacity:nameLength];
    for (NSInteger i = 0; i < nameLength; i++) {
        unichar nextLetter = [self trueWithProbability:0.6] ? [self randomConsonant] : [self randomVowel];
        [randomName appendFormat:@"%C", nextLetter];
    }
    
    return [randomName capitalizedString];
}

+ (unichar)randomVowel {
    return [self randomCharFromString:@"aeiou"];
}

+ (unichar)randomConsonant {
    return [self randomCharFromString:@"bcdfghjklmnpqrstvwxyz"];
}

+ (unichar)randomDigit {
    return [self randomCharFromString:@"0123456789"];
}

+ (unichar)randomLetter {
    return [self randomCharFromString:@"abcdefghijklmnopqrstuvwxyz"];
}

+ (unichar)randomCharFromString:(NSString *)string {
    return [string characterAtIndex:arc4random_uniform((uint32_t)string.length)];
}

#pragma mark - - Person

+ (NSString *)randomFirstName {
    NSArray *firstNames = @[ @"Emma", @"Noah", @"Olivia", @"Liam", @"Sophia", @"Mason", @"Ava", @"Jacob", @"Isabella", @"William", @"Mia", @"Ethan", @"Abigail", @"James", @"Emily", @"Alexander", @"Charlotte", @"Michael", @"Harper", @"Benjamin", @"Madison", @"Elijah", @"Amelia", @"Daniel", @"Elizabeth", @"Aiden", @"Sofia", @"Logan", @"Evelyn", @"Matthew", @"Avery", @"Lucas", @"Chloe", @"Jackson", @"Ella", @"David", @"Grace", @"Oliver", @"Victoria", @"Jayden", @"Aubrey", @"Joseph", @"Scarlett", @"Gabriel", @"Zoey", @"Samuel", @"Addison", @"Carter", @"Lily", @"Anthony", @"Lillian", @"John", @"Natalie", @"Dylan", @"Hannah", @"Luke", @"Aria", @"Henry", @"Layla", @"Andrew", @"Brooklyn", @"Isaac", @"Alexa", @"Christopher", @"Zoe", @"Joshua", @"Penelope", @"Wyatt", @"Riley", @"Sebastian", @"Leah", @"Owen", @"Audrey", @"Caleb", @"Savannah", @"Nathan", @"Allison", @"Ryan", @"Samantha", @"Jack", @"Nora", @"Hunter", @"Skylar", @"Levi", @"Camila", @"Christian", @"Anna", @"Jaxon", @"Paisley", @"Julian", @"Ariana", @"Landon", @"Ellie", @"Grayson", @"Aaliyah", @"Jonathan", @"Claire", @"Isaiah", @"Violet", @"Charles" ];
    return [self randomObjectFromArray:firstNames];
}

+ (NSString *)randomLastName {
    NSArray *lastNames = @[ @"Smith", @"Johnson", @"Williams", @"Jones", @"Brown", @"Davis", @"Miller", @"Wilson", @"Moore", @"Taylor", @"Anderson", @"Thomas", @"Jackson", @"White", @"Harris", @"Martin", @"Thompson", @"Garcia", @"Martinez", @"Robinson", @"Clark", @"Rodriguez", @"Lewis", @"Lee", @"Walker", @"Hall", @"Allen", @"Young", @"Hernandez", @"King", @"Wright", @"Lopez", @"Hill", @"Scott", @"Green", @"Adams", @"Baker", @"Gonzalez", @"Nelson", @"Carter", @"Mitchell", @"Perez", @"Roberts", @"Turner", @"Phillips", @"Campbell", @"Parker", @"Evans", @"Edwards", @"Collins", @"Stewart", @"Sanchez", @"Morris", @"Rogers", @"Reed", @"Cook", @"Morgan", @"Bell", @"Murphy", @"Bailey", @"Rivera", @"Cooper", @"Richardson", @"Cox", @"Howard", @"Ward", @"Torres", @"Peterson", @"Gray", @"Ramirez", @"James", @"Watson", @"Brooks", @"Kelly", @"Sanders", @"Price", @"Bennett", @"Wood", @"Barnes", @"Ross", @"Henderson", @"Coleman", @"Jenkins", @"Perry", @"Powell", @"Long", @"Patterson", @"Hughes", @"Flores", @"Washington", @"Butler", @"Simmons", @"Foster", @"Gonzales", @"Bryant", @"Alexander", @"Russell", @"Griffin", @"Diaz", @"Hayes" ];
    return [self randomObjectFromArray:lastNames];
}

+ (NSDate *)randomDateOfBirth {
    NSInteger randomNumberOfSecondsFromBirth = [self randomNumberBetween:18 * DBCoreDataRandomDataGeneratorSecondsInAYear
                                                                     and:90 * DBCoreDataRandomDataGeneratorSecondsInAYear];
    return [NSDate dateWithTimeIntervalSinceNow:-randomNumberOfSecondsFromBirth];
}

+ (NSInteger)randomNumberOfCars {
    BOOL hasOneCar = [self trueWithProbability:0.8];
    BOOL hasTwoCars = [self trueWithProbability:0.1];
    return hasTwoCars ? 2 : (hasOneCar ? 1 : 0);
}

+ (void)addRandomFriendsTo:(PersonMO *)person withContext:(NSManagedObjectContext *)context {
    NSInteger friendsCount = [self randomNumberBetween:3 and:8];
    NSFetchRequest *fetchRequest = [PersonMO fetchRequest];
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    if (results.count == 0) {
        return;
    }
    for (NSInteger friendIndex = 0; friendIndex < friendsCount; friendIndex++) {
        PersonMO *friend = [self randomObjectFromArray:results];
        if (friend != person) {
            [person addFriendsObject:friend];
        }
    }
}

#pragma mark - - Passport

+ (PassportMO *)randomPassportInManagedObjectContext:(NSManagedObjectContext *)context {
    PassportMO *passport = [NSEntityDescription insertNewObjectForEntityForName:@"Passport" inManagedObjectContext:context];
    passport.number = [self randomPassportNumber];
    passport.dateOfIssue = [self randomDateOfIssue];
    return passport;
}

+ (NSDate *)randomDateOfIssue {
    NSInteger randomNumberOfSecondsFromIssuing = [self randomNumberBetween:1 * DBCoreDataRandomDataGeneratorSecondsInAYear
                                                                       and:5 * DBCoreDataRandomDataGeneratorSecondsInAYear];
    return [NSDate dateWithTimeIntervalSinceNow:-randomNumberOfSecondsFromIssuing];
}

+ (NSInteger)randomPassportNumber {
    return [self randomNumberBetween:100000000
                                 and:999999999];
}

#pragma mark - - Car

+ (CarMO *)randomCarInManagedObjectContext:(NSManagedObjectContext *)context {
    BOOL shouldUseExistingCar = [self trueWithProbability:0.02];
    if (shouldUseExistingCar) {
        NSFetchRequest *request = [CarMO fetchRequest];
        NSArray *results = [context executeFetchRequest:request error:nil];
        if (results.count == 0) {
            return [self newRandomCarInManagedObjectContext:context];
        } else {
            return [self randomObjectFromArray:results];
        }
    } else {
        return [self newRandomCarInManagedObjectContext:context];
    }
}

+ (CarMO *)newRandomCarInManagedObjectContext:(NSManagedObjectContext *)context {
    CarMO *car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:context];
    car.color = [self randomCarColor];
    car.hasAirConditioning = [self trueWithProbability:0.7];
    car.plateNumber = [self randomPlateNumber];
    car.modelYear = [self randomNumberBetween:1990 and:2016];
    car.numberOfDoors = [self randomNumberBetween:2 and:5];
    car.manufacturer = [self randomCarManufacturer];
    return car;
}

+ (NSString *)randomCarColor {
    NSArray *colors = @[ @"Red", @"Green", @"Blue", @"Yellow", @"Gold", @"Silver", @"Black", @"White", @"Purple", @"Pink", @"Brown", @"Grey" ];
    return [self randomObjectFromArray:colors];
}

+ (NSString *)randomPlateNumber {
    NSMutableString *randomName = [NSMutableString stringWithCapacity:6];
    for (NSInteger i = 0; i < 3; i++) {
        [randomName appendFormat:@"%C", [self randomLetter]];
    }
    for (NSInteger i = 0; i < 3; i++) {
        [randomName appendFormat:@"%C", [self randomDigit]];
    }
    
    return [randomName uppercaseString];
}

+ (NSString *)randomCarManufacturer {
    NSArray *manufactorers = @[ @"Honda", @"Toyota", @"BMW", @"Volkswagen", @"Ford", @"Fiat", @"Citroën", @"Renault", @"Seat", @"Chrysler", @"Chevrolet", @"Mercedes-Benz", @"Opel", @"Porsche", @"Audi", @"Peugeot", @"Dodge" ];
    return [self randomObjectFromArray:manufactorers];
}

#pragma mark - - Address

+ (AddressMO *)randomAddressInManagedObjectContext:(NSManagedObjectContext *)context {
    BOOL shouldUseExistingAddress = [self trueWithProbability:0.04];
    if (shouldUseExistingAddress) {
        NSFetchRequest *request = [AddressMO fetchRequest];
        NSArray *results = [context executeFetchRequest:request error:nil];
        if (results.count == 0) {
            return [self newRandomAddressInManagedObjectContext:context];
        } else {
            return [self randomObjectFromArray:results];
        }
    } else {
        return [self newRandomAddressInManagedObjectContext:context];
    }
}

+ (AddressMO *)newRandomAddressInManagedObjectContext:(NSManagedObjectContext *)context {
    AddressMO *address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:context];
    address.postcode = [self randomPostcode];
    address.city = [self randomCity];
    address.state = [self randomState];
    address.street = [self randomStreet];
    return address;
}

+ (NSString *)randomPostcode {
    return [NSString stringWithFormat:@"%ld", (long)[self randomNumberBetween:10000 and:99999]];
}

+ (NSString *)randomCity {
    return [self randomNameWithLengthBetween:5 and:10];
}

+ (NSString *)randomState {
    NSArray *states = @[ @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming" ];
    return [self randomObjectFromArray:states];
}

+ (NSString *)randomStreet {
    NSString *prefix = [self randomNameWithLengthBetween:5 and:8].capitalizedString;
    NSArray *suffixes = @[ @"Street", @"Lane", @"Drive", @"Avenue", @"Road", @"Court" ];
    return [NSString stringWithFormat:@"%@ %@", prefix, [self randomObjectFromArray:suffixes]];
}

@end
