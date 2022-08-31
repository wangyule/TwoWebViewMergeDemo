//
//  UIScrollView+SLCommon.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2021/3/17.
//  Copyright © 2021 huanghuaxing. All rights reserved.
//

#import "UIScrollView+SLCommon.h"

@implementation UIScrollView (SLCommon)

- (CGFloat)sl_maxContentOffsetY {
    return MAX(0, self.contentSize.height - self.frame.size.height);
}

- (BOOL)sl_isBottom {
    return self.contentOffset.y + 0.5 >= [self sl_maxContentOffsetY] ||
    fabs(self.contentOffset.y - [self sl_maxContentOffsetY]) < FLT_EPSILON;
}

- (BOOL)sl_isTop {
    return self.contentOffset.y <= 0;
}

- (void)sl_scrollToTopWithAnimated:(BOOL)animated {
    [self setContentOffset:CGPointZero animated:animated];
}

@end
