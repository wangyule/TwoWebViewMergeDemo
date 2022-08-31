//
//  NSString+Reg.h
//  TwoWebViewMergeDemo
//
//  Created by fugui on 16/1/29.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Reg)

/**
 是否包含中文
 
 @return YES OR NO
 */
- (BOOL)isChinese;

#pragma mark 用于判断字符串在另一个字符串中是否包含，不区分大小写
- (BOOL)isConstaintTheStringWithOther:(NSString *)otherString;

@end
