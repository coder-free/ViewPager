//
//  PagerViewController.m
//  viewpager
//
//  Created by Apple on 15/3/17.
//  Copyright (c) 2015年 com.test. All rights reserved.
//

#import "ViewPagerController.h"
#import "StringTools.h"
#import "ColorTools.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS_7_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#define TITLE_ITEM_MARGIN_V 0
#define TITLE_ITEM_MARGIN_H 0

@interface ViewPagerController () <UIScrollViewDelegate>

@property (nonatomic) NSUInteger pageIndexa;
@property (strong, nonatomic) NSMutableArray *titleWidths;
@property (strong, nonatomic) NSMutableArray *viewArrays;

@end

@implementation ViewPagerController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pageIndexa = 0;
        _lockPageChange = YES;
        _titleCenter = YES;
        [self initClassTitleColor];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        _pageIndexa = 0;
        _lockPageChange = YES;
        _titleCenter = YES;
        [self initClassTitleColor];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _pageIndexa = 0;
        _lockPageChange = YES;
        _titleCenter = YES;
        [self initClassTitleColor];
    }
    return self;
}

- (void)initClassTitleColor {
    self.classBackgroundColor = [ColorTools colorFromHexRGB:@"ffffff"];
    self.classBottomLineColor = [ColorTools colorFromHexRGB:@"ff3e58"];
    self.classHighlightedTextColor = [ColorTools colorFromHexRGB:@"222222"];
    self.classNormalTextColor = [ColorTools colorFromHexRGB:@"000000"];
    self.classSelectedBackgroundColor = [ColorTools colorFromHexRGB:@"ff3e58"];
    self.classSelectedTextColor = [ColorTools colorFromHexRGB:@"ffffff"];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    if (IS_IOS_7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    switch (self.viewPagerTitleStyle) {
        case ViewPagerTitleStyleBackgroundColor: {
            _cursorInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        }
            break;
        default: {
            _cursorInsets = UIEdgeInsetsMake(TITLE_CLASS_HEIGHT - 3, 0, 0, 0);
        }
            break;
    }
    _sgContentView = [[UIView alloc] initWithFrame:self.view.frame];
    _sgContentView.autoresizesSubviews = YES;
    _sgContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _sgContentView.backgroundColor = [UIColor clearColor];
    _titleBarWidth = _sgContentView.frame.size.width;
    _classTitleFont = [UIFont systemFontOfSize:TITLE_CLASS_FONT_SIZE];
    CGRect frame = CGRectMake(0, 0, _titleBarWidth, TITLE_CLASS_HEIGHT);
    _titleScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _titleScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [_titleScrollView setCanCancelContentTouches:NO];
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.clipsToBounds = YES;
    _titleScrollView.scrollEnabled = YES;
    _titleScrollView.delegate = self;
    _titleScrollView.userInteractionEnabled = YES;
    _titleScrollView.backgroundColor = [UIColor clearColor];
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(_titleScrollView.frame.origin.x, _titleScrollView.frame.origin.y, 5, _titleScrollView.frame.size.height)];
    leftview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    leftview.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradientleft = [CAGradientLayer layer];
    gradientleft.frame = leftview.bounds;
    gradientleft.colors = [NSArray arrayWithObjects:(id)[ColorTools colorFromHexRGB:@"ffffff" alpha:1].CGColor,
                           (id)[ColorTools colorFromHexRGB:@"ffffff" alpha:0].CGColor, nil];
    gradientleft.startPoint = CGPointMake(0, 0);
    gradientleft.endPoint = CGPointMake(1, 0);
    [leftview.layer insertSublayer:gradientleft atIndex:0];
    UIView *rightview = [[UIView alloc] initWithFrame:CGRectMake(_titleScrollView.frame.origin.x + _titleScrollView.frame.size.width - 5, _titleScrollView.frame.origin.y, 5, _titleScrollView.frame.size.height)];
    rightview.tintColor = [UIColor clearColor];
    rightview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    CAGradientLayer *gradientright = [CAGradientLayer layer];
    gradientright.frame = rightview.bounds;
    gradientright.colors = [NSArray arrayWithObjects:(id)[ColorTools colorFromHexRGB:@"ffffff" alpha:0].CGColor,
                            (id)[ColorTools colorFromHexRGB:@"ffffff" alpha:1].CGColor, nil];
    gradientright.startPoint = CGPointMake(0, 0);
    gradientright.endPoint = CGPointMake(1, 0);
    [rightview.layer insertSublayer:gradientright atIndex:0];
    
    frame = CGRectMake(0, _titleScrollView.frame.origin.y + TITLE_CLASS_HEIGHT , _sgContentView.bounds.size.width, 0.5);
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    lineView.backgroundColor = [UIColor clearColor];
    
    frame = CGRectMake(0, _titleScrollView.frame.origin.y + _titleScrollView.frame.size.height, _sgContentView.bounds.size.width, _sgContentView.bounds.size.height - _titleScrollView.frame.origin.y - _titleScrollView.frame.size.height);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _contentScrollWidth = frame.size.width;
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.autoresizesSubviews = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.canCancelContentTouches = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.clipsToBounds = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    [_scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
//    _sgContentView.backgroundColor = self.contentBackgroundColor;
    [_sgContentView addSubview:_scrollView];
    [_sgContentView addSubview:_titleScrollView];
    [_sgContentView addSubview:leftview];
    [_sgContentView addSubview:rightview];
    [_sgContentView addSubview:lineView];
    [self.view addSubview:_sgContentView];
    self.lineView = lineView;
    _lockPageChange = NO;
    [_sgContentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    if ([self.childViewControllers count] > 0) {
        [self reloadPages];
    }
    
}

- (void)initLayoutParam {
    [self initTitleItemWidth];
    _titleMarginHa = _titleBarWidth - [self getTitlesWidth];
    _titleMarginHa /= [self.titleWidths count] + 1;
    if (_titleMarginHa < 0) {
        _titleMarginHa = 0;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _scrollView && [keyPath isEqualToString:@"frame"]) {
        CGSize size = [_scrollView contentSize];
        size.height = _scrollView.bounds.size.height;
        [_scrollView setContentSize:size];
        if (_contentScrollWidth != _scrollView.frame.size.width) {
            _contentScrollWidth = _scrollView.frame.size.width;
            [self reloadPages];
        }
    } else if (object == _sgContentView && [keyPath isEqualToString:@"frame"]) {
        if (_titleBarWidth != _sgContentView.bounds.size.width) {
            _titleBarWidth = _sgContentView.bounds.size.width;
            [self initLayoutParam];
            NSLog(@"titleBarWidth:%lu", (unsigned long)_titleBarWidth);
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIViewController * c = nil;
    if([self.childViewControllers count] > _pageIndexa) {
        c = self.childViewControllers[_pageIndexa];
    }
    if(c && [c respondsToSelector:@selector(pageWillShow)]) {
        [c performSelector:@selector(pageWillShow)];
    }
}

- (void)loadView {
    [super loadView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    _lockPageChange = YES;
    [self reloadPages];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _lockPageChange = NO;
    [self setPageIndex:self.pageIndex animated:NO];
}

#pragma mark Add and remove
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        self.pageIndex = 0;
        for (UIViewController *vC in self.childViewControllers) {
            [vC willMoveToParentViewController:nil];
            [vC removeFromParentViewController];
        }
    }
    
    for (UIViewController *vC in viewControllers) {
        [self addChildViewController:vC];
        [vC didMoveToParentViewController:self];
    }
    
    if (self.scrollView) {
        [self reloadPages];
    }
    //TODO animations
}

- (void)addViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    
    for (UIViewController *vC in viewControllers) {
        if ([self isObject:vC inArray:self.childViewControllers]) {
            continue;
        }
        [self addChildViewController:vC];
        [vC didMoveToParentViewController:self];
    }
    
    if (self.scrollView) {
        [self reloadPages];
    }
}

- (void)addViewControllers:(NSArray *)viewControllers atIndex:(NSInteger)index animated:(BOOL)animated {
    
    NSMutableArray *oldcontrollers = [[NSMutableArray alloc] init];
    
    while (self.childViewControllers.count > index) {
        UIViewController *vC = self.childViewControllers[index];
        [oldcontrollers addObject:vC];
        [vC willMoveToParentViewController:nil];
        [vC removeFromParentViewController];
    }
    
    for (UIViewController *vC in viewControllers) {
        if ([self isObject:vC inArray:self.childViewControllers]) {
            continue;
        }
        [self addChildViewController:vC];
        [vC didMoveToParentViewController:self];
    }
    
    for (UIViewController *vC in oldcontrollers) {
        if ([self isObject:vC inArray:self.childViewControllers]) {
            continue;
        }
        [self addChildViewController:vC];
        [vC didMoveToParentViewController:self];
    }
    
    if (self.scrollView) {
        [self reloadPages];
    }
    
}

- (void)addViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self isObject:viewController inArray:self.childViewControllers]) {
        return;
    }
    
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    if (self.scrollView) {
        [self reloadPages];
    }
}

