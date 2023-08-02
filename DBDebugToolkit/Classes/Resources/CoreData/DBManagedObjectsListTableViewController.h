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
#import <CoreData/CoreData.h>

/**
 `DBManagedObjectsListTableViewController` is a table view controller presenting a list of Core Data managed objects. It is either configured by an entity and persistent store coordinator (which requires fetching the objects) or by a precomputed array of managed objects.
 */
@interface DBManagedObjectsListTableViewController : UITableViewController

/**
 `NSEntityDescription` instance that will be used to fetch the proper managed objects.
 */
@property (nonatomic, strong) NSEntityDescription *entity;

/**
 `NSPersistentStoreCoordinator` instance that will be used to fetch all the managed objects from the given entity.
 */
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 A precomputed array of Core Data managed objects.
 */
@property (nonatomic, strong) NSArray <NSManagedObject *> *managedObjects;

@end
