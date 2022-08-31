//
//  BSBaseObserveContentSizeNativeWebViewController.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/7/7.
//  Copyright © 2022 huanghuaxing. All rights reserved.
//

#import "BSBaseObserveSizeNativeWebViewController.h"

NSString * const BSNativeWebVCContentSizeKey = @"contentSize";

#define kHomeIndicatorHeight    34.0f

@interface BSBaseObserveSizeNativeWebViewController ()
// 记录上次登录状态
@property (nonatomic, assign) BOOL lastLoginStatus;

@end

@implementation BSBaseObserveSizeNativeWebViewController

- (void)dealloc {
    [self removeWebViewObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addWebViewObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - super method

- (void)initView {
    [super initView];
    self.bIsHideTitleView = YES;
//    self.bIsFirstLevelWebVC = YES;
}

#pragma mark - KVO
 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // 防止滚动一直刷新，出现闪屏
    if ([keyPath isEqualToString:BSNativeWebVCContentSizeKey]) {
        // webFrame.size.height为h5页面的实际高度
        CGRect webFrame = self.dwkWebView.frame;
//        CGFloat maxHeight = kVIEW_NONAVI_HEIGHT - kTabBar_Height;
        CGFloat contentSizeHeight = self.dwkWebView.scrollView.contentSize.height;
//        if (contentSizeHeight > maxHeight) {
//            contentSizeHeight = maxHeight;
//        }
        
        // 34.0为iPhoneX以上手机的底部的home indicator高度
        if (webFrame.size.height == contentSizeHeight - kHomeIndicatorHeight) {
            return;
        }

        webFrame.size.height = contentSizeHeight;
        self.dwkWebView.frame = webFrame;
        
        NSLog(@"BSDiscoverWebViewCell scrollHeight === %lf", contentSizeHeight);
        if (self.observeDelegate && [self.observeDelegate respondsToSelector:@selector(webVC:cellHeight:)]) {
            [self.observeDelegate webVC:self cellHeight:contentSizeHeight];
        }
    }
}

#pragma mark - custom method

- (void)addWebViewObserver {
    [self.dwkWebView.scrollView addObserver:self forKeyPath:BSNativeWebVCContentSizeKey options:NSKeyValueObservingOptionNew context:nil];
}
 
- (void)removeWebViewObserver {
    [self.dwkWebView.scrollView removeObserver:self forKeyPath:BSNativeWebVCContentSizeKey];
}

@end
