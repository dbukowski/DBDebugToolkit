// The MIT License
//
// Copyright (c) 2017 Dariusz Bukowski
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

@interface DBCrashReport : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, copy) NSDictionary *userInfo;

@property (nonatomic, copy) NSArray<NSString *> *callStackSymbols;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) NSString *consoleOutput;

@property (nonatomic, strong) UIImage *screenshot;

@property (nonatomic, copy) NSString *systemVersion;

@property (nonatomic, copy) NSString *appVersion;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithName:(NSString *)name
                      reason:(NSString *)reason
                    userInfo:(NSDictionary *)userInfo
            callStackSymbols:(NSArray<NSString *> *)callStackSymbols
                        date:(NSDate *)date
               consoleOutput:(NSString *)consoleOutput
                  screenshot:(UIImage *)screenshot
               systemVersion:(NSString *)systemVersion
                  appVersion:(NSString *)appVersion;

- (NSDictionary *)dictionaryRepresentation;


@end
