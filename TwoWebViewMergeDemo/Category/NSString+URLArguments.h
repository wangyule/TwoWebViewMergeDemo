//
//  NSString+URLArguments.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 18-10-08.
//  Copyright (c) 2018年 huanghuaxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLArguments)

#pragma mark - url 编码 和 解码

// url编码（指示确定需要转义的字符）
- (NSString *)gtm_stringByEscapingForURLArgument;

// url解码
- (NSString *)gtm_stringByUnescapingFromURLArgument;

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

@return 编码后的url
*/
- (NSString *)urlEncodingForContainChinese;


#pragma mark - url后面添加参数 和 url后面参数 转为 dictionary

/**
 url后面添加参数
 
 @param dict 参数字典
 @return 带参数url string
 */
- (NSString *)addKeyValueParamAfterUrlWithDict:(NSDictionary *)dict;

/**
 url后面参数 转为 dictionary
 
 @return 参数字典
 */
- (NSDictionary *)toDictionaryForUrlParam;


@end
