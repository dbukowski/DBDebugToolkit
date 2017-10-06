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

#import "DBFontFamiliesTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBFontPreviewViewController.h"

static NSString *const DBFontFamiliesTableViewControllerFontCellIdentifier = @"FontCell";

@interface DBFontFamiliesTableViewController ()

@property (nonatomic, copy) NSArray <NSString *> *fontFamilyNames;
@property (nonatomic, copy) NSArray <NSArray <NSString *> *> *fontNames;
@property (nonatomic, copy) NSArray <NSString *> *allFontNames;

@end

@implementation DBFontFamiliesTableViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFonts];
}

- (void)setupFonts {
    self.fontFamilyNames = [[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableArray *fontNames = [NSMutableArray array];
    NSMutableArray *allFontNames = [NSMutableArray array];
    for (NSString *fontFamilyName in self.fontFamilyNames) {
        NSArray *familyFonts = [UIFont fontNamesForFamilyName:fontFamilyName];
        NSArray *sortedFamilyFonts = [familyFonts sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [fontNames addObject:sortedFamilyFonts];
        [allFontNames addObjectsFromArray:sortedFamilyFonts];
    }
    self.fontNames = [fontNames copy];
    self.allFontNames = [allFontNames copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fontFamilyNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fontNames[section].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }

    return self.fontFamilyNames[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *fontCell = [tableView dequeueReusableCellWithIdentifier:DBFontFamiliesTableViewControllerFontCellIdentifier];
    if (fontCell == nil) {
        fontCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:DBFontFamiliesTableViewControllerFontCellIdentifier];
        fontCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        fontCell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    fontCell.textLabel.text = self.fontNames[indexPath.section][indexPath.row];
    return fontCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    NSString *selectedFontName = self.fontNames[indexPath.section][indexPath.row];
    NSInteger selectedFontIndex = [self.allFontNames indexOfObject:selectedFontName];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBFontPreviewViewController" bundle:bundle];
    DBFontPreviewViewController *fontPreviewViewController = [storyboard instantiateInitialViewController];
    [fontPreviewViewController configureWithSelectedFontIndex:selectedFontIndex allFontNames:self.allFontNames];
    [self.navigationController pushViewController:fontPreviewViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

#pragma mark - Private methods

- (CGFloat)heightForFooterAndHeaderInSection:(NSInteger)section {
    return [self tableView:self.tableView numberOfRowsInSection:section] > 0 ? UITableViewAutomaticDimension : CGFLOAT_MIN;
}

@end
