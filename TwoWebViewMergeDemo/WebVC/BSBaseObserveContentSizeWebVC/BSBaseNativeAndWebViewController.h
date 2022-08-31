//
//  BSBaseNativeAndWebViewController.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/07/08.
//  Copyright © 2022年 huanghuaxing. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "BSBaseWebVCCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface BSBaseNativeAndWebViewController : UIViewController

@property (strong, nonatomic) UITableView *tableView;
// 底部webVCCell
@property(nonatomic, strong) BSBaseWebVCCell *bottomWebVCCell;

@end

NS_ASSUME_NONNULL_END
