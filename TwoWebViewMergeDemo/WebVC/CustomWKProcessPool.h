//
//  CustomWKProcessPool.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2019/11/5.
//  Copyright © 2019 huanghuaxing. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomWKProcessPool : WKProcessPool

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
