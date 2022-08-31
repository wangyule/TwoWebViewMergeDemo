//
//  BSBaseNativeAndWebViewController.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/07/08.
//  Copyright © 2022年 huanghuaxing. All rights reserved.
//

// ViewController
#import "BSBaseNativeAndWebViewController.h"
//#import "APIConfig.h"
#import "SLDynamicItem.h"
// category
#import "UIScrollView+SLCommon.h"
#import "UIView+EasyExtend.h"
#import "UITableView+Tools.h"
#import "MJRefresh.h"
#import "Constants.h"


@interface BSBaseNativeAndWebViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
BSNativeWebCellDelegate,
UIDynamicAnimatorDelegate,
UIGestureRecognizerDelegate
>

//// 底部webVCCell
//@property(nonatomic, strong) BSNativeWebVCCell *bottomWebVCCell;
//// 底部web的高度
//@property (nonatomic, assign) CGFloat heightOfWeb;
//// 行情数据cell的高度
//@property (nonatomic, assign) CGFloat MarketDataWebCellHeight;
// self.view拖拽手势
@property(nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
// 顶部、底部最大弹性距离
@property(nonatomic) CGFloat maxBounceDistance;

/** UIKit 动力学/仿真物理学：https://blog.csdn.net/meiwenjie110/article/details/46771299 */
// 动力装置 - 启动力
@property(nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
// 惯性力 - 手指滑动松开后，scrollView借助于惯性力，以手指松开时的初速度以及设置的resistance动力减速度运动，直至停止
@property(nonatomic, weak) UIDynamicItemBehavior *inertialBehavior;
// 吸附力 - 模拟UIScrollView滑到底部或顶部时的回弹效果
@property(nonatomic, weak) UIAttachmentBehavior *bounceBehavior;

@end

@implementation BSBaseNativeAndWebViewController

- (void)viewDidLoad {
     [super viewDidLoad];

    self.title = @"two webView";
     [self initialView];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
}

// 滚动中单击可以停止滚动
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     [super touchesBegan:touches withEvent:event];
     [self.dynamicAnimator removeAllBehaviors];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     if (indexPath.section == 0) {
         BSNativeWebVCCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BSNativeWebVCCell class]) forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.cellType = NativeWebVCCellType;
         cell.delegate = self;
         [cell initialWebVCWithUrl:@"https://www.wjx.top/vm/eTohcx3.aspx"];
//         cell.webVC.dwkWebView.scrollView.delegate = self;
         return cell;
     } else {
         BSNativeWebVCCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BSNativeWebVCCell class]) forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.cellType = ThirdWebVCCellType;
         cell.delegate = self;
         [cell initialWebVCWithUrl:@"https://www.baidu.com"];
//         cell.webVC.dwkWebView.scrollView.delegate = self;
         self.bottomWebVCCell = cell;
         return cell;
     }
    
     return nil;*/
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    return cell;
}

#pragma mark - UITableViewDelegate
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.heightOfWeb;
    if (indexPath.section == 0) {
        height = self.MarketDataWebCellHeight;
    }
    
    if (height <= 0) {
         height = kVIEW_NONAVI_HEIGHT - kTabBar_Height;
    }
    return height;
} */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
     return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - BSWebCellDelegate

/// 更新webVCCell高度
/// @param cellType webVCCell类型
/// @param height 高度
- (void)webVCCellType:(WebVCCellType)cellType height:(CGFloat)height {
    if (cellType == NativeWebVCCellType) {
        if (self.MarketDataWebCellHeight < height) {
             self.MarketDataWebCellHeight = height;
             [self.tableView beginBatchUpdates];
        }
    } else {
        if (self.heightOfWeb < height) {
             self.heightOfWeb = height;
             [self.tableView beginBatchUpdates];
        }
    }
} */

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     if (scrollView == self.tableView) {
          // 为了兼容下拉刷新功能   2021.12.22
          [self scrollViewContentOffsetDidChange:nil];
     }
}

#pragma mark - UIKit 动力学/仿真物理学
#pragma mark - UIDynamicAnimatorDelegate

