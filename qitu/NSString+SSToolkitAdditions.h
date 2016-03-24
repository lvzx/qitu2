//
//  NSString+SSToolkitAdditions.h
//  qitu
//
//  Created by 上海企图 on 16/3/24.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SSToolkitAdditions)
- (BOOL)containsString:(NSString *)string;

- (NSString *)MD5Sum;


- (NSString *)SHA1Sum;


- (NSString *)SHA256Sum;

//比较版本号
- (NSComparisonResult)compareToVersionString:(NSString *)version;


- (NSString *)escapeHTML;
- (NSString *)unescapeHTML;


- (NSString *)base64EncodedString;
+ (NSString *)stringWithBase64String:(NSString *)base64String;





/********************** add by zzc ***************************/

- (NSString *)trim;


- (NSString *)stringByTrimingWhitespace;


- (NSUInteger)numberOfLines;


- (BOOL)isChinese;

- (BOOL)isStartWithString:(NSString *)string;

@end
