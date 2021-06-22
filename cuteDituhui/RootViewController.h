//
//  RootViewController.h
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKSideSlipView.h"
@class JKSideSlipView;
@interface RootViewController : UIViewController
{
    JKSideSlipView *_sideSlipView;
}

@property(nonatomic,strong)CDAcount *userInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *creatNewMapView;

@end
