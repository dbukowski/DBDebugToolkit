//
//  DBTitleValueTableViewCellDataSource.m
//  Pods
//
//  Created by Dariusz Bukowski on 31.01.2017.
//
//

#import "DBTitleValueTableViewCellDataSource.h"

@interface DBTitleValueTableViewCellDataSource ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;

@end

@implementation DBTitleValueTableViewCellDataSource

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value {
    self = [super init];
    if (self) {
        self.title = title;
        self.value = value;
    }
    
    return self;
}

+ (instancetype)dataSourceWithTitle:(NSString *)title value:(NSString *)value {
    return [[self alloc] initWithTitle:title value:value];
}

@end