/// 动力装置即将启动
- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    // 防止误触tableView的点击事件
    self.bottomWebVCCell.webVC.dwkWebView.userInteractionEnabled = NO;
    self.tableView.userInteractionEnabled = NO;
}

/// 动力装置暂停
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    self.bottomWebVCCell.webVC.dwkWebView.userInteractionEnabled = YES;
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark - UIGestureRecognizerDelegate
/// 避免影响横滑手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
     UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
     // 通过x,y方向的速度对比判断
     CGPoint velocity = [pan velocityInView:self.view];
     BOOL ret = fabs(velocity.y) > fabs(velocity.x);
     
     // 通过x, y坐标大小对比判断
     BOOL isVerticalSliding = NO;
     CGPoint translation = [pan translationInView:self.view];
     CGFloat absX = fabs(translation.x);
     CGFloat absY = fabs(translation.y);
     if (MAX(absX, absY) > 10 && absY > absX) {
          isVerticalSliding = YES;
     }
     
     return (ret || isVerticalSliding);
}

#pragma mark - UIPanGestureRecognizer

/// 拖拽手势，模拟UIScrollView滑动
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
     switch (recognizer.state) {
          case UIGestureRecognizerStateBegan: {
               // 开始拖动，移除之前所有的动力行为
               [self.dynamicAnimator removeAllBehaviors];
          }
               break;
          case UIGestureRecognizerStateChanged: {
               CGPoint translation = [recognizer translationInView:self.view];
               // 拖动过程中调整scrollView.contentOffset
               [self scrollViewsSetContentOffsetY:translation.y];
               [recognizer setTranslation:CGPointZero inView:self.view];
          }
               break;
          case UIGestureRecognizerStateEnded: {
               // 这个if是为了避免在拉到边缘时，以一个非常小的初速度松手不回弹的问题
               if (fabs([recognizer velocityInView:self.view].y) < 120) {
                    if ([self.tableView sl_isTop] &&
                        ([self.bottomWebVCCell.webVCScrollView sl_isTop]
                        || !self.bottomWebVCCell)) {
                         // 顶部
                         [self performBounceForScrollView:self.tableView isAtTop:YES];
                    } else if ([self.tableView sl_isBottom] &&
                               [self.bottomWebVCCell.webVCScrollView sl_isBottom]) {
                         // 底部
                         [self performBounceForScrollView:self.bottomWebVCCell.webVCScrollView isAtTop:NO];
                    }
                    return;
               }
               
               // 动力元素 力的操作对象
               SLDynamicItem *item = [[SLDynamicItem alloc] init];
               item.center = CGPointZero;
               __block CGFloat lastCenterY = 0;
               UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[item]];
               // 给item添加初始线速度 手指松开时的速度
               [inertialBehavior addLinearVelocity:CGPointMake(0, -[recognizer velocityInView:self.view].y) forItem:item];
               // 减速度  无速度阻尼
               inertialBehavior.resistance = 2;
               __weak typeof(self) weakSelf = self;
               inertialBehavior.action = ^{
                    // 惯性力 移动的距离
                    [weakSelf scrollViewsSetContentOffsetY:lastCenterY - item.center.y];
                    lastCenterY = item.center.y;
               };
               
               /**
                注意，self.inertialBehavior 的修饰符是weak，惯性力结束停止之后，
                会释放inertialBehavior对象，self.inertialBehavior = nil
                */
               self.inertialBehavior = inertialBehavior;
               [self.dynamicAnimator addBehavior:inertialBehavior];
               
               /*
               // 兼容下拉刷新功能 - 有其他更好的兼容方法   2021.12.22
               if (self.tableView.contentOffset.y < -60) {
                    if (self.tableView.mj_header.state != MJRefreshStatePulling) {
                         self.tableView.mj_header.state = MJRefreshStatePulling;
                    }
               } */
          }
               break;
          default:
               break;
     }
}


#pragma mark - Custom Method

/**
 初始化页面的视图
 */
