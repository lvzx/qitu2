//
//  CreatorMainVC.h
//  qitu
//
//  Created by 上海企图 on 16/3/26.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTBuyMainDelegate.h"

@interface CreatorMainVC : UIViewController<QTBuyMainDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end
