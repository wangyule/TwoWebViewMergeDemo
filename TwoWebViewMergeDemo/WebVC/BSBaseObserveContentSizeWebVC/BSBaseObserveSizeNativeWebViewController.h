//
//  BSBaseObserveContentSizeNativeWebViewController.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/7/7.
//  Copyright © 2022 huanghuaxing. All rights reserved.
//

#import "BSBaseWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class BSBaseObserveSizeNativeWebViewController;
@protocol BSBaseObserveSizeNativeWebVCDelegate <NSObject>
@optional
- (void)webVC:(BSBaseWebViewController *)webVC cellHeight:(CGFloat)cellHeight;

@end

@interface BSBaseObserveSizeNativeWebViewController : BSBaseWebViewController

@property (weak, nonatomic) id<BSBaseObserveSizeNativeWebVCDelegate> observeDelegate;

@end

NS_ASSUME_NONNULL_END
