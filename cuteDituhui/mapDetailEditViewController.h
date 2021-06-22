//
//  mapDetailEditViewController.h
  
//
//  Created by lucifer on 16/8/4.
 
//

#import <UIKit/UIKit.h>

@interface mapDetailEditViewController : UIViewController


@property(nonatomic,strong)CDMapInfo *mapInfo;

typedef void(^passDes)(id);

@property(nonatomic,copy) passDes passDes;
@end
