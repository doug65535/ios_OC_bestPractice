//
//  mapViewController.h
  
//
//  Created by lucifer on 16/8/3.
 
//

#import <UIKit/UIKit.h>



#define CDLoadedNewMap @"loadedNewMap"


@interface mapViewController : UIViewController

@property(nonatomic,strong)CDMapInfo *mapInfo;

typedef void(^passMapTitle)(id);

@property(nonatomic,copy)passMapTitle changedMapTitle;

@property(nonatomic,getter=isNewMap)BOOL isNewMap;

@property(nonatomic,copy)NSString *selectTeamId;

@end
