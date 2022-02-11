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

#import "NSURLSessionDelegateSwizzle.h"
#import "NSObject+DBDebugToolkit.h"
#import "DBNetworkToolkit.h"
#import <Foundation/NSURLSession.h>
#import <objc/message.h>
@import ObjectiveC.runtime;

@implementation NSURLSessionDelegateSwizzle

#pragma mark - Method Swizzling

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self searchDelegateClasses];
        [self swizzleNSURLSessionCompletion];
    });
}

+ (void)searchDelegateClasses {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      const SEL selectors[] = {
          @selector(connectionDidFinishLoading:),
          @selector(connection:willSendRequest:redirectResponse:),
          @selector(connection:didReceiveResponse:),
          @selector(connection:didReceiveData:),
          @selector(connection:didFailWithError:),
          @selector
          (URLSession:
                 task:willPerformHTTPRedirection:newRequest:completionHandler:),
          @selector(URLSession:dataTask:didReceiveData:),
          @selector(URLSession:dataTask:didReceiveResponse:completionHandler:),
          @selector(URLSession:task:didCompleteWithError:),
          @selector(URLSession:dataTask:didBecomeDownloadTask:),
          @selector(URLSession:
                  downloadTask:didWriteData:totalBytesWritten
                              :totalBytesExpectedToWrite:),
          @selector(URLSession:downloadTask:didFinishDownloadingToURL:)
      };

      const int numSelectors = sizeof(selectors) / sizeof(SEL);

      Class *classes = NULL;
      int numClasses = objc_getClassList(NULL, 0);

      if (numClasses > 0) {
          classes =
              (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
          numClasses = objc_getClassList(classes, numClasses);
          for (NSInteger classIndex = 0; classIndex < numClasses;
               ++classIndex) {
              Class className = classes[classIndex];

              if (className == [NSURLSessionDelegateSwizzle class]) {
                  continue;
              }

              unsigned int methodCount = 0;
              Method *methods = class_copyMethodList(className, &methodCount);
              BOOL selectorFound = NO;
              for (unsigned int methodIndex = 0; methodIndex < methodCount;
                   methodIndex++) {
                  for (int selectorIndex = 0; selectorIndex < numSelectors;
                       ++selectorIndex) {
                      if (method_getName(methods[methodIndex]) ==
                          selectors[selectorIndex]) {
                          [self swizzleIntoDelegateClasses:className];
                          selectorFound = YES;
                          break;
                      }
                  }
                  if (selectorFound) {
                      break;
                  }
              }
              free(methods);
          }

          free(classes);
      }
    });
}

+ (void)swizzleIntoDelegateClasses:(Class)className {
    // NSURLSessionTaskDelegate
    [self exchangeMethodsWithOriginalSelector:@selector(dataTaskWithURL:)
                             swizzledSelector:@selector(db_dataTaskWithURL:)
                                    className:className];
    [self exchangeMethodsWithOriginalSelector:@selector(dataTaskWithRequest:)
                             swizzledSelector:@selector(db_dataTaskWithRequest:)
                                    className:className];
    [self exchangeMethodsWithOriginalSelector:@selector(URLSession:dataTask:didReceiveData:)
                             swizzledSelector:@selector(db_URLSession:dataTask:didReceiveData:)
                                    className:className];
    [self exchangeMethodsWithOriginalSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)
                             swizzledSelector:@selector(db_URLSession:dataTask:didReceiveResponse:completionHandler:)
                                    className:className];
    [self exchangeMethodsWithOriginalSelector:@selector(URLSession:task:didCompleteWithError:)
                             swizzledSelector:@selector(db_URLSession:task:didCompleteWithError:)
                                    className:className];
    [self exchangeMethodsWithOriginalSelector:@selector(URLSession:dataTask:willCacheResponse:completionHandler:)
                             swizzledSelector:@selector(db_URLSession:dataTask:willCacheResponse:completionHandler:)
                                    className:className];
}

