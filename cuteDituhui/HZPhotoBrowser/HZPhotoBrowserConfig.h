//
//  HZPhotoBrowserConfig.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

typedef enum {
    HZIndicatorViewModeLoopDiagram, // 环形
    HZIndicatorViewModePieDiagram // 饼型
} HZIndicatorViewMode;

#define kAPPWidth [UIScreen mainScreen].bounds.size.width
#define kAppHeight [UIScreen mainScreen].bounds.size.height


#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f


#define shouldSupportLandscape NO
#define kIsFullWidthForLandScape NO

#define kIndicatorViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define kPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:1]


#define kPhotoBrowserImageViewMargin 10


#define kIndicatorViewItemMargin 10


#define kPhotoBrowserHideDuration 0.4f


#define kPhotoBrowserShowDuration 0.4f
