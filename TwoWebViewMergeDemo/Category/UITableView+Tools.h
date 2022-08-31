//
//  UITableView+Tools.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2021/11/5.
//  Copyright © 2021 huanghuaxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Tools)

#pragma mark - 执行UITableView的insert/delete/reload/move操作时

/// 执行UITableView的insert/delete/reload/move操作时，调用该方法
/// @param updates 更新操作
/// @param completion 更新完成回调
- (void)beginBatchUpdates:(void (NS_NOESCAPE ^ _Nullable)(void))updates completion:(void (^ _Nullable)(BOOL finished))completion;

/// 执行UITableView的insert/delete/reload/move操作时，调用该方法（回调方法都为nil）
- (void)beginBatchUpdates;

// 适配iOS15：sectionHeaderTopPadding会多出22像素高度
- (void)removeSectionHeaderTopPadding;

@end

NS_ASSUME_NONNULL_END