+ (void)swizzleNSURLSessionCompletion {
    SEL selector = @selector(dataTaskWithRequest:completionHandler:);
    SEL swizzledSelector = @selector(db_dataTaskWithRequest:completionHandler:);

    Class class = [NSURLSession.sharedSession class];
    typedef void (^NSURLSessionCompletion)(
        id dataResponse, NSURLResponse *response, NSError *error);

    typedef NSURLSessionTask * (^NSURLSessionNewMethod)(
        NSURLSession *, NSURLRequest *, NSURLSessionCompletion);

    NSURLSessionNewMethod swizzleBlock =
        ^NSURLSessionTask *(NSURLSession *slf, NSURLRequest *request,
                            NSURLSessionCompletion completion) {
        NSURLSessionCompletion completionWrapper = ^(
            id dataResponse, NSURLResponse *response, NSError *error) {
          [[DBNetworkToolkit sharedInstance] saveRequest:request];
          NSData *data = nil;
          if ([dataResponse isKindOfClass:[NSURL class]]) {
              data = [NSData dataWithContentsOfURL:dataResponse];
          } else if ([dataResponse isKindOfClass:[NSData class]]) {
              data = dataResponse;
          }
          if (error) {
              [[DBNetworkToolkit sharedInstance]
                  saveRequestOutcome:[DBRequestOutcome outcomeWithError:error]
                          forRequest:request];
          } else {
              [[DBNetworkToolkit sharedInstance]
                  saveRequestOutcome:[DBRequestOutcome
                                         outcomeWithResponse:response
                                                        data:data]
                          forRequest:request];
          }
          if (completion) {
              completion(dataResponse, response, error);
          }
        };
        return ((id(*)(id, SEL, id, id))objc_msgSend)(
            slf, swizzledSelector, request, completionWrapper);
    };

    [self exchangeMethodsWithOriginalSelector:selector
                                      onClass:class
                                    withBlock:swizzleBlock
                             swizzledSelector:swizzledSelector];
}

+ (void)exchangeMethodsWithOriginalSelector:(SEL)originalSelector
                                    onClass:(Class)class
                                  withBlock:(id)block
                           swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!originalMethod) {
        return;
    }

    IMP implementation = imp_implementationWithBlock(block);
    class_addMethod(class, swizzledSelector, implementation, method_getTypeEncoding(originalMethod));
    Method newMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, newMethod);
}

+ (void)exchangeMethodsWithOriginalSelector:(SEL)originalSelector
                           swizzledSelector:(SEL)swizzledSelector
                                  className:(Class)className
{
    Class class = className;
    Class swizzleClass = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzleClass, swizzledSelector);

    IMP originalImp = method_getImplementation(originalMethod);
    IMP swizzledImp = method_getImplementation(swizzledMethod);

    class_replaceMethod(class,
            swizzledSelector,
            originalImp,
            method_getTypeEncoding(originalMethod));

    class_replaceMethod(class,
                  originalSelector,
                  swizzledImp,
                  method_getTypeEncoding(swizzledMethod));
}

+ (IMP)replaceMethodWithSelector:(SEL)originalSelector block:(id)block className:(Class)className {
    NSCParameterAssert(block);

    Method originalMethod = class_getInstanceMethod(className, originalSelector);
    NSCParameterAssert(originalMethod);

    IMP newIMP = imp_implementationWithBlock(block);

    if (!class_addMethod(className, originalSelector, newIMP, method_getTypeEncoding(originalMethod))) {
        return method_setImplementation(originalMethod, newIMP);
    } else {
        return method_getImplementation(originalMethod);
    }
}

- (NSURLSessionDataTask *)db_dataTaskWithURL:(NSURL *)url {
    return [self db_dataTaskWithURL:url];
}

- (NSURLSessionDataTask *)db_dataTaskWithRequest:(NSURLRequest *)request {
    [[DBNetworkToolkit sharedInstance] saveRequest:request];
    return [self db_dataTaskWithRequest:request];
}

- (void)db_URLSession:(NSURLSession *)session
             dataTask:(NSURLSessionDataTask *)dataTask
    willCacheResponse:(NSCachedURLResponse *)proposedResponse
    completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler
{
    if([self respondsToSelector:@selector(db_URLSession:dataTask:willCacheResponse:completionHandler:)]) {
        [self db_URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
    }
}

- (void)db_URLSession:(NSURLSession *)session
             dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveResponse:(NSURLResponse *)response
    completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [[DBNetworkToolkit sharedInstance] saveRequest:dataTask.originalRequest];
    if([self respondsToSelector:@selector(db_URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [self db_URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    }
}

- (void)db_URLSession:(NSURLSession *)session
             dataTask:(NSURLSessionDataTask *)dataTask
       didReceiveData:(NSData *)data
{
    [[DBNetworkToolkit sharedInstance] saveRequestOutcome:[DBRequestOutcome outcomeWithResponse:dataTask.response data:data] forRequest:dataTask.originalRequest];
    if([self respondsToSelector:@selector(db_URLSession:dataTask:didReceiveData:)]) {
        [self db_URLSession:session dataTask:dataTask didReceiveData:data];
    }
}

- (void)db_URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if(error != nil) {
        [[DBNetworkToolkit sharedInstance] saveRequestOutcome:[DBRequestOutcome outcomeWithError:error] forRequest:task.originalRequest];
    }

    if([self respondsToSelector:@selector(db_URLSession:task:didCompleteWithError:)]) {
        [self db_URLSession:session task:task didCompleteWithError:error];
    }
}

- (NSURLSessionDataTask *)db_dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
    return [self db_dataTaskWithRequest:request completionHandler:completionHandler];
}
@end
