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

#import "DBCrashReportsToolkit.h"
#import "UIView+Snapshot.h"

typedef void (*sighandler_t)(int);

static NSUncaughtExceptionHandler *_previousUncaughtExceptionHandler;
static sighandler_t _previousSIGABRTHandler;
static sighandler_t _previousSIGILLHandler;
static sighandler_t _previousSIGSEGVHandler;
static sighandler_t _previousSIGFPEHandler;
static sighandler_t _previousSIGBUSHandler;
static sighandler_t _previousSIGPIPEHandler;

@interface DBCrashReportsToolkit ()

@property (nonatomic, strong) NSArray <DBCrashReport *> *crashReports;

@end

@implementation DBCrashReportsToolkit

#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static DBCrashReportsToolkit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBCrashReportsToolkit alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Crash reporting

- (NSString *)crashReportsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"DBDebugToolkit/CrashReports"];
}

- (NSString *)filePathWithCrashReport:(DBCrashReport *)crashReport {
    return [[self crashReportsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lf", crashReport.date.timeIntervalSince1970]];
}

- (void)clearCrashReports {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [self crashReportsPath];
    NSError *error = nil;
    for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
        NSString *filePath = [directory stringByAppendingPathComponent:file];
        [fileManager removeItemAtPath:filePath error:&error];
    }
    self.crashReports = [NSArray array];
}

- (NSArray <DBCrashReport *> *)crashReports {
    if (!_crashReports) {
        NSMutableArray *crashReports = [NSMutableArray array];
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self crashReportsPath] error:NULL];
        for (NSString *fileName in directoryContent) {
            NSString *filePath = [[self crashReportsPath] stringByAppendingPathComponent:fileName];
            NSDictionary *dictionaryRepresentation = [NSDictionary dictionaryWithContentsOfFile:filePath];
            DBCrashReport *crashReport = [[DBCrashReport alloc] initWithDictionary:dictionaryRepresentation];
            [crashReports addObject:crashReport];
        }
        _crashReports = [crashReports sortedArrayUsingComparator:^NSComparisonResult(DBCrashReport *cr1, DBCrashReport *cr2) {
            return cr1.date < cr2.date;
        }];
    }

    return _crashReports;
}

- (void)setupCrashReporting {
    // Uncaught exceptions
    _previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&handleException);

    // SIGABRT signal
    _previousSIGABRTHandler = signal(SIGABRT, SIG_IGN);
    signal(SIGABRT, handleSIGABRTSignal);

    // SIGSEGV signal
    _previousSIGSEGVHandler = signal(SIGSEGV, SIG_IGN);
    signal(SIGSEGV, handleSIGSEGVSignal);

    // SIGILL signal
    _previousSIGILLHandler = signal(SIGILL, SIG_IGN);
    signal(SIGILL, handleSIGILLSignal);

    // SIGFPE signal
    _previousSIGFPEHandler = signal(SIGFPE, SIG_IGN);
    signal(SIGFPE, handleSIGFPESignal);

    // SIGBUS signal
    _previousSIGBUSHandler = signal(SIGBUS, SIG_IGN);
    signal(SIGBUS, handleSIGBUSSignal);

    // SIGPIPE signal
    _previousSIGPIPEHandler = signal(SIGPIPE, SIG_IGN);
    signal(SIGPIPE, handleSIGPIPESignal);
}

void stopCrashReporting() {
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
}

void handleException(NSException *exception) {
    [[DBCrashReportsToolkit sharedInstance] saveCrashReportWithName:exception.name
                                                             reason:exception.reason
                                                           userInfo:exception.userInfo
                                                   callStackSymbols:exception.callStackSymbols];
    if (_previousUncaughtExceptionHandler != NULL) {
        _previousUncaughtExceptionHandler(exception);
    }
    stopCrashReporting();
    [exception raise];
}

