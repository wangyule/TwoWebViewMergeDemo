//
//  BSBaseWebViewController.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2018/10/8.
//  Copyright © 2018年 huanghuaxing. All rights reserved.
//

#import "BSBaseWebViewController.h"
#import <WebKit/WebKit.h>
#import "CustomWKProcessPool.h"
#import "Masonry/Masonry.h"
#import "SDWebImage/SDInternalMacros.h"
#import "Constants.h"

#define kCOLORRGB(r,g,b)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


//NSString * const ShareShowKey = @"show";
// 监听页面标题key
NSString * const WebViewTitleKey = @"title";

// 查看/新增日历提醒key
NSString * const ModifyTypeKey = @"modifyType";     // 操作类型key(“0”-查看, “1”-添加)
NSString * const ModifyResultKey = @"modifyResult"; // “0”代表删除提醒成功；“1”代表添加提醒成功
NSString * const RemindStatusKey = @"remindStatus"; // “1”代表已添加； “0”代表未添加

@interface BSBaseWebViewController ()<WKNavigationDelegate, WKUIDelegate>
// webview重新刷新次数（超过最大次数则停止）
@property (nonatomic, assign) NSUInteger webViewReloadCount;
// 页面已经加载标题title
@property (nonatomic, assign) BOOL webVeiewHasLoadTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnWidthConstraint;
// 是否第一次调用viewWillAppear 标识
@property (nonatomic, assign) BOOL bIsFirstViewWillAppear;

@end

@implementation BSBaseWebViewController

/**
 加载controller控制器xib页面时，调用；但加载storyboard页面时，不会调用
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initView];
    }
    return self;
}

/**
 加载controller控制器xib页面和storyboard页面时时，都不会调用init；
 但是调用init方法时，会自动调用initWithNibName，所以初始化参数写在initWithNibName方面里面
 */
- (instancetype)init {
    self = [super init];
    if (self) {
//        [self initView];
    }
    
    return self;
}

