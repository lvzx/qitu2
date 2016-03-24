//
//  BaseViewController.m
//  qitu
//
//  Created by 上海企图 on 16/3/17.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
// 源码篇：MBProgressHUD http://www.cocoachina.com/ios/20150417/11598.html
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView  *waitBGView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Property

- (MBProgressHUD*)hud
{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
    }
    return _hud;
}

#pragma mark - WaitView等待框

-(void)showHud
{
    self.hud.mode  = MBProgressHUDModeIndeterminate;
    self.hud.labelText  = @"加载中...";
    [self.hud show:YES];
}

-(void)hideHud
{
    [self.hud hide:YES];
}


- (void)showWaitingView
{
    //开始等待动画
    if (self.waitBGView == nil) {
        
        self.waitBGView = [[UIView alloc] initWithFrame:[self.view bounds]];
        [self.waitBGView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(0, 0, 37, 37);
        activityView.center = self.waitBGView.center;
        
        [self.waitBGView addSubview:activityView];
        [self.view addSubview:self.waitBGView];
        [activityView startAnimating];
        
    }
}

- (void)hideWaitingView
{
    //结束动画
    if (self.waitBGView) {
        [self.waitBGView removeFromSuperview];
        self.waitBGView = nil;
    }
}


#pragma mark - Public

- (void)setupView
{}


- (void)showToast:(NSString *)title
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    [hud show:YES];
    [hud hide:YES afterDelay:1.0];
}


- (void)reportNetworkError:(NSError *)error
{
    if ([error.domain isEqualToString:NSURLErrorDomain])
    {
        switch (error.code) {
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorCannotFindHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorNotConnectedToInternet:
            {
                //网络连接错误
                [MyAlertView showWithTitle:@"网络连接错误，请检查网络"
                                    message:nil
                                buttonTitle:@"确定"];
                
                break;
            }
            case NSURLErrorTimedOut:
            {
                //连接超时
                [MyAlertView showWithTitle:@"连接超时"
                                    message:nil
                                buttonTitle:@"确定"];
                break;
            }
                
            default:
                break;
        }
    } else {
        
        //服务器错误
        [MyAlertView showWithTitle:@"服务器错误"
                            message:nil
                        buttonTitle:@"确定"];
    }
}

#pragma mark - 导航栏设置
- (void)setNavBackBarSelector:(SEL)aSelector {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"maka_navbar_return"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"maka_navbar_return"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)setNavLeftBarBtnImg:(UIImage *)img selector:(SEL)aSSelector {
    
}

- (void)setNavRightBarBtnImg:(NSString *)imgStr selector:(SEL)aSelector {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateHighlighted];
    [btn addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtn;
}

- (void)setNavRightBarBtnTitle:(NSString *)title selector:(SEL)aSelector {
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: GLOBAL_NAVIGATIONBAR_BUTTON_TITLE_FONT}];
    CGRect rect = CGRectMake(0, 0, 2*size.width, 2*size.height);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, size.width/2, 0, 0);
    [btn addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtn;
}

- (void)setNavTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (UIBarButtonItem *)getCustomNavBarBtnImgName:(NSString *)imgName title:(NSString *)title selector:(SEL)aSelector{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barBtn;
}

@end
