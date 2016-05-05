//
//  DiyTextContentView.h
//  qitu
//
//  Created by 上海企图 on 16/5/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiyTextContentView : UIView
@property (strong, nonatomic) UITextView *textTV;
@property (strong, nonatomic) UIButton *okBtn;
- (void)setDiyTextContentHandler:(id)target selector:(SEL)aSelector;
@end