// 移除监听   2019.11.04
- (void)dealloc {
    [self.dwkWebView removeObserver:self forKeyPath:WebViewTitleKey context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.bIsHideTitleView) {
        self.title = self.titleStr;
    } else {
        // 使用了自定义导航
       self.titleLbl.text = self.titleStr;
       self.titleLbl.adjustsFontSizeToFitWidth = YES;
    }
   
    self.shareBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.shareBtn.hidden = YES;
    
    self.rightSecondBtn.hidden = YES;
    self.backBtn.hidden = NO;

    
    [self initDWKWebView];
    
    // 是否隐藏自定义导航
    [self hideTitleView:self.bIsHideTitleView];
    
    // 添加监听H5页面标题title变化   2019.11.04
    [self.dwkWebView addObserver:self forKeyPath:WebViewTitleKey options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - WkWebViewDelegate: WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    /**
     出现NSURLErrorDomain Code=-999的根本原因是什么呢？其实就是因为webview在之前的请求还没有加载完成，
     下一个请求发起了，此时webview会取消掉之前的请求，因此会回调到失败这里。
     因此，在处理Webview的加载失败的回调时，要注意拦截掉被取消的请求。
     
     出现场景举例：
     场景1：进入一个H5加载的界面，点击内容，跳转到另外一个H5界面，然后，点击H5的导航返回按钮，
     重新加载上一个界面，直接告知加载失败（NSURLErrorCancelled）。
     场景2：启动APP，先点击“发现”,加载讨论区完后，点击“我的”进行快捷登录成功后，会重新reload“发现页面”底部的讨论区内容，
     此时就会告知加载失败（NSURLErrorCancelled）。
     */
    if (error.code == NSURLErrorCancelled) {
        // 请求被取消时，不弹框提示，直接返回
        return;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                            NSURLCredential *__nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

/*在 UIWebView 上当内存占用太大的时候，App Process 会 crash；而在 WKWebView 上当总体的内存占用比较大的时候，
 WebContent Process 会 crash，从而出现白屏现象，这个时候 WKWebView.URL 会变为 nil, 简单的 reload 刷新操作
 已经失效，对于一些长驻的H5页面影响比较大。iOS 9以后 WKNavigtionDelegate 新增了一个回调函数：
 - (void)webViewWebContentProcessDidTerminate:(WKWebView *)webViewAPI_AVAILABLE(macosx(10.11),ios(9.0));
 当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用上面的回调函数，我们在该函数里执行[webView reload](这个时候 webView.URL 取值尚不为 nil）解决白屏问题。在一些高内存消耗的页面可能会频繁刷新当前页面，H5侧也要做相应的适配操作。
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macos(10.11), ios(9.0)) {
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *urlStr = [URL absoluteString];

    if (urlStr && urlStr.length > 0 && ![urlStr hasPrefix:@"http"] && navigationAction.targetFrame) {
        //不包含http前缀 且 navigationAction.targetFrame不为空则表示是内部跳转
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
    else if (URL && [[URL host] isEqualToString:@"itunes.apple.com"]) {
        // 跳转appStore：解决webView自动跳转AppStore后，返回app时，会回调didFailProvisionalNavigation报错
        [[UIApplication sharedApplication] openURL:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        //包含http前缀 且 为空的时候说明是跳转一个新页面。所以需要特殊处理
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - WKUIDelegate   2021.11.01

// iOS8之后弃用UIAlertView，实现self.DSUIDelegate代理方法
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
    [self showAlertControllerWithMessage:prompt confirmBlock:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler(defaultText);
        }
    } cancelBlock:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler(@"");
        }
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [self showAlertControllerWithMessage:message confirmBlock:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    [self showAlertControllerWithMessage:message confirmBlock:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler(YES);
        }
    } cancelBlock:^(UIAlertAction *action) {
        if (completionHandler) {
            completionHandler(NO);
        }
    }];
}

#pragma mark - IBAction
/**
 返回

 @param sender sender
 */
- (IBAction)backClick:(id)sender {
    if ([_dwkWebView canGoBack]) {
        [_dwkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// 设置按钮 - 目前是视频播放
/// @param sender sender
- (IBAction)rightSecondClick:(id)sender {

}

/**
 分享

 @param sender sender
 */
- (IBAction)shareClick:(id)sender {
//    [self shareWithParams:nil block:nil];
}

#pragma mark - observe监听

// 根据监听 实时修改title   2019.11.04
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if (self.bIsHideTitleView) {
        self.title = self.dwkWebView.title;
    } else {
        self.titleLbl.text = self.dwkWebView.title;
    }
}

#pragma mark - custom method

- (void)initView {
    self.bIsDisableMenu = NO;    // 默认不关闭
    self.bIsHideTitleView = NO;  // 默认显示自定义导航
    self.bIsThirdPartyWebVC = NO;// 默认为内部H5页面
    self.bIsAutoPlayMedia = YES; // 默认自动播放
    self.webViewReloadCount = 0; // 初始化默认为0
    self.webViewReloadMaxCount = 2; // 默认最大2次
    self.bIsFirstLevelWebVC = NO; // 默认不是 一级H5页面
    self.bIsAddTapSlideView = YES;// 默认添加（一级H5页面不添加）
}

/// 创建URLRequest
/// @param urlStr 链接地址
- (NSMutableURLRequest *)createURLRequestWithUrlString:(NSString *)urlStr {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    
    if (self.params) {
        // self.params为招行一网通鉴权 传递参数
        NSData *data = nil;
        if ([self.params isKindOfClass:[NSString class]]) {
            /**
             由于self.params(base64编码格式)参数中可能出现了+号，如果直接NSUTF8StringEncoding编码，
             则+号会被转化为空格，导致解码失败，建议对数据进行url编码。  2019.10.29
             */
            NSString *params = [self.params gtm_stringByEscapingForURLArgument];
            // 将data= 改为 jsonRequestData=   2020.12.11
            params = [NSString stringWithFormat:@"jsonRequestData=%@", params];
            data = [params dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded;text/html;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
    }
    
    return request;
}

- (void)initDWKWebView {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    if (@available(iOS 9.0, *)) {
        config.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
    } else {
        // Fallback on earlier versions
    }
    
    // 默认为NO，会导致播放H5页面视频时，默认全屏模式。设置为YES，则不会   2020.05.21
    config.allowsInlineMediaPlayback = YES;
    
    // 控制是否自动播放视频（默认自动播放）- 去除废弃方法警告   2021.08.17
    if (self.bIsAutoPlayMedia) {
        if (@available(iOS 10.0, *)) {
            config.mediaTypesRequiringUserActionForPlayback = NO;
        } else {
            // Fallback on earlier versions
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            config.mediaPlaybackRequiresUserAction = NO;
#pragma clang diagnostic pop
            
        }
    }
    
    WKWebView *dwkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    dwkWebView.navigationDelegate = self;
    dwkWebView.UIDelegate = self; // 适配UIAlertView被废弃   2021.11.01
    dwkWebView.scrollView.backgroundColor = kCOLORRGB(243, 244, 247);
    dwkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    dwkWebView.scrollView.showsVerticalScrollIndicator = NO;

//    dwkWebView.bIsDisableMenu = self.bIsDisableMenu;
//    dwkWebView.isDisableCopy = YES;      // 默认禁用复制
//    dwkWebView.isDisableSelect = YES;    // 默认禁用选择
//    dwkWebView.isDisableSelectAll = YES; // 默认禁用全选
    [self.view addSubview:dwkWebView];
    self.dwkWebView = dwkWebView;
    
    @weakify(self);
    [dwkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view.mas_left);
        
        // 去掉警告日志：约束统一   2022.04.19
//        make.top.equalTo(self.titleView.mas_bottom);
        make.top.mas_equalTo(self.titleHeight.constant);
        
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
        // 对url中有中文进行编码，否则打不开（可避免反复编码的问题）
    NSString *urlStr = [self.url urlEncodingForContainChinese];
    NSMutableURLRequest *request = [self createURLRequestWithUrlString:urlStr];
    [dwkWebView loadRequest:request];
}

//URL编码
- (NSString *)encodeString:(NSString*)unencodedString {
    NSString *encodeUrl = [unencodedString gtm_stringByEscapingForURLArgument];
    return encodeUrl;
}

/**
 是否隐藏自定义导航标题view

 @param hidden YES OR NO
 */
- (void)hideTitleView:(BOOL)hidden {
    self.titleView.hidden = hidden;
    self.titleHeight.constant = hidden ? 0 : kNAV_ADD_STAURSBAR_HEIGHT;
    
    // 去掉警告日志：约束统一   2022.04.19
    @weakify(self);
    [self.dwkWebView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
//            make.top.equalTo(self.titleView.mas_bottom); // 不生效
        make.top.mas_equalTo(self.titleHeight.constant);
    }];
    
    if (!hidden) {
        self.titleLbl.text = self.titleStr.length > 0 ? self.titleStr : self.dwkWebView.title;
    }
}

/// 重新加载DWKWebView   2021.12.03
- (void)reloadDWKWebView {
    [self.dwkWebView reload];
}

/// 重新加载新url页面
/// @param url url地址
- (void)reloadDWKWebViewWithUrl:(NSString *)url {
    // 对url中有中文进行编码，否则打不开（可避免反复编码的问题）
    NSString *urlStr = [url urlEncodingForContainChinese];
    NSMutableURLRequest *request = [self createURLRequestWithUrlString:urlStr];
    [self.dwkWebView loadRequest:request];
}

#pragma mark - UIAlertController

/// 提示弹框
/// @param title 标题
/// @param message 内容
/// @param preferredStyle 风格
/// @param confirmTitle 确定按钮标题
/// @param confirmBlock 确定回调
/// @param cancelTitle 取消按钮标题
/// @param cancelBlock 取消回调
- (void)showAlertControllerWithTitle:(NSString *)title
                             message:(NSString *)message
                      preferredStyle:(UIAlertControllerStyle)preferredStyle
                        confirmTitle:(NSString *)confirmTitle
                        confirmBlock:(void (^ __nullable)(UIAlertAction *action))confirmBlock
                         cancelTitle:(nullable NSString *)cancelTitle
                         cancelBlock:(void (^ __nullable)(UIAlertAction *action))cancelBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (confirmTitle.length > 0) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirmBlock];
        [alertController addAction:okAction];
    }
    
    if (cancelTitle.length > 0) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelBlock];
        [alertController addAction:cancelAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 提示弹框（默认标题、风格、确定和取消按钮标题）
/// @param message 内容
/// @param confirmBlock 确定回调
/// @param cancelBlock 取消回调
- (void)showAlertControllerWithMessage:(NSString *)message
                        confirmBlock:(void (^ __nullable)(UIAlertAction *action))confirmBlock
                         cancelBlock:(void (^ __nullable)(UIAlertAction *action))cancelBlock {
    [self showAlertControllerWithTitle:@"提示"
                               message:message
                        preferredStyle:UIAlertControllerStyleAlert
                          confirmTitle:@"确定"
                          confirmBlock:confirmBlock
                           cancelTitle:@"取消"
                           cancelBlock:cancelBlock];
}

/// 提示弹框（只有确定按钮，默认标题、风格、确定和取消按钮标题）
/// @param message 内容
/// @param confirmBlock 确定回调
- (void)showAlertControllerWithMessage:(NSString *)message
                        confirmBlock:(void (^ __nullable)(UIAlertAction *action))confirmBlock {
    [self showAlertControllerWithTitle:@"提示"
                               message:message
                        preferredStyle:UIAlertControllerStyleAlert
                          confirmTitle:@"确定"
                          confirmBlock:confirmBlock
                           cancelTitle:nil
                           cancelBlock:nil];
}

@end
