//
//  NSData+SSToolkitAdditions.h
//  qitu
//
//  Created by 上海企图 on 16/3/24.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SSToolkitAdditions)
//返回十六进制字符串
- (NSString *)hexString;

//MD5加密
- (NSString *)MD5Sum;

//SHA1加密
- (NSString *)SHA1Sum;

//SHA256加密
- (NSString *)SHA256Sum;

//AES256加密
- (NSData*)AES256EncryptWithKey:(NSString*)key;

//AES256解密
- (NSData*)AES256DecryptWithKey:(NSString*)key;

@end
