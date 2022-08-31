//
//  BSBaseObserveSizeThirdWebViewController.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/7/7.
//  Copyright © 2022 huanghuaxing. All rights reserved.
//

#import "BSBaseObserveSizeThirdWebViewController.h"
#import "Constants.h"

NSString * const BSThirdWebVCContentSizeKey = @"contentSize";

@interface BSBaseObserveSizeThirdWebViewController ()

@end

@implementation BSBaseObserveSizeThirdWebViewController

- (void)dealloc {
    [self removeWebViewObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addWebViewObserver];
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
    if ([keyPath isEqualToString:BSThirdWebVCContentSizeKey]) {
        // webFrame.size.height为h5页面的实际高度
        CGRect webFrame = self.dwkWebView.frame;
        CGFloat maxHeight = kVIEW_NONAVI_HEIGHT;
        CGFloat contentSizeHeight = self.dwkWebView.scrollView.contentSize.height;
        if (contentSizeHeight > maxHeight) {
            contentSizeHeight = maxHeight;
        }
        
        if (webFrame.size.height == contentSizeHeight) {
            return;
        }

        webFrame.size.height = contentSizeHeight;
        self.dwkWebView.frame = webFrame;
        
//        NSLog(@"BSDiscoverWebViewCell scrollHeight === %lf", contentSizeHeight);
        if (self.observeDelegate && [self.observeDelegate respondsToSelector:@selector(webVC:cellHeight:)]) {
            [self.observeDelegate webVC:self cellHeight:contentSizeHeight];
        }
    }
}

#pragma mark - custom method
 
- (void)addWebViewObserver {
    [self.dwkWebView.scrollView addObserver:self forKeyPath:BSThirdWebVCContentSizeKey options:NSKeyValueObservingOptionNew context:nil];
}
 
- (void)removeWebViewObserver {
    [self.dwkWebView.scrollView removeObserver:self forKeyPath:BSThirdWebVCContentSizeKey];
}

@end
