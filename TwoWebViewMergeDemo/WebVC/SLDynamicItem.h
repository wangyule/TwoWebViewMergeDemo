//
//  SLDynamicItem.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2021/3/17.
//  Copyright © 2021 huanghuaxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

/// 动力元素  力的作用对象
@interface SLDynamicItem : NSObject <UIDynamicItem>
@property (nonatomic, readwrite) CGPoint center;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readwrite) CGAffineTransform transform;
@end

NS_ASSUME_NONNULL_END
