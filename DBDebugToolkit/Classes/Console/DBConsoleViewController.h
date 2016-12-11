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

#import <UIKit/UIKit.h>
#import "DBConsoleOutputCaptor.h"
#import "DBBuildInfoProvider.h"
#import "DBDeviceInfoProvider.h"

/**
 `DBConsoleViewController` is a view controller that presents the captured console output in a text view.
 It also has two buttons on the navigation bar. One clears the captured output and the other send the output by email  along with the device information.
 */
@interface DBConsoleViewController : UIViewController

/**
 `DBConsoleOutputCaptor` instance that will provide data displayed in a text view.
 */
@property (nonatomic, strong) DBConsoleOutputCaptor *consoleOutputCaptor;

/**
 `DBBuildInfoProvider` instance providing build information displayed in the email subject.
 */
@property (nonatomic, strong) DBBuildInfoProvider *buildInfoProvider;

/**
 `DBDeviceInfoProvider` instance providing device information displayed in the email body.
 */
@property (nonatomic, strong) DBDeviceInfoProvider *deviceInfoProvider;

@end
