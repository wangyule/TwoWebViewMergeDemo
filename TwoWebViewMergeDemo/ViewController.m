//
//  ViewController.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/8/30.
//

#import "ViewController.h"
#import "BSTwoWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    testBtn.center = self.view.center;
    testBtn.backgroundColor = [UIColor blueColor];
    [testBtn setTitle:@"合并2个webView页面" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}

- (void)btnAction:(id)sender {
    UIViewController *vc = [self getBSTwoWebViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 显示两个H5页面

 @return 行情资讯页面
 */
- (UIViewController *)getBSTwoWebViewController {
    BSTwoWebViewController *vc = [[BSTwoWebViewController alloc] init];
    vc.firstWebUrl = @"https://www.wjx.top/vm/eTohcx3.aspx";
    vc.secondWebUrl = @"https://www.baidu.com";
    vc.firstCellType = NativeWebVCCellType;
    vc.secondCellType = ThirdWebVCCellType;
    return vc;
}

@end
