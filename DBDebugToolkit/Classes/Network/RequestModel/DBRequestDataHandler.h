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
#import <UIKit/UIKit.h>
#import "DBRequestModel.h"

@class DBRequestDataHandler;

/**
 A protocol used for informing about finishing of the data synchronization.
 */
@protocol DBRequestDataHandlerDelegate <NSObject>

/**
 Informs the delegate that the data has finished the synchronization.
 
 @param requestDataHandler The `DBRequestDataHandler` instance that finished the data synchronization.
 */
- (void)requestDataHandlerDidFinishSynchronization:(DBRequestDataHandler *)requestDataHandler;

@end

/**
 `DBRequestDataHandler` is a class handling the request and response body synchronization (saving it to a file).
 */
@interface DBRequestDataHandler : NSObject

/**
 Creates and returns a new instance.
 
 @param filename The string containing the name of the file that will contain the saved data.
 @param data The data that needs to be saved.
 @param shouldGenerateThumbnail The boolean flag determining if the thumbnail generation is needed for this data.
 */
+ (instancetype)dataHandlerWithFilename:(NSString *)filename data:(NSData *)data shouldGenerateThumbnail:(BOOL)shouldGenerateThumbnail;

/**
 Reads the saved data.
 
 @param completion The block that will be called with the read data.
 */
- (void)readWithCompletion:(void(^)(NSData *))completion;

/**
 Recognized type of the data.
 */
@property (nonatomic, readonly) DBRequestModelBodyType dataType;

/**
 Current data synchronization status.
 */
@property (nonatomic, readonly) DBRequestModelBodySynchronizationStatus synchronizationStatus;

/**
 `NSInteger` containing the data length. Should be accessed after finishing the data synchronization.
 */
@property (nonatomic, readonly) NSInteger dataLength;

/**
 `UIImage` instance containing the thumbnail. It is `nil` if the data is not yet synchronized or if the data is not describing an image.
 */
@property (nonatomic, strong) UIImage *thumbnail;

/**
 Delegate that will be informed about finishing the data synchronization. It needs to conform to `DBRequestDataHandlerDelegate` protocol.
 */
@property (nonatomic, weak) id <DBRequestDataHandlerDelegate> delegate;

@end
