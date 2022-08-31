//
//  KUtils.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/8/30.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface KUtils : NSObject
{
    
}

// 导航条高度 - 默认为44
+ (CGFloat)navigationBarHeight;

// 状态条高度 - iPhoneX、iPhoneXS、iPhoneXS MAX 状态条高度默认为44，其他都默认为20
+ (CGFloat)statusBarHeight;

@end

NS_ASSUME_NONNULL_END