- (void)addViewController:(UIViewController *)viewController atIndex:(NSInteger)index animated:(BOOL)animated {
    
    if ([self isObject:viewController inArray:self.childViewControllers]) {
        return;
    }
    
    NSMutableArray *oldcontrollers = [[NSMutableArray alloc] init];
    
    while (self.childViewControllers.count > index) {
        UIViewController *vC = self.childViewControllers[index];
        [oldcontrollers addObject:vC];
        [vC willMoveToParentViewController:nil];
        [vC removeFromParentViewController];
    }
    
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    for (UIViewController *vC in oldcontrollers) {
        [self addChildViewController:vC];
        [vC didMoveToParentViewController:self];
    }
    
    if (self.scrollView) {
        [self reloadPages];
    }
    
}

- (BOOL)isObject:(NSObject *)obj inArray:(NSArray *)array {
    for (NSObject *aobj in array) {
        if (aobj == obj) {
            return YES;
        }
    }
    return NO;
}

- (void)removeViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        self.pageIndex = 0;
        for (UIViewController *vC in self.childViewControllers) {
            if ([self isObject:vC inArray:viewControllers]) {
                [vC willMoveToParentViewController:nil];
                [vC removeFromParentViewController];
            }
        }
    }
    
    if (self.scrollView) {
        [self reloadPages];
    }
}

