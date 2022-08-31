//
//  BSBaseObserveSizeThirdWebViewController.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/7/7.
//  Copyright © 2022 huanghuaxing. All rights reserved.
//

#import "BSBaseWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class BSBaseObserveSizeThirdWebViewController;
@protocol BSBaseObserveSizeThirdWebVCDelegate <NSObject>
@optional
- (void)webVC:(BSBaseWebViewController *)webVC cellHeight:(CGFloat)cellHeight;

@end

@interface BSBaseObserveSizeThirdWebViewController : BSBaseWebViewController

@property (weak, nonatomic) id<BSBaseObserveSizeThirdWebVCDelegate> observeDelegate;

@end

NS_ASSUME_NONNULL_END
