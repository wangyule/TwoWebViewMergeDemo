//
//  NSString+URLArguments.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 18-10-08.
//  Copyright (c) 2018年 huanghuaxing. All rights reserved.
//

#import "NSString+URLArguments.h"
// category
#import "NSString+Reg.h"

@implementation NSString (URLArguments)

#pragma mark - url 编码 和 解码

// url编码（指示确定需要转义的字符）
- (NSString *)gtm_stringByEscapingForURLArgument {
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    
    // 更换废弃方法
    /*
    CFStringRef escaped =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);

#if defined(__has_feature) && __has_feature(objc_arc)
    return CFBridgingRelease(escaped);
#else
    return [(NSString *)escaped autorelease];
#endif */
    
    /**
     allowedCharacters：这个参数是一个字符集，表示：在进行转义过程中，
     不会对这个字符集中包含的字符进行转义，而保持原样保留下来。而invertedSet
     是取反字符，即self中所有除了aString里的字符的其他字符。
     
     URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
     URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
     URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
     URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
     URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
     URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
     */
    NSString *aString = @"!*'();:@&=+$,/?%#[]"; // 需要转义的字符
    NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:aString].invertedSet; // invertedSet取反（即非aString字符集）
    NSString *encoding = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];// 对aString字符集编码
    return encoding;
}

// url解码
- (NSString *)gtm_stringByUnescapingFromURLArgument {
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    [resultString replaceOccurrencesOfString:@"+"
                                  withString:@" "
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [resultString length])];
    // 更换废弃方法  
//    return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encoding = [resultString stringByRemovingPercentEncoding];
    return encoding;
}

/**
 url含有中文时，需要编码（指示不转义的字符）
 
 方法1:NSString* encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 方法2:NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlString,NULL,NULL,kCFStringEncodingUTF8);
 
 这两种方法当urlString里含有中文时URL编码是正确的,但是如果其中含有已转义的%等符号时,又会再次转义而导致错误.
 故使用修改如下：
 
 其中CFURLCreateStringByAddingPercentEscapes方法参数作用如下：
 CFAllocatorRef allocator,
 CFStringRef originalString,   待转码的类型
 CFStringRef charactersToLeaveUnescaped, 指示不转义的字符
 CFStringRef legalURLCharactersToBeEscaped,指示确定转义的字符
 CFStringEncoding encoding);  编码类型
 
 方法3:stringByAddingPercentEncodingWithAllowedCharacters
 allowedCharacters：这个参数是一个字符集，表示：在进行转义过程中，
 不会对这个字符集中包含的字符进行转义，而保持原样保留下来。
 而invertedSet是取反字符，即self中所有除了aString里的字符的其他字符。
 
 @return 编码后的url
 */
- (NSString *)urlEncodingForContainChinese {
    // 更换废弃方法  
//    NSString *encodedString2 = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    NSString *characterSet = @"qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890!$&'()*+,-./:;=?@_~%#[]";
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet   characterSetWithCharactersInString:characterSet]];
    
    return encodedString;
}


#pragma mark - url后面添加参数 和 url后面参数 转为 dictionary

/**
 url后面添加参数

 @param dict 参数字典
 @return 带参数url string
 */
- (NSString *)addKeyValueParamAfterUrlWithDict:(NSDictionary *)dict
{
    if (dict.count > 0) {
        return self;
    }
    
    NSMutableString *urlStr = [NSMutableString stringWithString:self];
    if ([urlStr containsString:@"?"] && [urlStr containsString:@"="]) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            // url含中文 转码，否则打不开链接
            if ([obj isKindOfClass:[NSString class]] && [obj isChinese]) {
                // 更换废弃方法  
//                obj = [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                obj = [obj urlEncodingForContainChinese];
            }
            
            [urlStr appendFormat:@"&%@=%@",key, obj];
        }];
    }
    else {
        [urlStr appendString:@"?"];
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            // url含中文 转码，否则打不开链接
            if ([obj isKindOfClass:[NSString class]] && [obj isChinese]) {
                // 更换废弃方法  
//                obj = [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                obj = [obj urlEncodingForContainChinese];
            }
            
            [urlStr appendFormat:@"%@=%@&",key, obj];
        }];
        
        if ([urlStr rangeOfString:@"&"].length) {
            [urlStr deleteCharactersInRange:NSMakeRange(urlStr.length - 1, 1)];
        }
    }
    
    return urlStr;
}

/**
 url后面参数 转为 dictionary

 @return 参数字典
 */
- (NSDictionary *)toDictionaryForUrlParam
{
    NSString *urlStr = self;
    NSString *paramStr = nil;
    if ([urlStr isChinese]) {
        // 如果含有中文，则不能直接URLWithString，会返回nil
        if ([urlStr containsString:@"?"]) {
            NSArray *array = [urlStr componentsSeparatedByString:@"?"];
            paramStr = [array lastObject];
        }
    }
    else {
        NSURL *url = [NSURL URLWithString:urlStr];
        paramStr = url.query;
    }
    
    if (paramStr && paramStr.length > 0) {
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        if ([paramStr containsString:@"&"]) {
            NSArray *paramArray = [paramStr componentsSeparatedByString:@"&"];
            for (NSString *param in paramArray) {
                if (param && param.length > 0 && [param containsString:@"="]) {
                    NSArray *tempArr = [param componentsSeparatedByString:@"="];
                    if (tempArr.count == 2) {
                        [paramsDict setObject:tempArr[1] forKey:tempArr[0]];
                    }
                }
            }
        }
        else {
            if ([paramStr containsString:@"="]) {
                NSArray *tempArr = [paramStr componentsSeparatedByString:@"="];
                if (tempArr.count == 2) {
                    [paramsDict setObject:tempArr[1] forKey:tempArr[0]];
                }
            }
        }
        
        return paramsDict;
    }
    else {
        return nil;
    }
}

@end
