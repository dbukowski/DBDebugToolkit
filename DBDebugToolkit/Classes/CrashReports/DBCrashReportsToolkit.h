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
#import "DBCrashReport.h"
#import "DBConsoleOutputCaptor.h"
#import "DBBuildInfoProvider.h"
#import "DBDeviceInfoProvider.h"

/**
 `DBCrashReportsToolkit` is a class responsible for collecting crash reports.
 */
@interface DBCrashReportsToolkit : NSObject

/**
 Returns the singleton instance.
 */
+ (instancetype)sharedInstance;

/**
 Enables reporting crashes.
 */
- (void)setupCrashReporting;

/**
 Removes the crash reports.
 */
- (void)clearCrashReports;

/**
 Returns an array containing all the collected crash reports.
 */
- (NSArray <DBCrashReport *> *)crashReports;

/**
 `DBConsoleOutputCaptor` instance providing console output attached to crash reports.
 */
@property (nonatomic, strong) DBConsoleOutputCaptor *consoleOutputCaptor;

/**
 `DBBuildInfoProvider` instance providing build information attached to crash reports.
 */
@property (nonatomic, strong) DBBuildInfoProvider *buildInfoProvider;

/**
 `DBDeviceInfoProvider` instance providing device information attached to crash reports.
 */
@property (nonatomic, strong) DBDeviceInfoProvider *deviceInfoProvider;

/**
 Boolean variable determining whether the crash reporting is enabled or not. It is false by default.
 */
@property (nonatomic, readonly) BOOL isCrashReportingEnabled;

@end
