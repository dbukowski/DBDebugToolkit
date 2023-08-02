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

/**
 Enum with types of the custom variables.
 */
typedef NS_ENUM(NSUInteger, DBCustomVariableType) {
    DBCustomVariableTypeUnrecognized,
    DBCustomVariableTypeString,
    DBCustomVariableTypeInt,
    DBCustomVariableTypeDouble,
    DBCustomVariableTypeBool
};

/**
 `DBCustomVariable` is an object describing a variable that will be added to the menu allowing the user to modify its value during runtime.
 */
@interface DBCustomVariable : NSObject

/**
 Type of the variable based on its `value` property. Determines the controls used in the menu for the variable value modification. Read-only.
 */
@property (nonatomic, readonly) DBCustomVariableType type;

/**
 The value of the property.
 */
@property (nonatomic, strong, nullable) id value;

/**
 The name of the variable. Should be unique. Read-only.
 */
@property (nonatomic, readonly, nullable) NSString *name;

/**
 Creates and returns a new `DBCustomVariable` instance with the given name and value.
 
 @param name Name of the new variable. Should be unique.
 @param value The value of the new variable. It determines the type of the property, so make sure to pass the value of a proper type.
 */
+ (nonnull instancetype)customVariableWithName:(nullable NSString *)name value:(nullable id)value;

/**
 Adds a new action that will be invoked when the variable value changes.
 
 @param target A target that will perform the action.
 @param action A selector identifying an action method.
 */
- (void)addTarget:(nonnull id)target action:(nonnull SEL)action;

/**
 Stops the delivery of value change event to the specified target object.
 
 @param target A target object registered with the variable. Specify nil to remove the actions for all target objects.
 @param action A selector identifying a registered action method. You may specify nil for this parameter to remove all actions registered for the given target object.
 */
- (void)removeTarget:(nullable id)target action:(nullable SEL)action;

@end
