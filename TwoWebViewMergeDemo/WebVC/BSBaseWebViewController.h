//
//  BSBaseWebViewController.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2018/10/8.
//  Copyright © 2018年 huanghuaxing. All rights reserved.
//

#import "UIKit/UIKit.h"
#import <WebKit/WebKit.h>
// category
#import "NSString+URLArguments.h"

NS_ASSUME_NONNULL_BEGIN

// webVC使用
typedef void (^WebCallBackBlock)(_Nullable id object);

/**
 内部使用的webVC（与原生交互接口更多，权限更大）
 */
@interface BSBaseWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *titleBottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightSecondBtn;

@property (nonatomic, strong) WKWebView *dwkWebView;

@property (nonatomic, assign) BOOL bIsShare;        // 是否可以分享（目前该字段不生效，改为由H5来控制是否显示）
@property (nonatomic, assign) BOOL bIsSetting;      // 是否显示设置
@property (nonatomic, copy, nullable) NSString *url;          // url
@property (nonatomic, copy, nullable) NSString *titleStr;     // 导航标题（如果为空，则会自动读取h5的title）
@property (nonatomic, strong) id params;            // 打开第三方页面post参数
@property (nonatomic, assign) BOOL bIsDisableMenu;  // 是否关闭 选择复制粘贴等菜单功能
@property (nonatomic, assign) BOOL bIsHideTitleView;// 是否隐藏自定义导航
// 是否第三方H5页面(默认为NO)   2020.06.10
@property (nonatomic, assign) BOOL bIsThirdPartyWebVC;
@property (nonatomic, assign) BOOL bIsAutoPlayMedia;// 是否自动播放视频（默认自动播放）
@property (nonatomic, assign) BOOL bIsAddTapSlideView;// 是否添加侧滑返回view（默认添加）

// 分享内容
@property (nonatomic, copy) NSString *shareUrl;          // 分享链接
@property (nonatomic, copy) NSString *shareTitle;        // 分享标题
@property (nonatomic, copy) NSString *sharePath;         // 分享路径(小程序专用)
@property (nonatomic, copy) NSString *shareSummary;      // 分享描述(日涨幅+净值信息等)
@property (nonatomic, copy) NSString *shareThumbImageUrl;// 分享时显示的缩略图（替代内容截图）

@property (nonatomic, copy) NSString *shareImageUrl;     // 分享图片链接（分享大图专用，可选）
@property (nonatomic, copy) NSString *shareImageBase64;  // 分享图片base64流（分享大图专用，可选）

@property (nonatomic, copy) NSString *isSharePoster;     // 是否分享海报(可选)

// 右边距离title的距离设置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleOfMerginRight;

// 重新刷新最大次数（默认最大2次则停止）
@property (nonatomic, assign) NSUInteger webViewReloadMaxCount;

// 点击右侧图标回调的参数   2021.11.16
@property (nonatomic, copy) NSString *rightClickFlag;
// 点击右侧第二个图标回调的参数 
@property (nonatomic, copy) NSString *rightSecondClickFlag;
// 是否自定义导航右边按钮(目前仅用于第三方H5页面)
@property (nonatomic, assign) BOOL bIsCustomNavRightBtn;

// 是否 一级H5页面 (默认为NO，比如智投、社区、财富页面)
@property (nonatomic, assign) BOOL bIsFirstLevelWebVC;


- (void)initView;

/// 重新加载DWKWebView
- (void)reloadDWKWebView;

/// 重新加载新url页面
/// @param url url地址
- (void)reloadDWKWebViewWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
