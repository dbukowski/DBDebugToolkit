// The MIT License
//
// Copyright (c) 2016 Dariusz Bukowski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DBCustomAction.h"

@interface DBCustomAction ()

@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, copy, nullable) DBCustomActionBody body;

@end

@implementation DBCustomAction

#pragma mark - Initialization

- (nonnull instancetype)initWithName:(nullable NSString *)name body:(nullable DBCustomActionBody)body {
    self = [super init];
    if (self) {
        self.name = name;
        self.body = body;
    }
    
    return self;
}

+ (nonnull instancetype)customActionWithName:(nullable NSString *)name body:(nullable DBCustomActionBody)body {
    return [[self alloc] initWithName:name body:body];
}

#pragma mark - Performing action

- (void)perform {
    if (self.body) {
        self.body();
    }
}

@end
