//
//  Constants.h
//  TwoWebViewMergeDemo
//
//  Created by huanghuaxing on 2022/8/30.
//

#import "KUtils.h"

#ifndef Constants_h
#define Constants_h

//#define kBSKeyWindow              [UIApplication sharedApplication].window

// 屏幕的宽和高，导航和状态条高度
#define kSCREEN_WIDTH           [[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT          [[UIScreen mainScreen] bounds].size.height

#define kNAVIGATIONG_HEIGHT     [KUtils navigationBarHeight]
#define kSTATURSBAR_HEIGHT      [KUtils statusBarHeight]
// 导航栏+状态条的高度之和
#define kNAV_ADD_STAURSBAR_HEIGHT  (kNAVIGATIONG_HEIGHT + kSTATURSBAR_HEIGHT)
#define kVIEW_NONAVI_HEIGHT     (kSCREEN_HEIGHT - kNAVIGATIONG_HEIGHT - kSTATURSBAR_HEIGHT)     // 除去导航和状态条


#define kIS_iPhoneX          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIS_iPhoneXS_MAX     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIS_iPhoneXR         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIS_iPhoneXS         kIS_iPhoneX

// iPhoneX及以上
#define kIS_AboveiPhoneX      (kIS_iPhoneX || kIS_iPhoneXR || kIS_iPhoneXS_MAX || kIS_AboveiPhone12 || (kSTATURSBAR_HEIGHT > 20))

// iPhoneX/XS/XS MAX 底部主页指示器(Home Indicator)高度为34
#define kHomeIndicatorHeight    ((kIS_AboveiPhoneX) ? (34.0f) : (0.0f))


#endif /* Constants_h */
