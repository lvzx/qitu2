//
//  QTSlideBtnView.h
//  qitu
//
//  Created by 上海企图 on 16/3/28.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SBViewBlock)(NSInteger index);

@interface QTSlideBtnView : UIScrollView
@property(nonatomic, strong)NSArray *titleArr;

- (id)initWithcontroller:(UIViewController *)VC TitleArr:(NSArray *)titleArr;

-(void)setSBScrollViewContentOffset:(NSInteger)index;

@property(nonatomic, copy)SBViewBlock sbBlock;

@end
