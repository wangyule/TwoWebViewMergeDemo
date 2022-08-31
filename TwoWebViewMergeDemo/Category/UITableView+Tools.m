//
//  UITableView+Tools.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2021/11/5.
//  Copyright © 2021 huanghuaxing. All rights reserved.
//

#import "UITableView+Tools.h"

@implementation UITableView (Tools)

#pragma mark - 执行UITableView的insert/delete/reload/move操作时

/// 执行UITableView的insert/delete/reload/move操作时，调用该方法
/// @param updates 更新操作
/// @param completion 更新完成回调
- (void)beginBatchUpdates:(void (NS_NOESCAPE ^ _Nullable)(void))updates completion:(void (^ _Nullable)(BOOL finished))completion {
    // 以下两个方法还会触发tableView的heightForRowAtIndexPath代理方法，刷新cell高度
    if (@available(iOS 11.0, *)) {
        [self performBatchUpdates:updates completion:completion];
    } else {
        // Fallback on earlier versions
        [self beginUpdates];
        
        // 两个方法之间执行UITableView的insert/delete/reload/move 操作
        if (updates) {
            updates();
        }
        
        [self endUpdates];
    }
}


/// 执行UITableView的insert/delete/reload/move操作时，调用该方法（回调方法都为nil）
- (void)beginBatchUpdates {
    [self beginBatchUpdates:nil completion:nil];
}

// 适配iOS15：sectionHeaderTopPadding会多出22像素高度
- (void)removeSectionHeaderTopPadding {
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}

@end
