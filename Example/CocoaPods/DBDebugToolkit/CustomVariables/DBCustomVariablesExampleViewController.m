//
//  DBCustomVariablesExampleViewController.m
//  DBDebugToolkit
//
//  Created by Dariusz Bukowski on 11.03.2017.
//  Copyright © 2017 Dariusz Bukowski. All rights reserved.
//

#import "DBCustomVariablesExampleViewController.h"
#import "DBExampleCollectionViewCell.h"
#import <DBDebugToolkit/DBDebugToolkit.h>
#import <DBDebugToolkit/DBCustomVariable.h>
#import <DBDebugToolkit/UIColor+DBUserInterfaceToolkit.h>

static NSString *const DBCustomVariablesExampleViewControllerExampleCellIdentifier = @"DBExampleCollectionViewCell";

@interface DBCustomVariablesExampleViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *cellColors;

@end

@implementation DBCustomVariablesExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCellColors];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DBExampleCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:DBCustomVariablesExampleViewControllerExampleCellIdentifier];
    DBCustomVariable *titleVariable = [DBCustomVariable customVariableWithName:@"View title" value:@"Custom variables"];
    [titleVariable addTarget:self action:@selector(didUpdateTitleVariable:)];
    DBCustomVariable *showsNumbers = [DBCustomVariable customVariableWithName:@"Shows cell numbers" value:@YES];
    [showsNumbers addTarget:self action:@selector(didUpdateCollectionViewVariable)];
    DBCustomVariable *numberOfColumns = [DBCustomVariable customVariableWithName:@"Number of columns" value:@4];
    [numberOfColumns addTarget:self action:@selector(didUpdateCollectionViewVariable)];
    DBCustomVariable *minimumInteritemSpacing = [DBCustomVariable customVariableWithName:@"Minimum interitem spacing" value:@10.0];
    [minimumInteritemSpacing addTarget:self action:@selector(didUpdateCollectionViewVariable)];
    [DBDebugToolkit addCustomVariables:@[ titleVariable, showsNumbers, numberOfColumns, minimumInteritemSpacing ]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DBDebugToolkit removeCustomVariablesWithNames:@[ @"View title", @"Shows cell numbers", @"Number of columns", @"Minimum interitem spacing" ]];
}

#pragma mark - Custom variable actions

- (void)didUpdateTitleVariable:(DBCustomVariable *)customVariable {
    self.title = customVariable.value;
}

- (void)didUpdateCollectionViewVariable {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellColors.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBExampleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DBCustomVariablesExampleViewControllerExampleCellIdentifier
                                                                                  forIndexPath:indexPath];
    NSString *title = [[DBDebugToolkit customVariableWithName:@"Shows cell numbers"].value boolValue] ? [@(indexPath.item) stringValue] : @"";
    [cell configureWithColor:self.cellColors[indexPath.item] title:title];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    DBCustomVariable *minimumInteritemSpacing = [DBDebugToolkit customVariableWithName:@"Minimum interitem spacing"];
    return [minimumInteritemSpacing.value doubleValue];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfColumns = [[DBDebugToolkit customVariableWithName:@"Number of columns"].value integerValue];
    CGFloat interitemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    CGFloat cellWidth = MAX((collectionView.bounds.size.width - (numberOfColumns - 1) * interitemSpacing - insets.left - insets.right) / numberOfColumns, 0.0);
    return CGSizeMake(cellWidth, cellWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - Cell colors

- (void)setupCellColors {
    NSInteger cellCount = 200;
    NSArray <UIColor *> *mainColors = @[ [UIColor yellowColor], [UIColor orangeColor], [UIColor redColor], [UIColor purpleColor], [UIColor blueColor], [UIColor greenColor] ];
    NSMutableArray *cellColors = [NSMutableArray array];
    for (int colorIndex = 0; colorIndex < cellCount; colorIndex++) {
        CGFloat allColorsRatio = (CGFloat)colorIndex / cellCount;
        CGFloat mainColorsIndex = allColorsRatio * (mainColors.count - 1);
        NSInteger firstColorIndex = floor(mainColorsIndex);
        UIColor *nextColor = [self colorBetweenColor:mainColors[firstColorIndex]
                                            andColor:mainColors[firstColorIndex + 1]
                                           withRatio:mainColorsIndex - firstColorIndex];
        [cellColors addObject:nextColor];
    }
    self.cellColors = [cellColors copy];
}

- (UIColor *)colorBetweenColor:(UIColor *)firstColor andColor:(UIColor *)secondColor withRatio:(CGFloat)ratio {
    CGFloat redA, redB, greenA, greenB, blueA, blueB, alphaA, alphaB;
    [firstColor getRed:&redA green:&greenA blue:&blueA alpha:&alphaA];
    [secondColor getRed:&redB green:&greenB blue:&blueB alpha:&alphaB];
    return [UIColor colorWithRed:redA + (redB - redA) * ratio
                           green:greenA + (greenB - greenA) * ratio
                            blue:blueA + (blueB - blueA) * ratio
                           alpha:alphaA + (alphaB - alphaA) * ratio];
}

@end
