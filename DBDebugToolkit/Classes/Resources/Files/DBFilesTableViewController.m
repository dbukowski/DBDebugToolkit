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

#import "DBFilesTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "UILabel+DBDebugToolkit.h"
#import "DBFileTableViewCell.h"

static NSString *const DBFilesTableViewControllerDirectoryCellIdentifier = @"DirectoryCell";
static NSString *const DBFilesTableViewControllerFileCellIdentifier = @"FileCell";
static NSString *const DBFilesTableViewControllerSkippedDirectory = @"DBDebugToolkit";
static const NSInteger DBFilesTableViewControllerNextSizeAbbreviationThreshold = 1024;

@interface DBFilesTableViewController ()

@property (nonatomic, strong) NSMutableArray *subdirectories;
@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) UILabel *backgroundLabel;
@property (nonatomic, weak) IBOutlet UILabel *pathLabel;

@end

@implementation DBFilesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBFileTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBFilesTableViewControllerFileCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    [self setupBackgroundLabel];
    [self setupContents];
}

- (void)setupContents {
    self.pathLabel.text = self.path ? [self.path stringByReplacingOccurrencesOfString:NSHomeDirectory() withString:@""] : @"/";
    if (self.path == nil) {
        self.path = NSHomeDirectory();
    }
    NSMutableArray *subdirectories = [NSMutableArray array];
    NSMutableArray *files = [NSMutableArray array];
    NSError *error;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
    for (NSString *element in directoryContent) {
        if ([element isEqualToString:DBFilesTableViewControllerSkippedDirectory]) {
            continue;
        }
        BOOL isDirectory;
        NSString *fullElementPath = [self.path stringByAppendingPathComponent:element];
        [[NSFileManager defaultManager] fileExistsAtPath:fullElementPath isDirectory:&isDirectory];
        if (isDirectory) {
            [subdirectories addObject:element];
        } else {
            [files addObject:element];
        }
    }
    self.subdirectories = [NSMutableArray arrayWithArray:[subdirectories sortedArrayUsingSelector:@selector(compare:)]];
    self.files = [NSMutableArray arrayWithArray:[files sortedArrayUsingSelector:@selector(compare:)]];
    [self refreshBackgroundLabel];
}

#pragma mark - Background label

- (void)setupBackgroundLabel {
    self.backgroundLabel = [UILabel tableViewBackgroundLabel];
    self.tableView.backgroundView = self.backgroundLabel;
}

- (void)refreshBackgroundLabel {
    self.backgroundLabel.text = self.subdirectories.count + self.files.count > 0 ? @"" : @"This directory is empty.";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.subdirectories.count : self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *subdirectoryCell = [tableView dequeueReusableCellWithIdentifier:DBFilesTableViewControllerDirectoryCellIdentifier];
        subdirectoryCell.textLabel.text = self.subdirectories[indexPath.row];
        return subdirectoryCell;
    } else {
        NSString *fileName = self.files[indexPath.row];
        DBFileTableViewCell *fileCell = [tableView dequeueReusableCellWithIdentifier:DBFilesTableViewControllerFileCellIdentifier];
        fileCell.nameLabel.text = fileName;
        fileCell.sizeLabel.text = [self sizeStringForFileWithName:fileName];
        return fileCell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fullPath = [self fullPathForElementWithIndexPath:indexPath];
    return [[NSFileManager defaultManager] isDeletableFileAtPath:fullPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *fullPath = [self fullPathForElementWithIndexPath:indexPath];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
        if (error) {
            [self presentAlertWithError:error];
        } else {
            [self removeElementFromDataSourceWithIndexPath:indexPath];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self refreshBackgroundLabel];
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *subdirectoryName = self.subdirectories[indexPath.row];
        NSBundle *bundle = [NSBundle debugToolkitBundle];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBFilesTableViewController" bundle:bundle];
        DBFilesTableViewController *filesTableViewController = [storyboard instantiateInitialViewController];
        filesTableViewController.path = [self.path stringByAppendingPathComponent:subdirectoryName];
        filesTableViewController.title = subdirectoryName;
        [self.navigationController pushViewController:filesTableViewController animated:YES];
    } else {
        NSString *filePath = [self.path stringByAppendingPathComponent:self.files[indexPath.row]];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        UIActivityViewController *activity = [[UIActivityViewController alloc]
                                              initWithActivityItems:@[fileURL]
                                              applicationActivities:nil];
        UIPopoverPresentationController *popover = activity.popoverPresentationController;
        if (popover) {
            popover.sourceView = tableView;
            popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
        }
        [self presentViewController:activity animated:YES completion:nil];
    }
}

#pragma mark - File size

- (NSString *)sizeStringForFileWithName:(NSString *)fileName {
    NSString *fullPath = [self.path stringByAppendingPathComponent:fileName];
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil] fileSize];
    NSArray *sizeUnitAbbreviations = [NSArray arrayWithObjects:@"B", @"KB", @"MB", @"GB", nil];
    for (int abbreviationIndex = 0; abbreviationIndex < sizeUnitAbbreviations.count; abbreviationIndex++) {
        if (fileSize < DBFilesTableViewControllerNextSizeAbbreviationThreshold) {
            return [NSString stringWithFormat:@"%llu%@", fileSize, sizeUnitAbbreviations[abbreviationIndex]];
        }
        fileSize /= DBFilesTableViewControllerNextSizeAbbreviationThreshold;
    }
    
    return nil;
}

#pragma mark - Element paths

- (NSString *)fullPathForElementWithIndexPath:(NSIndexPath *)indexPath {
    NSString *elementName = indexPath.section == 0 ? self.subdirectories[indexPath.row] : self.files[indexPath.row];
    return [self.path stringByAppendingPathComponent:elementName];
}

- (void)removeElementFromDataSourceWithIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *affectedArray = indexPath.section == 0 ? self.subdirectories : self.files;
    [affectedArray removeObjectAtIndex:indexPath.row];
}

#pragma mark - Alert

- (void)presentAlertWithError:(NSError *)error {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Deletion error"
                                                                   message:[error localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
