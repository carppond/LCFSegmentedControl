//
//  ViewController.m
//  LCFSegmentedControl
//
//  Created by lichengfu on 2018/8/16.
//  Copyright © 2018年 lichengfu. All rights reserved.
//

#import "ViewController.h"
#import "LCFSegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"LCFSegmentedControl Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    LCFSegmentedControl *segmentedControl = [[LCFSegmentedControl alloc] initWithSectionTitles:@[@"蛮王",@"剑圣",@"德邦",@"盖伦"]];;
    segmentedControl.frame = CGRectMake(0, 20, viewWidth, 40);
    [self.view addSubview:segmentedControl];
    
    
    LCFSegmentedControl *segmentedControl1 = [[LCFSegmentedControl alloc] initWithSectionTitles:@[@"亚瑟",@"曹操",@"后裔",@"孙悟空",@"鲁班大师"]];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 100, viewWidth, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = LCFSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = LCFSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.selectionIndicatorColor = [UIColor redColor];
    segmentedControl1.verticalDividerEnabled = NO;
    segmentedControl1.verticalDivderColor = [UIColor blackColor];
    segmentedControl1.verticalDividerWidth = 1.0f;
    [segmentedControl1 setTitleFormatter:^NSAttributedString *(LCFSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
        return attString;
    }];
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl1];
    
}
-(void)segmentedControlChangedValue:(LCFSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}


@end
