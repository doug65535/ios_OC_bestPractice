//
//  CDMakerResultViewController.h
  
//
//  Created by lucifer on 16/8/30.
 
//

#import <UIKit/UIKit.h>

@interface CDMakerResultViewController : UITableViewController

#define SMSectetPOIseachNotification @"sectetPOIseachNotification"
#define SMsectetResultSeachNotification @"sectetResultSeachNotification"

/** 搜索条件 */
@property (nonatomic, copy) NSString *searchText;

@property(nonatomic,strong)NSMutableArray *poimodel;

@property(nonatomic,strong) BMKPoiSearch *poisearch;



@property(nonatomic,strong)NSMutableArray *layerArr;



@end
