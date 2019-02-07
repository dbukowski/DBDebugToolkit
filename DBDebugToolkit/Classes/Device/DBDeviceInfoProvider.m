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

#import "DBDeviceInfoProvider.h"
#import <sys/utsname.h>

@implementation DBDeviceInfoProvider

// Based on the list provided in https://github.com/dennisweissmann/DeviceKit
// DeviceKit is a value-type replacement of UIDevice created by Dennis Weissmann.
- (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModelCode = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceModelCode isEqualToString:@"iPod5,1"]) {
        return @"iPod Touch 5";
    } else if ([deviceModelCode isEqualToString:@"iPod7,1"]) {
        return @"iPod Touch 6";
    } else if ([deviceModelCode isEqualToString:@"iPhone3,1"] || [deviceModelCode isEqualToString:@"iPhone3,2"] || [deviceModelCode isEqualToString:@"iPhone3,3"]) {
        return @"iPhone 4";
    } else if ([deviceModelCode isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4s";
    } else if ([deviceModelCode isEqualToString:@"iPhone5,1"] || [deviceModelCode isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5";
    } else if ([deviceModelCode isEqualToString:@"iPhone5,3"] || [deviceModelCode isEqualToString:@"iPhone5,4"]) {
        return @"iPhone 5c";
    } else if ([deviceModelCode isEqualToString:@"iPhone6,1"] || [deviceModelCode isEqualToString:@"iPhone6,2"]) {
        return @"iPhone 5s";
    } else if ([deviceModelCode isEqualToString:@"iPhone7,2"]) {
        return @"iPhone 6";
    } else if ([deviceModelCode isEqualToString:@"iPhone7,1"]) {
        return @"iPhone 6 Plus";
    } else if ([deviceModelCode isEqualToString:@"iPhone8,1"]) {
        return @"iPhone 6s";
    } else if ([deviceModelCode isEqualToString:@"iPhone8,2"]) {
        return @"iPhone 6s Plus";
    } else if ([deviceModelCode isEqualToString:@"iPhone9,1"] || [deviceModelCode isEqualToString:@"iPhone9,3"]) {
        return @"iPhone 7";
    } else if ([deviceModelCode isEqualToString:@"iPhone9,2"] || [deviceModelCode isEqualToString:@"iPhone9,4"]) {
        return @"iPhone 7 Plus";
    } else if ([deviceModelCode isEqualToString:@"iPhone8,4"]) {
        return @"iPhone SE";
    } else if ([deviceModelCode isEqualToString:@"iPhone10,1"] || [deviceModelCode isEqualToString:@"iPhone10,4"]) {
        return @"iPhone 8";
    } else if ([deviceModelCode isEqualToString:@"iPhone10,2"] || [deviceModelCode isEqualToString:@"iPhone10,5"]) {
        return @"iPhone 8 Plus";
    } else if ([deviceModelCode isEqualToString:@"iPhone10,3"] || [deviceModelCode isEqualToString:@"iPhone10,6"]) {
        return @"iPhone X";
    } else if ([deviceModelCode isEqualToString:@"iPhone11,2"]) {
        return @"iPhone XS";
    } else if ([deviceModelCode isEqualToString:@"iPhone11,4"] || [deviceModelCode isEqualToString:@"iPhone11,6"]) {
        return @"iPhone XS Max";
    } else if ([deviceModelCode isEqualToString:@"iPhone11,8"]) {
        return @"iPhone XR";
    } else if ([deviceModelCode isEqualToString:@"iPad2,1"] || [deviceModelCode isEqualToString:@"iPad2,2"] || [deviceModelCode isEqualToString:@"iPad2,3"] || [deviceModelCode isEqualToString:@"iPad2,4"]) {
        return @"iPad 2";
    } else if ([deviceModelCode isEqualToString:@"iPad3,1"] || [deviceModelCode isEqualToString:@"iPad3,2"] || [deviceModelCode isEqualToString:@"iPad3,3"]) {
        return @"iPad 3";
    } else if ([deviceModelCode isEqualToString:@"iPad3,4"] || [deviceModelCode isEqualToString:@"iPad3,5"] || [deviceModelCode isEqualToString:@"iPad3,6"]) {
        return @"iPad 4";
    } else if ([deviceModelCode isEqualToString:@"iPad4,1"] || [deviceModelCode isEqualToString:@"iPad4,2"] || [deviceModelCode isEqualToString:@"iPad4,3"]) {
        return @"iPad Air";
    } else if ([deviceModelCode isEqualToString:@"iPad5,3"] || [deviceModelCode isEqualToString:@"iPad5,4"]) {
        return @"iPad Air 2";
    } else if ([deviceModelCode isEqualToString:@"iPad6,11"] || [deviceModelCode isEqualToString:@"iPad6,12"] || [deviceModelCode isEqualToString:@"iPad3,3"]) {
        return @"iPad 5";
    } else if ([deviceModelCode isEqualToString:@"iPad7,5"] || [deviceModelCode isEqualToString:@"iPad7,6"] || [deviceModelCode isEqualToString:@"iPad3,6"]) {
        return @"iPad 6";
    } else if ([deviceModelCode isEqualToString:@"iPad2,5"] || [deviceModelCode isEqualToString:@"iPad2,6"] || [deviceModelCode isEqualToString:@"iPad2,7"]) {
        return @"iPad Mini";
    } else if ([deviceModelCode isEqualToString:@"iPad4,4"] || [deviceModelCode isEqualToString:@"iPad4,5"] || [deviceModelCode isEqualToString:@"iPad4,6"]) {
        return @"iPad Mini 2";
    } else if ([deviceModelCode isEqualToString:@"iPad4,7"] || [deviceModelCode isEqualToString:@"iPad4,8"] || [deviceModelCode isEqualToString:@"iPad4,9"]) {
        return @"iPad Mini 3";
    } else if ([deviceModelCode isEqualToString:@"iPad5,1"] || [deviceModelCode isEqualToString:@"iPad5,2"]) {
        return @"iPad Mini 4";
    } else if ([deviceModelCode isEqualToString:@"iPad6,3"] || [deviceModelCode isEqualToString:@"iPad6,4"]) {
        return @"iPad Pro (9.7-inch)";
    } else if ([deviceModelCode isEqualToString:@"iPad6,7"] || [deviceModelCode isEqualToString:@"iPad6,8"]) {
        return @"iPad Pro (12.9-inch)";
    } else if ([deviceModelCode isEqualToString:@"iPad7,1"] || [deviceModelCode isEqualToString:@"iPad7,2"]) {
        return @"iPad Pro (12.9-inch) 2";
    } else if ([deviceModelCode isEqualToString:@"iPad7,3"] || [deviceModelCode isEqualToString:@"iPad7,4"]) {
        return @"iPad Pro (10.5-inch)";
    } else if ([deviceModelCode isEqualToString:@"iPad8,1"] || [deviceModelCode isEqualToString:@"iPad8,2"] || [deviceModelCode isEqualToString:@"iPad8,3"] || [deviceModelCode isEqualToString:@"iPad8,4"]) {
        return @"iPad Pro (11-inch)";
    } else if ([deviceModelCode isEqualToString:@"iPad8,5"] || [deviceModelCode isEqualToString:@"iPad8,6"] || [deviceModelCode isEqualToString:@"iPad8,7"] || [deviceModelCode isEqualToString:@"iPad8,8"]) {
        return @"iPad Pro (12.9-inch) 3";
    } else if ([deviceModelCode isEqualToString:@"i386"] || [deviceModelCode isEqualToString:@"x86_64"]) {
        return @"Simulator";
    } else {
        return [[UIDevice currentDevice] model];
    }
}

- (NSString *)systemVersion {
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@ %@", [device systemName], [device systemVersion]];
}

- (NSString *)deviceInfoString {
    return [NSString stringWithFormat:@"%@, %@", [self deviceModel], [self systemVersion]];
}

@end
