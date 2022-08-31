//
//  BSTwoWebViewController.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2018/10/11.
//  Copyright © 2018年 huanghuaxing. All rights reserved.
//

#import "BSBaseNativeAndWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSTwoWebViewController : BSBaseNativeAndWebViewController
// 上面H5链接地址
@property (nonatomic, copy) NSString *firstWebUrl;
@property (nonatomic, assign) WebVCCellType firstCellType;
// 下面H5链接地址
@property (nonatomic, copy) NSString *secondWebUrl;
@property (nonatomic, assign) WebVCCellType secondCellType;

@end

NS_ASSUME_NONNULL_END
