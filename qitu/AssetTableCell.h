//
//  AssetTableCell.h
//  qitu
//
//  Created by 上海企图 on 16/4/26.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AssetTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (strong, nonatomic) PHAssetCollection *assetCollection;
@end
