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

#import "DBCrashReport.h"

static NSString *const DBCrashReportNameKey = @"name";
static NSString *const DBCrashReportReasonKey = @"reason";
static NSString *const DBCrashReportUserInfoKey = @"userInfo";
static NSString *const DBCrashReportCallStackSymbolsKey = @"callStackSymbols";
static NSString *const DBCrashReportDateKey = @"date";
static NSString *const DBCrashReportConsoleOutputKey = @"consoleOutput";
static NSString *const DBCrashReportScreenshotKey = @"screenshot";
static NSString *const DBCrashReportSystemVersionKey = @"systemVersion";
static NSString *const DBCrashReportAppVersionKey = @"appVersion";

@interface DBCrashReport ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, copy) NSArray<NSString *> *callStackSymbols;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *consoleOutput;
@property (nonatomic, strong) UIImage *screenshot;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic, copy) NSString *appVersion;

@end

@implementation DBCrashReport

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[DBCrashReportNameKey];
        self.reason = dictionary[DBCrashReportReasonKey];
        self.userInfo = dictionary[DBCrashReportUserInfoKey];
        self.callStackSymbols = dictionary[DBCrashReportCallStackSymbolsKey];
        self.date = dictionary[DBCrashReportDateKey];
        self.consoleOutput = dictionary[DBCrashReportConsoleOutputKey];
        self.systemVersion = dictionary[DBCrashReportSystemVersionKey];
        self.appVersion = dictionary[DBCrashReportAppVersionKey];
        if (dictionary[DBCrashReportScreenshotKey]) {
            NSData *screenshotData = [[NSData alloc] initWithBase64EncodedString:dictionary[DBCrashReportScreenshotKey]
                                                                         options:NSDataBase64DecodingIgnoreUnknownCharacters];
            self.screenshot = [UIImage imageWithData:screenshotData];
        }
    }

    return self;
}

- (instancetype)initWithName:(NSString *)name
                      reason:(NSString *)reason
                    userInfo:(NSDictionary *)userInfo
            callStackSymbols:(NSArray<NSString *> *)callStackSymbols
                        date:(NSDate *)date
               consoleOutput:(NSString *)consoleOutput
                  screenshot:(UIImage *)screenshot
               systemVersion:(NSString *)systemVersion
                  appVersion:(NSString *)appVersion {
    self = [super init];
    if (self) {
        self.name = name;
        self.reason = reason;
        self.userInfo = userInfo;
        self.callStackSymbols = callStackSymbols;
        self.date = date;
        self.consoleOutput = consoleOutput;
        self.screenshot = screenshot;
        self.systemVersion = systemVersion;
        self.appVersion = appVersion;
    }

    return self;
}

#pragma mark - Dictionary representation

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.name) {
        dictionary[DBCrashReportNameKey] = self.name;
    }
    if (self.reason) {
        dictionary[DBCrashReportReasonKey] = self.reason;
    }
    if (self.userInfo) {
        dictionary[DBCrashReportUserInfoKey] = self.userInfo;
    }
    if (self.callStackSymbols) {
        dictionary[DBCrashReportCallStackSymbolsKey] = self.callStackSymbols;
    }
    if (self.date) {
        dictionary[DBCrashReportDateKey] = self.date;
    }
    if (self.consoleOutput) {
        dictionary[DBCrashReportConsoleOutputKey] = self.consoleOutput;
    }
    if (self.screenshot) {
        NSData *imageData = UIImagePNGRepresentation(self.screenshot);
        dictionary[DBCrashReportScreenshotKey] = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    if (self.systemVersion) {
        dictionary[DBCrashReportSystemVersionKey] = self.systemVersion;
    }
    if (self.appVersion) {
        dictionary[DBCrashReportAppVersionKey] = self.appVersion;
    }

    return [dictionary copy];
}

- (NSString *)dateString {
    return [NSDateFormatter localizedStringFromDate:self.date
                                          dateStyle:NSDateFormatterMediumStyle
                                          timeStyle:NSDateFormatterMediumStyle];
}

@end