- (void)removeViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.childViewControllers.count > index) {
        UIViewController *vC = self.childViewControllers[index];
        [vC willMoveToParentViewController:nil];
        [vC removeFromParentViewController];
    }
    
    if (self.scrollView) {
        [self reloadPages];
    }
}

- (void)removeViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self isObject:viewController inArray:self.childViewControllers]) {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }
    
    if (self.scrollView) {
        [self reloadPages];
    }
}

-(void) initTitleItemWidth {
    CGFloat defaultWidth = (self.titleScrollView.frame.size.width - ([self.childViewControllers count] - 1) * TITLE_ITEM_MARGIN_H) /  [self.childViewControllers count];
    self.titleWidths = [[NSMutableArray alloc] initWithCapacity:[self.childViewControllers count]];
    for (int i = 0; i < [self.childViewControllers count]; i++) {
        UIViewController *vC = [self.childViewControllers objectAtIndex:i];
        CGSize size = [StringTools sizeWithString:vC.title font:self.classTitleFont constrainedToSize:CGSizeMake(NSIntegerMax, TITLE_CLASS_FONT_SIZE)];
        size.width += 20;
        if (defaultWidth > size.width) {
            size.width = defaultWidth;
        }
        [self.titleWidths addObject:[NSNumber numberWithFloat:size.width + TITLE_ITEM_MARGIN_H]];
    }
}

-(CGFloat) getTitlesWidthToIndex:(int)index {
    float width = 0;
    for (int i =0; i < index; i++) {
        NSNumber *num = [self.titleWidths objectAtIndex:i];
        width += [num floatValue];
    }
    return width;
}

- (CGFloat)getTitleItemWidth {
    if (_pageIndexa >= [self.titleWidths count]) {
        return CGFLOAT_MAX;
    }
    NSNumber *num = [self.titleWidths objectAtIndex:_pageIndexa];
    return [num floatValue];
}

- (CGFloat)getTitleItemWidth:(NSInteger)index {
    if (index >= [self.titleWidths count]) {
        return CGFLOAT_MAX;
    }
    NSNumber *num = [self.titleWidths objectAtIndex:index];
    return [num floatValue];
}

