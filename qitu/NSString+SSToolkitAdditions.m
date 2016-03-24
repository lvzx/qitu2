//
//  NSString+SSToolkitAdditions.m
//  qitu
//
//  Created by 上海企图 on 16/3/24.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "NSString+SSToolkitAdditions.h"
#import "NSData+SSToolkitAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SSToolkitAdditions)
- (BOOL)containsString:(NSString *)string {
    return !NSEqualRanges([self rangeOfString:string], NSMakeRange(NSNotFound, 0));
}


- (NSString *)MD5Sum {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    return [data MD5Sum];
}


- (NSString *)SHA1Sum {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    return [data SHA1Sum];
}


- (NSString *)SHA256Sum {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    return [data SHA256Sum];
}


// Adapted from http://snipplr.com/view/2771/compare-two-version-strings
- (NSComparisonResult)compareToVersionString:(NSString *)version {
    // Break version into fields (separated by '.')
    NSMutableArray *leftFields  = [[NSMutableArray alloc] initWithArray:[self  componentsSeparatedByString:@"."]];
    NSMutableArray *rightFields = [[NSMutableArray alloc] initWithArray:[version componentsSeparatedByString:@"."]];
    
    // Implict ".0" in case version doesn't have the same number of '.'
    if ([leftFields count] < [rightFields count]) {
        while ([leftFields count] != [rightFields count]) {
            [leftFields addObject:@"0"];
        }
    } else if ([leftFields count] > [rightFields count]) {
        while ([leftFields count] != [rightFields count]) {
            [rightFields addObject:@"0"];
        }
    }
    
    // Do a numeric comparison on each field
    for (NSUInteger i = 0; i < [leftFields count]; i++) {
        NSComparisonResult result = [[leftFields objectAtIndex:i] compare:[rightFields objectAtIndex:i] options:NSNumericSearch];
        if (result != NSOrderedSame) {
            return result;
        }
    }
    
    return NSOrderedSame;
}


#pragma mark - HTML Methods

- (NSString *)escapeHTML {
    NSMutableString *s = [NSMutableString string];
    
    NSUInteger start = 0;
    NSUInteger len = [self length];
    NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
    
    while (start < len) {
        NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
        if (r.location == NSNotFound) {
            [s appendString:[self substringFromIndex:start]];
            break;
        }
        
        if (start < r.location) {
            [s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
        }
        
        switch ([self characterAtIndex:r.location]) {
            case '<':
                [s appendString:@"&lt;"];
                break;
            case '>':
                [s appendString:@"&gt;"];
                break;
            case '"':
                [s appendString:@"&quot;"];
                break;
                //			case '…':
                //				[s appendString:@"&hellip;"];
                //				break;
            case '&':
                [s appendString:@"&amp;"];
                break;
        }
        
        start = r.location + 1;
    }
    
    return s;
}


- (NSString *)unescapeHTML {
    NSMutableString *s = [NSMutableString string];
    NSMutableString *target = [self mutableCopy];
    NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    
    while ([target length] > 0) {
        NSRange r = [target rangeOfCharacterFromSet:chs];
        if (r.location == NSNotFound) {
            [s appendString:target];
            break;
        }
        
        if (r.location > 0) {
            [s appendString:[target substringToIndex:r.location]];
            [target deleteCharactersInRange:NSMakeRange(0, r.location)];
        }
        
        if ([target hasPrefix:@"&lt;"]) {
            [s appendString:@"<"];
            [target deleteCharactersInRange:NSMakeRange(0, 4)];
        } else if ([target hasPrefix:@"&gt;"]) {
            [s appendString:@">"];
            [target deleteCharactersInRange:NSMakeRange(0, 4)];
        } else if ([target hasPrefix:@"&quot;"]) {
            [s appendString:@"\""];
            [target deleteCharactersInRange:NSMakeRange(0, 6)];
        } else if ([target hasPrefix:@"&#39;"]) {
            [s appendString:@"'"];
            [target deleteCharactersInRange:NSMakeRange(0, 5)];
        } else if ([target hasPrefix:@"&amp;"]) {
            [s appendString:@"&"];
            [target deleteCharactersInRange:NSMakeRange(0, 5)];
        } else if ([target hasPrefix:@"&hellip;"]) {
            [s appendString:@"…"];
            [target deleteCharactersInRange:NSMakeRange(0, 8)];
        } else {
            [s appendString:@"&"];
            [target deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    
    return s;
}


#pragma mark - Base64 Encoding

- (NSString *)base64EncodedString  {
    if ([self length] == 0) {
        return nil;
    }
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    //return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}


+ (NSString *)stringWithBase64String:(NSString *)base64String {
    return [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
    //return [[NSString alloc] initWithData:[NSData dataWithBase64String:base64String] encoding:NSUTF8StringEncoding];
}





- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)stringByTrimingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSUInteger)numberOfLines
{
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}


-(BOOL)isChinese
{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

#pragma mark - IdentifierValidator类的信用卡校验用到
- (BOOL)isStartWithString:(NSString *)string{
    int temp = [string intValue];
    
    switch (temp) {
        case 4:
            return NO;
            break;
        case 34:
            return NO;
            break;
        case 37:
            return NO;
            break;
        case 6011:
            return NO;
            break;
            
        default:
            break;
    }
    return YES;
}


@end
