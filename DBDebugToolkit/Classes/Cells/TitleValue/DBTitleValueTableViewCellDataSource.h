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

#import <Foundation/Foundation.h>

/**
 `DBTitleValueTableViewCellDataSource` is a simple object containing all the data needed for `DBTitleValueTableViewCell` instance configuration.
 */
@interface DBTitleValueTableViewCellDataSource : NSObject

/**
 Creates and returns a new `DBTitleValueTableViewCellDataSource` instance with provided title and value.
 
 @param title Title string.
 @param value Value string.
 */
+ (instancetype)dataSourceWithTitle:(NSString *)title value:(NSString *)value;

/**
 `NSString` object containing the title.
 */
@property (nonatomic, readonly) NSString *title;

/**
 `NSString` object containing the value.
 */
@property (nonatomic, readonly) NSString *value;

@end
