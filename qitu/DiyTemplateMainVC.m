//
//  DiyTemplateMainVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/31.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyTemplateMainVC.h"
#import "SelectBgColor.h"

@implementation DiyTemplateMainVC
- (void)viewDidLoad {
    [super viewDidLoad];
      NSArray *bgColors = @[@"#040404", @"#FFFFFF", @"#25CDCF", @"#167FA3", @"#17AFEE",
                    @"#59C2F2", @"#3B7FBC", @"#0A4CA9", @"#5248FE", @"#6228F2",
                    @"#676BFB", @"#7751F1", @"#952CBE", @"#CA32AF", @"#F12084"];
    SelectBgColor *bgColorView = [[SelectBgColor alloc] initWithColors:bgColors];
    bgColorView.colorIdx = 1;
    [self.view addSubview:bgColorView];
}


@end
