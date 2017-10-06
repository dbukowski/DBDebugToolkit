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

/**
 `DBCrashReport` is an object containing all the information about a collected crash.
 */
@interface DBCrashReport : NSObject

/**
 Initializes `DBCrashReport` object with the data contained in a dictionary.

 @param dictionary Dictionary containing all the information about a collected crash.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 Initializes `DBCrashReport` object with the provided data.

 @param name Name of the crash.
 @param reason Reason of the crash.
 @param userInfo User info attached to the crash.
 @param callStackSymbols An array of strings describing the call stack backtrace at the moment of the crash.
 @param date Date of the crash occurence.
 @param consoleOutput String containing the console output at the moment of the crash.
 @param screenshot The screenshot image taken at the moment of the crash.
 @param systemVersion Version of the system installed when the crash occured.
 @param appVersion Version of the application installed when the crash occured.
 */
- (instancetype)initWithName:(NSString *)name
                      reason:(NSString *)reason
                    userInfo:(NSDictionary *)userInfo
            callStackSymbols:(NSArray<NSString *> *)callStackSymbols
                        date:(NSDate *)date
               consoleOutput:(NSString *)consoleOutput
                  screenshot:(UIImage *)screenshot
               systemVersion:(NSString *)systemVersion
                  appVersion:(NSString *)appVersion;

/**
 Returns a dictionary containing all the information about a collected crash.
 */
- (NSDictionary *)dictionaryRepresentation;

/**
 Returns a string containing the date of the crash occurence.
 */
- (NSString *)dateString;

/**
 Name of the crash. Read-only.
 */
@property (nonatomic, readonly) NSString *name;

/**
 Reason of the crash. Read-only.
 */
@property (nonatomic, readonly) NSString *reason;

/**
 User info attached to the crash. Read-only.
 */
@property (nonatomic, readonly) NSDictionary *userInfo;

/**
 An array of strings describing the call stack backtrace at the moment of the crash. Read-only.
 */
@property (nonatomic, readonly) NSArray<NSString *> *callStackSymbols;

/**
 Date of the crash occurence. Read-only.
 */
@property (nonatomic, readonly) NSDate *date;

/**
 String containing the console output at the moment of the crash. Read-only.
 */
@property (nonatomic, readonly) NSString *consoleOutput;

/**
 The screenshot image taken at the moment of the crash. Read-only.
 */
@property (nonatomic, readonly) UIImage *screenshot;

/**
 Version of the system installed when the crash occured. Read-only.
 */
@property (nonatomic, readonly) NSString *systemVersion;

/**
 Version of the application installed when the crash occured. Read-only.
 */
@property (nonatomic, readonly) NSString *appVersion;

@end