- (CGFloat)getTitlesWidth {
    float width = 0;
    for (int i = 0; i < [self.titleWidths count]; i++) {
        NSNumber *num = [self.titleWidths objectAtIndex:i];
        width += [num floatValue];
    }
    return width;
}

- (void)setTitleItemMarginV:(CGFloat)titleItemMarginV {
    _titleMarginV = titleItemMarginV;
}
- (void)setTitleItemMarginH:(CGFloat)titleItemMarginH {
    _titleMarginH = titleItemMarginH;
}

#pragma mark Properties
- (void)setPageIndex:(NSUInteger)pageIndex {
    [self setAllTitleDisSelected];
    if([self.titleButtons count] > pageIndex) {
        [[self.titleButtons objectAtIndex:pageIndex] setSelected:YES];
    }
    [self setPageIndex:pageIndex animated:YES];
}

- (void)setPageIndex:(NSUInteger)index animated:(BOOL)animated; {
    if(_pageIndexa == index) return;
    
    if(!animated)_pageIndexa = index;
    /*
     *	Change the scroll view
     */
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    
    if (frame.origin.x < _scrollView.contentSize.width) {
        [_scrollView scrollRectToVisible:frame animated:animated];
    }
}

- (NSUInteger)pageIndex {
    return _pageIndexa;
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _titleScrollView) {
        return;
    }
    
    //The scrollview tends to scroll to a different page when the screen rotates
    if (_lockPageChange)
        return;
    /*
     *	We switch page at 50% across
     */
    CGFloat pageWidth = scrollView.bounds.size.width;
    
    if (pageWidth == 0) {
        return;
    }
    
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(_pageIndexa != page) {
        _pageIndexa = page;
        [self setTitleSelected:_pageIndexa];
    }
    CGFloat titlesWidth = [self getTitlesWidthToIndex:page];
    CGFloat titleWidth = [self getTitleItemWidth];
    
    CGFloat newXOff = titlesWidth + (scrollView.contentOffset.x - pageWidth * page)/pageWidth * titleWidth;
    
    CGRect cursorbgframe = self.cursorbg.frame;
    cursorbgframe.origin.x = newXOff + _dx + (_titleMarginHa * _pageIndexa);
    cursorbgframe.size.width = titleWidth;
    [self.cursorbg setFrame:cursorbgframe];
    
    newXOff -= (_titleBarWidth - titleWidth)/2;
    newXOff += _dx;
    if(newXOff < 0 ) {
        newXOff = 0;
    } else if(newXOff > _titleScrollView.contentSize.width - _titleBarWidth) {
        newXOff = _titleScrollView.contentSize.width - _titleBarWidth;
        if(newXOff < 0 ) {
            newXOff = 0;
        }
    }
    _titleScrollView.contentOffset = CGPointMake(newXOff, 0);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //手指离开
    if (scrollView == _titleScrollView) {
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //滚动完成
    if (scrollView == _titleScrollView) {
        return;
    }
    [self pageChange];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == _titleScrollView) {
        return;
    }
    _isClick = NO;
    [self pageChange];
}

- (void)titleClick:(UIButton *) sender {
    _isClick = YES;
    NSInteger titlenum = sender.tag;
    [self setAllTitleDisSelected];
    [sender setSelected:YES];
    [self setPageIndex:titlenum animated:YES];
}

-(void)setAllTitleDisSelected {
    for (UIButton *btn in self.titleButtons) {
        [btn setSelected:NO];
    }
}

-(void)setTitleSelected:(NSInteger)pageindex {
    for (int i = 0; i < [self.titleButtons count]; i++) {
        UIButton *btn = self.titleButtons[i];
        if(i == pageindex) {
            if(!btn.selected) {
                [btn setSelected:YES];
//                if(!_isClick) {
//                    id<ViewPagerDelegate> c = nil;
//                    if([self.childViewControllers count] > i) {
//                        c = self.childViewControllers[i];
//                    }
//                    if(c && [c respondsToSelector:@selector(pageWillShow)]) {
//                        [c performSelector:@selector(pageWillShow)];
//                    }
//                }
            }
        } else {
            if(btn.selected) {
                [btn setSelected:NO];
            }
        }
    }
}

