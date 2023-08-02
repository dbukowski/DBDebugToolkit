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

@class DBConsoleOutputCaptor;

/**
 A protocol used for informing about changes in the captured output or in the captor state.
 */
@protocol DBConsoleOutputCaptorDelegate <NSObject>

/**
 Informs the delegate that new console output is available.
 
 @param consoleOutputCaptor The captor that updated its console output.
 */
- (void)consoleOutputCaptorDidUpdateOutput:(DBConsoleOutputCaptor *)consoleOutputCaptor;

/**
 Informs the delegate that the captor changed its enabled flag.
 
 @param consoleOutputCaptor The captor that changed its enabled flag.
 @param enabled The new value of enabled flag.
 */
- (void)consoleOutputCaptor:(DBConsoleOutputCaptor *)consoleOutputCaptor didSetEnabled:(BOOL)enabled;

@end

/**
 `DBConsoleOutputCaptor` is a singleton responsible for capturing data from stdout and stderr.
 */
@interface DBConsoleOutputCaptor : NSObject

/**
 Returns the singleton instance.
 */
+ (instancetype)sharedInstance;

/**
 Delegate that will be informed about changes in the available data or in the enabled flag value. It needs to conform to `DBConsoleOutputCaptorDelegate` protocol.
 */
@property (nonatomic, weak) id <DBConsoleOutputCaptorDelegate> delegate;

/**
 `NSString` object containing the captured console output.
 */
@property (nonatomic, readonly) NSString *consoleOutput;

/**
 Boolean variable determining whether the console output capturing is enabled or not. It is true by default.
 */
@property (nonatomic, assign) BOOL enabled;

/**
 Clears the captured console output.
 */
- (void)clearConsoleOutput;

@end
