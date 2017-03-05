//
//  DBCoreDataFilterOperator.h
//  Pods
//
//  Created by Dariusz Bukowski on 04.03.2017.
//
//

#import <Foundation/Foundation.h>

@interface DBCoreDataFilterOperator : NSObject

+ (instancetype)filterOperatorWithDisplayName:(NSString *)displayName predicateString:(NSString *)predicateString;

@property (nonatomic, readonly) NSString *displayName;

@property (nonatomic, readonly) NSString *predicateString;

@end
