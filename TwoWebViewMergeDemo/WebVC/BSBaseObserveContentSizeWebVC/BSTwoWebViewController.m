//
//  BSTwoWebViewController.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2018/10/11.
//  Copyright © 2018年 huanghuaxing. All rights reserved.
//

// ViewController
#import "BSTwoWebViewController.h"
// View
#import "BSBaseWebVCCell.h"
#import "UITableView+Tools.h"


@interface BSTwoWebViewController ()<BSNativeWebCellDelegate>
// 上面cell的高度
@property (nonatomic, assign) CGFloat firstWebCellHeight;
// 下面cell的高度
@property (nonatomic, assign) CGFloat secondWebCellHeight;

@end

@implementation BSTwoWebViewController

- (void)viewDidLoad {
     [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
         BSBaseWebVCCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BSBaseWebVCCell class]) forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.cellType = self.firstCellType;//NativeWebVCCellType;
         cell.delegate = self;
         [cell initialWebVCWithUrl:self.firstWebUrl];
//         cell.webVC.dwkWebView.scrollView.delegate = self;
         return cell;
     } else {
         BSBaseWebVCCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BSBaseWebVCCell class]) forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.cellType = self.secondCellType;//ThirdWebVCCellType;
         cell.delegate = self;
         [cell initialWebVCWithUrl:self.secondWebUrl];
//         cell.webVC.dwkWebView.scrollView.delegate = self;
         self.bottomWebVCCell = cell;
         return cell;
     }
    
     return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.secondWebCellHeight;
    if (indexPath.section == 0) {
        height = self.firstWebCellHeight;
    }

    return height;
}


#pragma mark - BSWebCellDelegate

/// 更新webVCCell高度
/// @param cellType webVCCell类型
/// @param height 高度
- (void)webVCCellType:(WebVCCellType)cellType height:(CGFloat)height {
    if (cellType == NativeWebVCCellType) {
        if (self.firstWebCellHeight < height) {
             self.firstWebCellHeight = height;
             [self.tableView beginBatchUpdates];
        }
    } else {
        if (self.secondWebCellHeight < height) {
             self.secondWebCellHeight = height;
             [self.tableView beginBatchUpdates];
        }
    }
}

@end