- (void)initialView {
    [self createTableView];
    
    // 添加pan拖拽手势   2021.11.19
    self.maxBounceDistance = 100;
    [self.view addGestureRecognizer:self.panRecognizer];
}

- (void)createTableView {
    CGRect rect = CGRectMake(0.0, kNAV_ADD_STAURSBAR_HEIGHT, self.view.width, self.view.height);
    
    // tableView改为Grouped类型,这样section的headerView和footerView才可以跟着滑动
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0; // 这里设置负数居然会崩溃！！
    self.tableView.scrollEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    [self.view addSubview:self.tableView];
    
    // 适配iOS15   2021.11.05
    [self.tableView removeSectionHeaderTopPadding];
    
    [self.tableView registerClass:[BSBaseWebVCCell class] forCellReuseIdentifier:NSStringFromClass([BSBaseWebVCCell class])];
    
    // 下拉刷新
//    @weakify(self);
//    [self.tableView addLegendHeaderWithRefreshingBlock:^{
//        @strongify(self);
//
//    }];
    
    // 为了兼容下拉刷新功能   2021.12.22
    self.tableView.mj_header.userInteractionEnabled = NO;
    self.tableView.mj_header.mj_h = 30.0f;
}


#pragma mark - 关于UIKit动力学相关处理方法

/// 根据拖拽手势在屏幕上的拖拽距离，调整scrollView.contentOffset
- (void)scrollViewsSetContentOffsetY:(CGFloat)deltaY {
     if (deltaY < 0) {
          //上滑
          if ([self.tableView sl_isBottom]) {
               // tableView已滑到底，此时应滑动dwkWebView
               if ([self.bottomWebVCCell.webVCScrollView sl_isBottom]) {
                    // dwkWebView也到底
                    CGFloat bounceDelta = MAX(0, (self.maxBounceDistance - fabs(self.bottomWebVCCell.webVCScrollView.contentOffset.y - self.bottomWebVCCell.webVCScrollView.sl_maxContentOffsetY)) / self.maxBounceDistance) * 0.5;
                    self.bottomWebVCCell.webVCScrollView.contentOffset = CGPointMake(0, self.bottomWebVCCell.webVCScrollView.contentOffset.y - deltaY * bounceDelta);
                    [self performBounceIfNeededForScrollView:self.bottomWebVCCell.webVCScrollView isAtTop:NO];
                    
               } else {
                    self.bottomWebVCCell.webVCScrollView.contentOffset = CGPointMake(0, MIN(self.bottomWebVCCell.webVCScrollView.contentOffset.y - deltaY, [self.bottomWebVCCell.webVCScrollView sl_maxContentOffsetY]));
               }
          } else {
               self.tableView.contentOffset = CGPointMake(0, MIN(self.tableView.contentOffset.y - deltaY, [self.tableView sl_maxContentOffsetY]));
               
          }
          
     } else if (deltaY > 0) {
          /**
           下滑
           由于还没出现H5社区内容时，self.bottomWebVCCell为空，   2021.11.26
           */
          if ([self.bottomWebVCCell.webVCScrollView sl_isTop] || !self.bottomWebVCCell) {
               // dwkWebView滑到顶，此时应滑动tableView
               if ([self.tableView sl_isTop]) {
                    // tableView到顶
                    CGFloat bounceDelta = MAX(0, (self.maxBounceDistance - fabs(self.tableView.contentOffset.y)) / self.maxBounceDistance) * 0.5;
                    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y - bounceDelta * deltaY);
                    [self performBounceIfNeededForScrollView:self.tableView isAtTop:YES];
               } else {
                    // dwkWebView内容到顶后，调整tableView.contentOffset
                    self.tableView.contentOffset = CGPointMake(0, MAX(self.tableView.contentOffset.y - deltaY, 0));
               }
          } else {
               // dwkWebView内容还未到顶，调整dwkWebView.contentOffset
               self.bottomWebVCCell.webVCScrollView.contentOffset = CGPointMake(0, MAX(self.bottomWebVCCell.webVCScrollView.contentOffset.y - deltaY, 0));
          }
     }
}

