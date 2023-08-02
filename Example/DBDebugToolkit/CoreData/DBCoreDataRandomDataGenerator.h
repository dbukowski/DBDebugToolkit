//
//  DBCoreDataRandomDataGenerator.h
//  DBDebugToolkit
//
//  Created by Dariusz Bukowski on 05.03.2017.
//  Copyright © 2017 Dariusz Bukowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DBCoreDataRandomDataGenerator : NSObject

+ (void)addNewRandomDataWithManagedObjectContext:(NSManagedObjectContext *)context peopleCount:(NSInteger)peopleCount;

@end
