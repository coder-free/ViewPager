//
//  PagerViewController.h
//  viewpager
//
//  Created by Apple on 15/3/17.
//  Copyright (c) 2015年 com.test. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TITLE_CLASS_HEIGHT 30
#define TITLE_CLASS_FONT_SIZE 16

typedef enum {
    ViewPagerTitleStyleBottomLine = 0,
    ViewPagerTitleStyleBackgroundColor
} ViewPagerTitleStyle;

@protocol ViewPagerDelegate <NSObject>

@optional

- (void)pageWillShow;
- (void)scrollContentToTop;

@end

@interface ViewPagerController : UIViewController

@property (strong, nonatomic) UIScrollView *titleScrollView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *sgContentView;

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIView *cursorbg;
@property (strong, nonatomic) UIImageView *cursorBgimageView;
@property (strong, nonatomic) NSMutableArray *titleButtons;

@property (strong, nonatomic) NSString *classIcoNamed;
@property (strong, nonatomic) NSString *classHighlightedIcoNamed;

@property (strong, nonatomic) UIColor *classSelectedTextColor;
@property (strong, nonatomic) UIColor *classNormalTextColor;
@property (strong, nonatomic) UIColor *classHighlightedTextColor;
@property (strong, nonatomic) UIColor *classBackgroundColor;
@property (strong, nonatomic) UIColor *classSelectedBackgroundColor;
@property (strong, nonatomic) UIColor *classBottomLineColor;
@property (strong, nonatomic) UIColor *contentBackgroundColor;
@property (strong, nonatomic) UIFont *classTitleFont;

@property (nonatomic) BOOL lockPageChange;
@property (nonatomic) BOOL isClick;
@property (nonatomic) NSUInteger titleBarWidth;
@property (nonatomic) CGFloat titleMarginV;
@property (nonatomic) CGFloat titleMarginH;
@property (nonatomic) CGFloat titleMarginHa;
@property (nonatomic) CGFloat dx;
@property (nonatomic) CGFloat contentScrollWidth;
@property (nonatomic) ViewPagerTitleStyle viewPagerTitleStyle;
@property (nonatomic) UIEdgeInsets cursorInsets;

@property (nonatomic) BOOL titleCenter;

- (void)reloadPages;

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

- (void)setPageIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)scrollCurrentViewToTop;

- (void)addViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

- (void)addViewControllers:(NSArray *)viewControllers atIndex:(NSInteger)index animated:(BOOL)animated;

- (void)addViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)addViewController:(UIViewController *)viewController atIndex:(NSInteger)index animated:(BOOL)animated;

@end
