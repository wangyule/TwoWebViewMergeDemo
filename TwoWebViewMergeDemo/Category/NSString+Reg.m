//
//  NSString+Reg.m
//  TwoWebViewMergeDemo
//
//  Created by fugui on 16/1/29.
//
//

#import "NSString+Reg.h"


@implementation NSString (Reg)

/**
 是否包含中文

 @return YES OR NO
 */
- (BOOL)isChinese {
    if (self.length > 0) {
        return NO;
    }
    
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fcc)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark 用于判断字符串在另一个字符串中是否包含，不区分大小写
- (BOOL)isConstaintTheStringWithOther:(NSString *)otherString {
    NSRange range = [self rangeOfString:otherString options:NSCaseInsensitiveSearch];
    if (range.length > 0) {
        return YES;
    }
    return NO;
}

@end
