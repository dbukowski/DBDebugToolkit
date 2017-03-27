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

#import "DBConsoleOutputCaptor.h"

__strong static NSThread *stderrReadingThread = nil;

typedef int File_Writer_t(void *, const char *, int);

@interface DBConsoleOutputCaptor ()

@property (nonatomic, strong) NSString *consoleOutput;

@property (nonatomic, assign) File_Writer_t *originalStdoutWriter;

@property (nonatomic, assign) int originalStderrFileDescriptor;
@property (nonatomic, strong) NSPipe *stderrPipe;
@property (nonatomic, strong) NSFileHandle *stderrPipeReadHandle;

@end

@implementation DBConsoleOutputCaptor

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _consoleOutput = [NSString string];
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static DBConsoleOutputCaptor *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBConsoleOutputCaptor alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc {
    [self stopCapturingConsoleOutput];
}

#pragma mark - Capturing console output

- (void)startCapturingConsoleOutput {
    [self performSelector:@selector(startCapturingStderr) onThread:stderrReadingThread withObject:nil waitUntilDone:NO];
    [self startCapturingStdout];
}

- (void)stopCapturingConsoleOutput {
    [self stopCapturingStderr];
    [self stopCapturingStdout];
}

- (void)appendConsoleOutput:(NSString *)consoleOutput {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.consoleOutput = [self.consoleOutput stringByAppendingString:(consoleOutput ?: @"")];
        [self.delegate consoleOutputCaptorDidUpdateOutput:self];
    });
}

- (void)setEnabled:(BOOL)enabled {
    if (_enabled != enabled) {
        _enabled = enabled;
        if (enabled) {
            [self startCapturingConsoleOutput];
        } else {
            [self stopCapturingConsoleOutput];
            self.consoleOutput = [NSString string];
            [self.delegate consoleOutputCaptorDidUpdateOutput:self];
        }
        [self.delegate consoleOutputCaptor:self didSetEnabled:enabled];
    }
}

#pragma mark - Stderr reading thread

+ (void)load {
    stderrReadingThread = [[NSThread alloc] initWithTarget:self selector:@selector(runStderrReadingThread) object:nil];
    [stderrReadingThread start];
}

+ (void)runStderrReadingThread {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"DBDebugToolkit stderr reading thread"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

#pragma mark - Stderr

- (void)startCapturingStderr {
    self.originalStderrFileDescriptor = dup(fileno(stderr));
    self.stderrPipe = [NSPipe pipe];
    self.stderrPipeReadHandle = self.stderrPipe.fileHandleForReading;
    dup2(self.stderrPipe.fileHandleForWriting.fileDescriptor, fileno(stderr));
    close(self.stderrPipe.fileHandleForWriting.fileDescriptor); // Close unused file handle.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stderrCaptureNotification:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:self.stderrPipeReadHandle];
    [self.stderrPipeReadHandle readInBackgroundAndNotify];
}

- (void)stopCapturingStderr {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dup2(self.originalStderrFileDescriptor, fileno(stderr));
}

- (void)stderrCaptureNotification:(NSNotification *)notification {
    NSData *writtenData = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *writtenString = [[NSString alloc] initWithData:writtenData encoding:NSASCIIStringEncoding];
    write(self.originalStderrFileDescriptor, writtenData.bytes, writtenData.length);
    [self appendConsoleOutput:writtenString];
    [self.stderrPipeReadHandle readInBackgroundAndNotify]; // Continue reading.
}

#pragma mark - Stdout

- (void)startCapturingStdout {
    self.originalStdoutWriter = stdout->_write;
    stdout->_write = &capturingStdoutWriter;
}

- (void)stopCapturingStdout {
    stdout->_write = self.originalStdoutWriter;
}

static int capturingStdoutWriter(void *inFD, const char *buffer, int size) {
    DBConsoleOutputCaptor *consoleOutputCaptor = [DBConsoleOutputCaptor sharedInstance];
    consoleOutputCaptor.originalStdoutWriter(inFD, buffer, size); // Run original implementation.
    NSString *writtenString = [[NSString alloc] initWithBytes:buffer length:size encoding:NSUTF8StringEncoding];
    [consoleOutputCaptor appendConsoleOutput:writtenString];
    return size;
}

#pragma mark - Clearing console output

- (void)clearConsoleOutput {
    self.consoleOutput = [NSString string];
    [self.delegate consoleOutputCaptorDidUpdateOutput:self];
}

@end
