//
//  DBTitleValueTableViewCellDataSource.h
//  Pods
//
//  Created by Dariusz Bukowski on 31.01.2017.
//
//

#import <Foundation/Foundation.h>

@interface DBTitleValueTableViewCellDataSource : NSObject

+ (instancetype)dataSourceWithTitle:(NSString *)title value:(NSString *)value;

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) NSString *value;

@end
