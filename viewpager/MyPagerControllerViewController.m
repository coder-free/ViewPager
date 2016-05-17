//
//  MyPagerControllerViewController.m
//  viewpager
//
//  Created by zbf on 16/5/17.
//  Copyright © 2016年 com.test. All rights reserved.
//

#import "MyPagerControllerViewController.h"
#import "ColorTools.h"
#import "ItemViewController.h"

@interface MyPagerControllerViewController ()

@end

@implementation MyPagerControllerViewController

- (void)viewDidLoad {
    self.viewPagerTitleStyle = ViewPagerTitleStyleBottomLine;
    self.ave = YES;
    [super viewDidLoad];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 10; i++) {
        ItemViewController *item = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
        item.title = [NSString stringWithFormat:@"item%ld", (long)i];
        [array addObject:item];
    }
    [self setViewControllers:array animated:YES];
}

- (void)initClassTitleColor
{
    self.classBackgroundColor = [ColorTools colorFromHexRGB:@"ffffff"];
    self.classBottomLineColor = [ColorTools colorFromHexRGB:@"aaaaaa" alpha:1];
    self.classHighlightedTextColor = [UIColor blueColor];
    self.classNormalTextColor = [ColorTools colorFromHexRGB:@"525252"];
    self.classSelectedBackgroundColor = [UIColor blueColor];
    self.classSelectedTextColor = [UIColor blueColor];
    self.contentBackgroundColor = [ColorTools colorFromHexRGB:@"ffffff"];
    self.classSeparatorLineColor = [ColorTools colorFromHexRGB:@"aaaaaa"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
