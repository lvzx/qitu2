//
//  QTBigScrollView.h
//  qitu
//
//  Created by 上海企图 on 16/3/28.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BgScrollViewBlock)(NSInteger index);

@interface QTBigScrollView : UIScrollView

- (id)initWithcontroller:(UIViewController *)VC TitleArr:(NSArray *)titleArr;

-(void)setBgScrollViewContentOffset:(NSInteger)index;

@property(nonatomic, copy)BgScrollViewBlock Bgbolck;

@end