// 两种回弹触发方式：
/// 1.惯性滚动到边缘处回弹
- (void)performBounceIfNeededForScrollView:(UIScrollView *)scrollView isAtTop:(BOOL)sl_isTop {
     if (self.inertialBehavior) {
          [self performBounceForScrollView:scrollView isAtTop:sl_isTop];
     }
}

/// 2.手指拉到边缘处回弹
- (void)performBounceForScrollView:(UIScrollView *)scrollView isAtTop:(BOOL)isTop {
     if (!self.bounceBehavior) {
          // 移除惯性力
          [self.dynamicAnimator removeBehavior:self.inertialBehavior];
          
          // 吸附力操作元素
          SLDynamicItem *item = [[SLDynamicItem alloc] init];
          item.center = scrollView.contentOffset;
          // 吸附力的锚点Y
          CGFloat attachedToAnchorY = 0;
          if (scrollView == self.tableView) {
               //顶部时吸附力的Y轴锚点是0  底部时的锚点是Y轴最大偏移量
               attachedToAnchorY = isTop ? 0 : [self.tableView sl_maxContentOffsetY];
          } else {
               //            attachedToAnchorY = 0;
               attachedToAnchorY = isTop ? 0 : [self.bottomWebVCCell.webVCScrollView sl_maxContentOffsetY];
          }
          // 吸附力
          UIAttachmentBehavior *bounceBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:CGPointMake(0, attachedToAnchorY)];
          // 吸附点的距离
          bounceBehavior.length = 0;
          // 阻尼/缓冲
          bounceBehavior.damping = 1;
          // 频率
          bounceBehavior.frequency = 2;
          bounceBehavior.action = ^{
               scrollView.contentOffset = CGPointMake(0, item.center.y);
          };
          self.bounceBehavior = bounceBehavior;
          [self.dynamicAnimator addBehavior:bounceBehavior];
     }
}

/// 为了兼容下拉刷新功能   2021.12.22
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
//     [super scrollViewContentOffsetDidChange:change];
     
     // 在刷新的refreshing状态
     if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
//          [self resetInset];
          return;
     }
     
     // 跳转到下一个控制器时，contentInset可能会变
     UIEdgeInsets scrollViewOriginalInset = self.tableView.mj_inset;
     
     // 当前的contentOffset
     CGFloat offsetY = self.tableView.mj_offsetY;
     // 头部控件刚好出现的offsetY
     CGFloat happenOffsetY = - scrollViewOriginalInset.top;
     
     // 如果是向上滚动到看不见头部控件，直接返回
     // >= -> >
     if (offsetY > happenOffsetY) return;
     
     // 普通 和 即将刷新 的临界点
     CGFloat normal2pullingOffsetY = happenOffsetY - self.tableView.mj_header.mj_h;
     CGFloat pullingPercent = (happenOffsetY - offsetY) / self.tableView.mj_header.mj_h;
     
     if (self.panRecognizer.state == UIGestureRecognizerStateChanged) { // 如果正在拖拽
          self.tableView.mj_header.pullingPercent = pullingPercent;
          if (self.tableView.mj_header.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
               // 转为即将刷新状态
               self.tableView.mj_header.state = MJRefreshStatePulling;
          } else if (self.tableView.mj_header.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
               // 转为普通状态
               self.tableView.mj_header.state = MJRefreshStateIdle;
          }
     } else if (self.tableView.mj_header.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
          // 开始刷新
          [self.tableView.mj_header beginRefreshing];
     } else if (pullingPercent < 1) {
          self.tableView.mj_header.pullingPercent = pullingPercent;
     }
}


- (UIPanGestureRecognizer *)panRecognizer {
     if (!_panRecognizer) {
          _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
          _panRecognizer.delegate = self;
     }
     return _panRecognizer;
}

- (UIDynamicAnimator *)dynamicAnimator {
     if (!_dynamicAnimator) {
          _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
          _dynamicAnimator.delegate = self;
     }
     return _dynamicAnimator;
}

@end
