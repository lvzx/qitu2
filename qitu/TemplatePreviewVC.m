//
//  TemplatePreviewVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/30.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "TemplatePreviewVC.h"
#import "QTAPIClient.h"
@import WebKit;

@interface TemplatePreviewVC ()
@property (nonatomic, strong) UIWebView *webView;
@property (assign, nonatomic) BOOL TempAdmode;
@end

@implementation TemplatePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavAndView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavAndView {
    [self setNavTitle:_webTitle];
    [self setNavBackBarSelector:@selector(navBack)];
    [self setNavRightBarBtnTitle:@"购买" selector:@selector(navRightAction)];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    [self getBuyTemplateStatus];
}

- (void)navBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)navRightAction {
    /**
     *  http://api.maka.im/api/storeTemplate/T_6QE7W9IW?dataType=pdata&v=107
     
     dataType	pdata
     v	107
     *
     *  @return <#return value description#>
     */
}

- (void)loadWebView {
    NSString *urlStr = [NSString stringWithFormat:@"http://viewer.maka.im/k/%@?TempAdmode=%@&mode=%@", _templateId, @(_TempAdmode), _mode];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)getBuyTemplateStatus {
    QTAPIClient *QTClient = [QTAPIClient sharedClient];
    NSInteger interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSDictionary *params = @{@"templateId":_templateId, @"token":QTClient.token, @"uid":@(QTClient.uid), @"timestamp":@(interval)};
    NSString *urlStr = [NSString stringWithFormat:@"app/buyTemplate/status/%@", _templateId];
    [QTClient GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject[@"data"];
        self.TempAdmode = [data[@"status"] boolValue];
        [self loadWebView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}
@end
