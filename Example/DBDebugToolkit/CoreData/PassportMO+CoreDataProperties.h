//
//  PassportMO+CoreDataProperties.h
//  
//
//  Created by Dariusz Bukowski on 05.03.2017.
//
//  This file was automatically generated and should not be edited.
//

#import "PassportMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PassportMO (CoreDataProperties)

+ (NSFetchRequest<PassportMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateOfIssue;
@property (nonatomic) int64_t number;
@property (nullable, nonatomic, retain) PersonMO *owner;

@end

NS_ASSUME_NONNULL_END