- (void)reloadPages {
    for (UIView *view in _titleScrollView.subviews) {
        [view removeFromSuperview];
    }
    CGRect titleframe = CGRectMake(- _sgContentView.bounds.size.width, 0, _sgContentView.bounds.size.width, TITLE_CLASS_HEIGHT);
    UIImageView *titlebg = [[UIImageView alloc] initWithFrame:titleframe];
    titlebg.backgroundColor = [UIColor clearColor];
    _titleScrollView.backgroundColor = self.classBackgroundColor;
    [_titleScrollView addSubview:titlebg];
    self.lineView.backgroundColor = self.classBottomLineColor;
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    if(!self.titleButtons) {
        self.titleButtons = [[NSMutableArray alloc] init];
    } else {
        [self.titleButtons removeAllObjects];
    }
    [self initLayoutParam];
    CGFloat cx = 0;
    
    CGFloat dx = 0;
    NSUInteger count = self.childViewControllers.count;
    if(_titleCenter) {
        dx = _titleMarginHa;
        if(dx < 0) {
            dx = 0;
        }
    }
    _dx = dx;
    if (self.viewArrays) {
        [self.viewArrays removeAllObjects];
    } else {
        self.viewArrays = [[NSMutableArray alloc] init];
    }
    for (NSUInteger i = 0; i < count; i++) {
        UIViewController<ViewPagerDelegate> *vC = [self.childViewControllers objectAtIndex:i];
        float width = [self getTitleItemWidth:i];
        CGRect frame = CGRectMake(dx, 0, width, _titleScrollView.bounds.size.height);
        UIView *titleItemView = [[UIView alloc] initWithFrame:frame];
        titleItemView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleItemView.backgroundColor = [UIColor clearColor];
        CGSize size = CGSizeMake(width - TITLE_ITEM_MARGIN_H, frame.size.height - 2 * TITLE_ITEM_MARGIN_V);
        frame = CGRectMake(0.5*(frame.size.width - size.width),
                           0.5*(frame.size.height - size.height), size.width, size.height);
        UIButton *l = [[UIButton alloc] initWithFrame:frame];
        [l setTag:i];
        l.backgroundColor = [UIColor clearColor];
        l.titleLabel.font = _classTitleFont;
        if (self.viewPagerTitleStyle == ViewPagerTitleStyleBottomLine) {
            l.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 3, 0);
        }
        [l setTitleColor:self.classNormalTextColor forState:UIControlStateNormal];
        [l setTitleColor:self.classSelectedTextColor forState:UIControlStateSelected];
        [l setTitleColor:self.classHighlightedTextColor forState:UIControlStateHighlighted];
        l.userInteractionEnabled = YES;
        [l addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0) {
            if(!self.cursorbg) {
                frame = titleItemView.frame;
                frame.origin.x = dx;
                self.cursorbg = [[UIView alloc] initWithFrame:frame];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_cursorInsets.left, _cursorInsets.top, frame.size.width - _cursorInsets.left - _cursorInsets.right, frame.size.height - _cursorInsets.top - _cursorInsets.bottom)];
                imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                imageView.backgroundColor = self.classSelectedBackgroundColor;
                self.cursorBgimageView = imageView;
                switch (self.viewPagerTitleStyle) {
                    case ViewPagerTitleStyleBackgroundColor: {
                        imageView.layer.cornerRadius = imageView.frame.size.height/2;
                        imageView.layer.masksToBounds = YES;
                    }
                        break;
                    default: {
                        
                    }
                        break;
                }
                [self.cursorbg addSubview:imageView];
                
                [_titleScrollView addSubview:self.cursorbg];
            } else {
                [self.cursorbg removeFromSuperview];
                frame = titleItemView.frame;
                frame.origin.x = dx;
                [self.cursorbg setFrame:frame];
                switch (self.viewPagerTitleStyle) {
                    case ViewPagerTitleStyleBackgroundColor: {
                        self.cursorBgimageView.layer.cornerRadius = self.cursorBgimageView.frame.size.height/2;
                        self.cursorBgimageView.layer.masksToBounds = YES;
                    }
                        break;
                    default: {
                        
                    }
                        break;
                }
                self.cursorBgimageView.backgroundColor = self.classSelectedBackgroundColor;
                [_titleScrollView addSubview:self.cursorbg];
            }
        }
        if(i == _pageIndexa) {
            [l setSelected:YES];
            if(self.cursorbg) {
                frame = titleItemView.frame;
                frame.origin.x = dx;
                self.cursorbg.frame = frame;
            }
        }
        l.backgroundColor = [UIColor clearColor];
        [l setTitle:vC.title forState:UIControlStateNormal];
        [titleItemView addSubview:l];
        [self.titleButtons addObject:l];
        [_titleScrollView addSubview:titleItemView];
        dx += width + _titleMarginHa;
        
        UIView *contentView = vC.view;
        CGRect rect = contentView.frame;
        rect.origin.x = cx;
        rect.origin.y = 0;
        rect.size.height = _scrollView.frame.size.height;
        rect.size.width = _scrollView.frame.size.width;
        contentView.frame = rect;
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.viewArrays insertObject:contentView atIndex:i];
        cx += _scrollView.frame.size.width;
    }
    self.cursorBgimageView.backgroundColor = self.classSelectedBackgroundColor;
    titleframe.size.width = dx + _sgContentView.bounds.size.width * 2;
    [titlebg setFrame:titleframe];
    [_titleScrollView setContentSize:CGSizeMake(dx, 1)];
    [_scrollView setContentSize:CGSizeMake(cx, 1)];
    [self displayNeededView];
}

