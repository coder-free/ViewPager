//
//  ViewController.m
//  viewpager
//
//  Created by Apple on 15/3/17.
//  Copyright (c) 2015年 com.test. All rights reserved.
//

#import "ViewController.h"
#import "ItemViewController.h"
#import "ViewPagerController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnClicked:(UIButton *)sender {
    __weak ViewController *wself = self;
    self.activity.hidden = NO;
    self.button.hidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 1000; i++) {
            ItemViewController *item = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
            item.title = [NSString stringWithFormat:@"item%ld", (long)i];
            [array addObject:item];
        }
        ViewPagerController *pager = [[ViewPagerController alloc] initWithNibName:@"ViewPagerController" bundle:nil];
        pager.viewPagerTitleStyle = ViewPagerTitleStyleBackgroundColor;
        [pager setViewControllers:array animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.navigationController pushViewController:pager animated:YES];
            wself.activity.hidden = YES;
            self.button.hidden = NO;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
