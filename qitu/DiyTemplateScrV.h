//
//  DiyTemplateScrV.h
//  qitu
//
//  Created by 上海企图 on 16/4/19.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiyTemplateScrV : UIScrollView
@property (strong, nonatomic) NSMutableArray *pageMArr;
- (instancetype)initWithFrame:(CGRect)frame withData:(NSMutableArray *)dataItems;
@end