- (UIViewController *)getPageWithIndex:(NSInteger)index {
    if ([self.childViewControllers count] > index) {
        return [self.childViewControllers objectAtIndex:index];
    }
    return nil;
}

- (void)pageChange {
    id<ViewPagerDelegate> c = nil;
    if([self.childViewControllers count] > _pageIndexa) {
        c = self.childViewControllers[_pageIndexa];
    }
    if(c && [c respondsToSelector:@selector(pageWillShow)]) {
        [c performSelector:@selector(pageWillShow)];
    }
    
    [self displayNeededView];
    [self hiddenNotNeededView];
    
}

- (void)hiddenAllView {
    for (int i = 0; i < [self.viewArrays count]; i++) {
        UIView *view = [self.viewArrays objectAtIndex:i];
        if ([view superview]) {
            [view removeFromSuperview];
        }
    }
}

- (void)scrollCurrentViewToTop {
    UIViewController<ViewPagerDelegate> *c = nil;
    if ([self.childViewControllers count] > _pageIndexa) {
        c = [self.childViewControllers objectAtIndex:_pageIndexa];
    }
    if (c && [c respondsToSelector:@selector(scrollContentToTop)]) {
        [c performSelector:@selector(scrollContentToTop)];
    }
}

- (void)hiddenOtherView {
    for (int i = 0; i < [self.viewArrays count]; i ++) {
        if (i == _pageIndexa) {
            continue;
        }
        UIView *view = [self.viewArrays objectAtIndex:i];
        if ([view superview]) {
            [view removeFromSuperview];
        }
    }
}

- (void)hiddenNotNeededView {
    for (int i = 0; i < [self.viewArrays count]; i ++) {
        if (i == _pageIndexa || i == _pageIndexa - 1 || i == _pageIndexa + 1) {
            continue;
        }
        UIView *view = [self.viewArrays objectAtIndex:i];
        if ([view superview]) {
            [view removeFromSuperview];
        }
    }
}

- (void)displayNeededView {
    [self displayCurrentView];
    [self displayMoreView];
}

- (void)displayCurrentView {
    [self displayTheView:_pageIndexa];
}

- (void)displayMoreView {
    [self displayTheView:_pageIndexa - 1];
    [self displayTheView:_pageIndexa + 1];
}

- (void)displayTheView:(NSInteger)index {
    if (index >= 0 && index < [self.viewArrays count]) {
        UIView *newView = [self.viewArrays objectAtIndex:index];
        if (![newView superview]) {
            if ([newView frame].size.height != self.scrollView.frame.size.height) {
                CGRect frame = [newView frame];
                frame.size.height = self.scrollView.frame.size.height;
                [newView setFrame:frame];
            }
            [self.scrollView addSubview:newView];
        }
    }
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"frame" context:nil];
    [_sgContentView removeObserver:self forKeyPath:@"frame" context:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
