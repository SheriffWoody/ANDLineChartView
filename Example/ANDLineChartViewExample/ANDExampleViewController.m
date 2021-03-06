//
//  ANDExampleViewController.m
//  SimpleAnimatedGraph
//
//  Created by Andrzej Naglik on 20.06.2014.
//  Copyright (c) 2014 Andrzej Naglik. All rights reserved.
//

#import "ANDExampleViewController.h"
#import <ANDLineChartView/ANDLineChartView.h>

#define MAX_NUMBER_COUNT 20

#define MAX_NUMBER 20

@interface ANDExampleViewController()<ANDLineChartViewDataSource,ANDLineChartViewDelegate>{
    NSArray *_elements;
    NSUInteger _numbersCount;
    NSUInteger _maxValue;
    ANDLineChartView *_chartView;
}

@end

@implementation ANDExampleViewController

- (void)loadView{
    UIView *mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setView:mainView];
    
    _chartView = [[ANDLineChartView alloc] initWithFrame:CGRectZero];
    [_chartView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_chartView setDataSource:self];
    [_chartView setDelegate:self];
    [_chartView setAnimationDuration:0.4];
    [_chartView setShouldLabelsFloat:NO];
    [self.view addSubview:_chartView];
    _elements = [self arrayWithRandomNumbers];
    
    [self setupConstraints];
}

- (void)setupConstraints{
    id topLayoutGuide = [self topLayoutGuide];
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(topLayoutGuide,_chartView);
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][_chartView]|"
                                                                        options:0 metrics:nil views:viewsDict]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_chartView]|" options:0 metrics:nil views:viewsDict]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"Example graph"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  //  [self randomizeElements];
}

- (void)randomizeElements{
    __weak ANDExampleViewController *weakSelf = self;
    __weak ANDLineChartView *weakChartView = _chartView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _elements = [weakSelf arrayWithRandomNumbers];
        [weakChartView reloadData];
        [weakSelf randomizeElements];
    });
}

- (NSArray*)arrayWithRandomNumbers{
    _numbersCount = MAX_NUMBER_COUNT;//arc4random_uniform(MAX_NUMBER_COUNT + 1) + 1;
    _maxValue = MAX_NUMBER;//arc4random_uniform(MAX_NUMBER + 1);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_numbersCount];
    for(NSUInteger i = 0;i<_numbersCount;i++){
        NSUInteger r = arc4random_uniform((u_int32_t)_maxValue + 1);
        [array addObject:@(r)];
    }
    [array insertObject:[NSNumber numberWithInteger:0] atIndex:0];
    array = @[@0,@5,@10,@20,@2,@12,@2,@16,@11];
    return array;
}

- (BOOL)automaticallyAdjustsScrollViewInsets{
    return NO;
}

#pragma mark
#pragma mark - ANDLineChartViewDataSource methods

- (NSUInteger)numberOfElementsInChartView:(ANDLineChartView *)graphView{
    return _elements.count;
}

- (CGFloat)chartView:(ANDLineChartView *)graphView valueForElementAtRow:(NSUInteger)row{
    return [(NSNumber*)_elements[row] floatValue];
}

- (CGFloat)maxValueForGridIntervalInChartView:(ANDLineChartView *)graphView{
    return _maxValue;
}

- (CGFloat)minValueForGridIntervalInChartView:(ANDLineChartView *)graphView{
    return 0.0;
}

- (NSUInteger)numberOfGridIntervalsInChartView:(ANDLineChartView *)graphView{
    return 12.0;
}

- (NSString *)chartView:(ANDLineChartView *)chartView descriptionForForElementAtRow:(NSUInteger)row
{
    if (row == 0) {
        return @"111";
    }
    return @"12";
}

- (NSString*)chartView:(ANDLineChartView *)graphView descriptionForGridIntervalValue:(CGFloat)interval{
    return [NSString stringWithFormat:@"%.1f",interval];
}

#pragma mark
#pragma mark - ANDLineChartViewDelegate method

- (CGFloat)chartView:(ANDLineChartView *)graphView spacingForElementAtRow:(NSUInteger)row{
    return (row == 0) ? 60.0 : 30.0;
}

@end
