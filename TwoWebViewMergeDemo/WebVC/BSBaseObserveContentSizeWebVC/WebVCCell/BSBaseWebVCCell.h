//
//  BSMarketDataWebCell.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/07/06.
//  Copyright © 2022 huanghuaxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseWebViewController.h"


NS_ASSUME_NONNULL_BEGIN

// webVCCell类型
typedef enum : NSUInteger {
    NativeWebVCCellType = 0, // 最好页面内容高度固定，不要下拉加载
    ThirdWebVCCellType,      // 支持无限下拉加载，也支持内容高度固定
} WebVCCellType;

@class BSBaseWebVCCell;
@protocol BSNativeWebCellDelegate <NSObject>
@optional
- (void)webVCCellType:(WebVCCellType)cellType height:(CGFloat)height;

@end
/// 首页底部讨论区的web cell
@interface BSBaseWebVCCell : UITableViewCell

@property (weak, nonatomic) id<BSNativeWebCellDelegate> delegate;
@property (copy, nonatomic) NSString *url;
@property (assign, nonatomic) WebVCCellType cellType;
@property (strong, nonatomic) BSBaseWebViewController *webVC;
@property (strong, nonatomic) UIScrollView *webVCScrollView;

- (void)initialWebVCWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
