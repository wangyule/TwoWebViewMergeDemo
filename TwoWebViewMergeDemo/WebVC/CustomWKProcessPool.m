//
//  CustomWKProcessPool.m
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2019/11/5.
//  Copyright © 2019 huanghuaxing. All rights reserved.
//

#import "CustomWKProcessPool.h"



@implementation CustomWKProcessPool

static CustomWKProcessPool *processPool;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processPool = [[CustomWKProcessPool alloc] init];
    });
    return processPool;
}

@end
