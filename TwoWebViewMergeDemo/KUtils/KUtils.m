//
//  KUtils.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/8/30.
//

#import "KUtils.h"
#import "Constants.h"

@implementation KUtils

// 导航条高度 - 默认为44
+ (CGFloat)navigationBarHeight {
    return 44.0;
}

// 状态条高度 - iPhoneX、iPhoneXS、iPhoneXS MAX 状态条高度默认为44，其他都默认为20
+ (CGFloat)statusBarHeight {
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height;

    return height;
}

@end