static void handleSIGABRTSignal(int sig) {
    [[DBCrashReportsToolkit sharedInstance] saveCrashReportWithName:@"SIGABRT signal"
                                                             reason:nil
                                                           userInfo:nil
                                                   callStackSymbols:[NSThread callStackSymbols]];
    if (_previousSIGABRTHandler != NULL) {
        _previousSIGABRTHandler(sig);
    }
    stopCrashReporting();
    kill(getpid(), sig);
}

static void handleSIGILLSignal(int sig) {
    [[DBCrashReportsToolkit sharedInstance] saveCrashReportWithName:@"SIGILL signal"
                                                             reason:nil
                                                           userInfo:nil
                                                   callStackSymbols:[NSThread callStackSymbols]];
    if (_previousSIGILLHandler != NULL) {
        _previousSIGILLHandler(sig);
    }
    stopCrashReporting();
    kill(getpid(), sig);
}

static void handleSIGSEGVSignal(int sig) {
    [[DBCrashReportsToolkit sharedInstance] saveCrashReportWithName:@"SIGSEGV signal"
                                                             reason:nil
                                                           userInfo:nil
                                                   callStackSymbols:[NSThread callStackSymbols]];
    if (_previousSIGSEGVHandler != NULL) {
        _previousSIGSEGVHandler(sig);
    }
    stopCrashReporting();
    kill(getpid(), sig);
}

static void handleSIGFPESignal(int sig) {
    [[DBCrashReportsToolkit sharedInstance] saveCrashReportWithName:@"SIGFPE signal"
                                                             reason:nil
                                                           userInfo:nil
                                                   callStackSymbols:[NSThread callStackSymbols]];
    if (_previousSIGFPEHandler != NULL) {
        _previousSIGFPEHandler(sig);
    }
    stopCrashReporting();
    kill(getpid(), sig);
}

static void handleSIGBUSSignal(int sig) {
    [[DBCrashReportsToolkit sharedInstance] saveCrashReportWithName:@"SIGBUS signal"
                                                             reason:nil
                                                           userInfo:nil
                                                   callStackSymbols:[NSThread callStackSymbols]];
    if (_previousSIGBUSHandler != NULL) {
        _previousSIGBUSHandler(sig);
    }
    stopCrashReporting();
    kill(getpid(), sig);
}

static void handleSIGPIPESignal(int sig) {
    [[DBCrashReportsToolkit sharedInstance] saveCrashReportWithName:@"SIGPIPE signal"
                                                             reason:nil
                                                           userInfo:nil
                                                   callStackSymbols:[NSThread callStackSymbols]];
    if (_previousSIGPIPEHandler != NULL) {
        _previousSIGPIPEHandler(sig);
    }
    stopCrashReporting();
    kill(getpid(), sig);
}

#pragma mark - Private methods

- (void)saveCrashReportWithName:(NSString *)name
                         reason:(NSString *)reason
                       userInfo:(NSDictionary *)userInfo
               callStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    NSDate *date = [NSDate date];
    NSString *consoleOutput = self.consoleOutputCaptor.consoleOutput;
    UIImage *screenshot = [[UIApplication sharedApplication].keyWindow snapshot];
    NSString *systemVersion = [self.deviceInfoProvider systemVersion];
    NSString *appVersion = [self.buildInfoProvider buildInfoString];
    DBCrashReport *crashReport = [[DBCrashReport alloc] initWithName:name
                                                              reason:reason
                                                            userInfo:userInfo
                                                    callStackSymbols:callStackSymbols
                                                                date:date
                                                       consoleOutput:consoleOutput
                                                          screenshot:screenshot
                                                       systemVersion:systemVersion
                                                          appVersion:appVersion];
    NSDictionary *dictionaryRepresentation = [crashReport dictionaryRepresentation];
    NSString *filePath = [self filePathWithCrashReport:crashReport];
    [[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent]
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    [dictionaryRepresentation writeToFile:filePath atomically:YES];
}

@end
