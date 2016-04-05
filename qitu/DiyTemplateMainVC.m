//
//  DiyTemplateMainVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/31.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyTemplateMainVC.h"
#import "SelectBgColor.h"
#import "DiyBottomBar.h"
@interface DiyTemplateMainVC ()<SelectBgColorDelegate>
{
    NSArray *bgColors;
}
@end

@implementation DiyTemplateMainVC
- (void)viewDidLoad {
    [super viewDidLoad];
    DiyBottomBar *diyBottomBar = [[DiyBottomBar alloc] initWithFrame:CGRectMake(0, 105, kScreenWidth, 50)];
    
    bgColors = @[@"#040404", @"#FFFFFF", @"#25CDCF", @"#167FA3", @"#17AFEE",
                          @"#59C2F2", @"#3B7FBC", @"#0A4CA9", @"#5248FE", @"#6228F2",
                          @"#676BFB", @"#7751F1", @"#952CBE", @"#CA32AF", @"#F12084"];
    SelectBgColor *bgColorView = [[SelectBgColor alloc] initWithColors:bgColors];
    bgColorView.colorIdx = 1;
    [bgColorView.slider addTarget:self action:@selector(changeAlphaValue) forControlEvents:UIControlEventValueChanged];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-155, kScreenWidth, 155)];
    [bottomView addSubview:bgColorView];
    [bottomView addSubview:diyBottomBar];
    [self.view addSubview:bottomView];
}

#pragma mark - Alpha changed
- (void)changeAlphaValue {

}

#pragma mark - SelectBgColorDelegate
- (void)didSelectBgColor:(NSInteger)colorIdx {

}
@end
