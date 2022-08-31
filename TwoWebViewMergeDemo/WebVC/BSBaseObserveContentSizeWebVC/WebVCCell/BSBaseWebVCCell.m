//
//  BSMarketDataWebCell.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/07/06.
//  Copyright © 2022 huanghuaxing. All rights reserved.
//

#import "BSBaseWebVCCell.h"
#import "BSBaseObserveSizeNativeWebViewController.h"
#import "BSBaseObserveSizeThirdWebViewController.h"
#import "Masonry.h"


@interface BSBaseWebVCCell ()
<
BSBaseObserveSizeNativeWebVCDelegate,
BSBaseObserveSizeThirdWebVCDelegate
>

@end

@implementation BSBaseWebVCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self initialView];
    }
    return self;
}

#pragma mark - BSBaseObserveSizeThirdWebVCDelegate

- (void)webVC:(BSBaseWebViewController *)webVC cellHeight:(CGFloat)cellHeight {
    if (_delegate && [_delegate respondsToSelector:@selector(webVCCellType:height:)]) {
       [_delegate webVCCellType:self.cellType height:cellHeight];
    }
}

#pragma mark - custom method

- (void)initialWebVCWithUrl:(NSString *)url {
    if ([self.url isEqualToString:url]) {
        return;
    }
    
    self.url = url;
    
    if (!self.webVC) {
        if (self.cellType == NativeWebVCCellType) {
            // 本地webVC
            BSBaseObserveSizeNativeWebViewController *webVC = [self getBaseObserveSizeNativeWebVCWithUrl:self.url];
            webVC.observeDelegate = self;
            self.webVC = webVC;
        } else {
            // 第三方webVC
            BSBaseObserveSizeThirdWebViewController *webVC = [self getBaseObserveSizeThirdWebVCWithUrl:self.url];
            webVC.observeDelegate = self;
            webVC.dwkWebView.scrollView.scrollEnabled = NO;
            self.webVC = webVC;
        }
        
        [self.contentView addSubview:self.webVC.view];
        [self.webVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        
        self.webVC.dwkWebView.scrollView.scrollEnabled = NO;
        
    } else {
        // 加载新url页面
        [self.webVC reloadDWKWebViewWithUrl:self.url];
    }
}

- (UIScrollView *)webVCScrollView {
    return self.webVC.dwkWebView.scrollView;
}

/// 是否使能滑动事件
//- (void)scrollEnable:(BOOL)enable {
//    if (self.webVC) {
//        self.webVC.dwkWebView.scrollView.scrollEnabled = enable;
//    }
//}
//
///// 是否使能交互事件
//- (void)userInteractionEnabled:(BOOL)enable {
//    if (self.webVC) {
//        self.webVC.view.userInteractionEnabled = enable;
//    }
//}

/// 重新加载webView
//- (void)reloadWebView {
//    [self.marketDataVC.dwkWebView reload];
//}

#pragma mark - /**观察本地/第三方H5页面contentSize的webVC**/

/**
  获取观察本地H5页面contentSize的webVC

 @param url url
 @return webVC
 */
- (BSBaseObserveSizeNativeWebViewController *)getBaseObserveSizeNativeWebVCWithUrl:(NSString *)url {
    BSBaseObserveSizeNativeWebViewController *vc = [[BSBaseObserveSizeNativeWebViewController alloc] initWithNibName:NSStringFromClass([BSBaseWebViewController class]) bundle:nil];
    vc.url = url;
    vc.bIsShare = NO;
    return vc;
}

/**
  获取观察第三方H5页面contentSize的webVC

 @param url url
 @return webVC
 */
- (BSBaseObserveSizeThirdWebViewController *)getBaseObserveSizeThirdWebVCWithUrl:(NSString *)url {
    BSBaseObserveSizeThirdWebViewController *vc = [[BSBaseObserveSizeThirdWebViewController alloc] initWithNibName:NSStringFromClass([BSBaseWebViewController class]) bundle:nil];
    vc.url = url;
    vc.bIsShare = NO;
    return vc;
}

@end
