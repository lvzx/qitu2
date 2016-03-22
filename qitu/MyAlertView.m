//
//  MyAlertView.m
//  qitu
//
//  Created by 上海企图 on 16/3/17.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "MyAlertView.h"
@interface MyAlertView ()

@property (nonatomic, copy) MyAlertBlock cancelBlock;
@property (nonatomic, copy) MyAlertBlock otherBlock;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *otherButtonTitle;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
        cancelBlock:(MyAlertBlock)cancelBlock
         otherTitle:(NSString *)otherTitle
         otherBlock:(MyAlertBlock)otherBlock;

@end

@implementation MyAlertView
@synthesize cancelBlock;
@synthesize otherBlock;
@synthesize cancelButtonTitle;
@synthesize otherButtonTitle;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
          buttonTitle:(NSString *)buttonTitle {
    [self showWithTitle:title message:message
            cancelTitle:buttonTitle cancelBlock:nil
             otherTitle:nil otherBlock:nil];
}


+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
          cancelTitle:(NSString *)cancelTitle
          cancelBlock:(MyAlertBlock)cancelBlk
           otherTitle:(NSString *)otherTitle
           otherBlock:(MyAlertBlock)otherBlk {
    [[[self alloc] initWithTitle:title message:message
                     cancelTitle:cancelTitle cancelBlock:cancelBlk
                      otherTitle:otherTitle otherBlock:otherBlk] show];
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
        cancelBlock:(MyAlertBlock)cancelBlk
         otherTitle:(NSString *)otherTitle
         otherBlock:(MyAlertBlock)otherBlk {
    
    if ((self = [super initWithTitle:title
                             message:message
                            delegate:self
                   cancelButtonTitle:cancelTitle
                   otherButtonTitles:otherTitle, nil])) {
        
        if (cancelBlk == nil && otherBlk == nil) {
            self.delegate = nil;
        }
        self.cancelButtonTitle = cancelTitle;
        self.otherButtonTitle = otherTitle;
        self.cancelBlock = cancelBlk;
        self.otherBlock = otherBlk;
    }
    return self;
}


#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:self.cancelButtonTitle]) {
        if (self.cancelBlock) self.cancelBlock();
    } else if ([buttonTitle isEqualToString:self.otherButtonTitle]) {
        if (self.otherBlock) self.otherBlock();
    }
}

- (void)dealloc {
    cancelButtonTitle = nil;
    otherButtonTitle = nil;
    cancelBlock = nil;
    otherBlock = nil;
}

@end
