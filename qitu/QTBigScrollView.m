//
//  QTBigScrollView.m
//  qitu
//
//  Created by 上海企图 on 16/3/28.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "QTBigScrollView.h"
#import "QTBuyMainView.h"
#import "CategoryItem.h"

#define kContentH kScreenHeight-64-50
#define BaseTag         20000
#define kSlideBtn_H 35
@interface QTBigScrollView ()<UIScrollViewDelegate>

@property(nonatomic, strong)NSArray *titleArr;

@property(nonatomic, strong)NSMutableArray *reuseViewArr;

@property (nonatomic, assign) CGFloat offset;

@end

@implementation QTBigScrollView{
    CGFloat contentOff_X;
    UIView * loadingView;
}

-(id)initWithcontroller:(UIViewController *)VC TitleArr:(NSArray *)titleArr;
{
    self = [super init];
    if (self) {
        self.titleArr = titleArr;
        self.frame = [self getViewFrame];
        self.reuseViewArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate = self;
        self.contentSize = CGSizeMake(kScreenWidth * self.titleArr.count, kContentH - kSlideBtn_H);
        [VC.view addSubview:self];
        [self confingSubViews];
        
    }
    return self;
}

-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    frame.size.height = kContentH - kSlideBtn_H;
    frame.size.width = kScreenWidth;
    frame.origin.x = 0;
    frame.origin.y = kSlideBtn_H;
    return frame;
}

-(void)confingSubViews
{
    NSInteger i = 0;
    for (i = 0; i < 3; i++) {
        CategoryItem *catItem = self.titleArr[i];
        QTBuyMainView *view = [[QTBuyMainView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kContentH - kSlideBtn_H) categoryId:catItem.ID];
        // 添加子视图到scrollview
        [self addSubview:view];
        // 添加view到托管的重用数组
        [self.reuseViewArr addObject:view];
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.offset = scrollView.contentOffset.x;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    contentOff_X = scrollView.contentOffset.x;
    NSInteger index = contentOff_X/kScreenWidth;
    __weak typeof(self) weak = self;
    if (contentOff_X < 0 || contentOff_X > kScreenWidth * (self.titleArr.count - 1)) {
        
    }else{
        if (contentOff_X > self.offset){
            [self initRightView:index Complete:^(QTBuyMainView *view, NSInteger index) {
                [weak reflashUI:view Index:index];
            }];
        }else if (contentOff_X < self.offset){
            [self initRightView:index Complete:^(QTBuyMainView *view, NSInteger index) {
                [weak reflashUI:view Index:index];
            }];
        }
        if (self.Bgbolck) {
            self.Bgbolck(index);
        }
    }
}

-(void)setBgScrollViewContentOffset:(NSInteger)index
{
    [self setContentOffset:CGPointMake(kScreenWidth *index, 0)];
    __weak typeof(self) weak = self;
    
    if (index > 1) {
        [self initRightView:index Complete:^(QTBuyMainView *view, NSInteger index) {
            [weak reflashUI:view Index:index];
        }];
    }
    if (index <= 1) {
        [self initLeftView:index Complete:^(QTBuyMainView *view, NSInteger index) {
            [weak reflashUI:view Index:index];
        }];
    }
}

-(void)removeLeftView:(void(^)(QTBuyMainView *view))completion
{
    QTBuyMainView *View = [self getReuseViewFromArr:0];
    if (completion) {
        completion(View);
    }
}

-(void)removeRightView:(void(^)(QTBuyMainView *view))completion
{
    QTBuyMainView *View = [self getReuseViewFromArr:2];
    if (completion) {
        completion(View);
    }
}
- (void)initRightView:(NSInteger)index Complete:(void(^)(QTBuyMainView *view, NSInteger index))complete
{
    [self removeLeftView:^(QTBuyMainView *view) {
        [self.reuseViewArr removeObject:view];
        [view setFrame:CGRectMake(kScreenWidth *index, 0, kScreenWidth, kContentH - kSlideBtn_H)];
        [self.reuseViewArr addObject:view];
        if (complete) {
            complete(view,index);
        }
    }];
}

- (void)initLeftView:(NSInteger)index Complete:(void(^)(QTBuyMainView *view, NSInteger index))complete
{
    [self removeRightView:^(QTBuyMainView *view) {
        [self.reuseViewArr removeObject:view];
        [view setFrame:CGRectMake(kScreenWidth *index, 0, kScreenWidth, kContentH - kSlideBtn_H)];
        [self.reuseViewArr addObject:view];
        if (complete) {
            complete(view,index);
        }
    }];
}

-(QTBuyMainView *)getReuseViewFromArr:(NSInteger)index
{
    if (self.reuseViewArr[index] == nil) {
        CategoryItem *catItem = self.titleArr[index];
        QTBuyMainView *view = [[QTBuyMainView alloc] initWithFrame:CGRectMake(index * kScreenWidth, 0, kScreenWidth, kContentH - kSlideBtn_H) categoryId:catItem.ID];
        [self.reuseViewArr insertObject:view atIndex:index];
        return view;
    }
    return self.reuseViewArr[index];
}

/**
 *  刷新视图的UI的方法
 */
-(void)reflashUI:(QTBuyMainView *)view Index:(NSInteger)index
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        CategoryItem *catItem = self.titleArr[index];
        view.categoryId = catItem.ID;
        [view getStoreTemplatesByNet];
        dispatch_async(dispatch_get_main_queue(), ^{
            //通知主线程刷新
            [MBProgressHUD hideHUDForView:self animated:YES];
        });
        
    });
}

-(void)delayMethod
{
    
}


@end
