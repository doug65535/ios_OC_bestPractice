//
//  mapDetailViewController.h
  
//
//  Created by lucifer on 16/8/4.
 
//

#import <UIKit/UIKit.h>

#define mapDetailChangeMap @"mapDetailChangeMap"

@interface mapDetailViewController : UIViewController

@property(nonatomic,strong)CDMapInfo *mapInfo;

typedef void(^passTitle)(id);

@property(nonatomic,copy)passTitle pass_title;

@end
