//
//  ItemViewController.m
//  viewpager
//
//  Created by Apple on 15/3/17.
//  Copyright (c) 2015年 com.test. All rights reserved.
//

#import "ItemViewController.h"
#import "TableViewCell.h"
#import "ViewPagerController.h"

@interface ItemViewController () <UITableViewDataSource, UITableViewDelegate, ViewPagerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if ([self.dataArray count] > [indexPath row]) {
        [[cell titleLabel] setText:[self.dataArray objectAtIndex:[indexPath row]]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pageWillShow
{
    if (!self.dataArray) {
        __weak ItemViewController *wself = self;
        self.activity.hidden = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!wself.dataArray) {
                wself.dataArray = [[NSMutableArray alloc] init];
            } else {
                [wself.dataArray removeAllObjects];
            }
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < 1000; i++) {
                [array addObject:[NSString stringWithFormat:@"cell %ld", (long)i]];
                [NSThread sleepForTimeInterval:0.001f];
            }
            [wself.dataArray addObjectsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself.tableView reloadData];
                wself.activity.hidden = YES;
            });
        });
    }
}
- (void)scrollContentToTop
{
    [self.tableView scrollsToTop];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
