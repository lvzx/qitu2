//
//  CreatorCollectionCell.m
//  qitu
//
//  Created by 上海企图 on 16/3/28.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "CreatorCollectionCell.h"

@implementation CreatorCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.imgView];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame)-35, CGRectGetWidth(self.frame), 21)];
        self.text.font = [UIFont systemFontOfSize:15.0];
//        self.text.backgroundColor = [UIColor brownColor];
        self.text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.text];
    }
    return self;
}
@end
