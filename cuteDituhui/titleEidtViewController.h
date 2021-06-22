//
//  titleEidtViewController.h
  
//
//  Created by lucifer on 16/8/4.
 
//

#import <UIKit/UIKit.h>

@interface titleEidtViewController : UIViewController

@property(nonatomic,strong)CDMapInfo *mapInfo;

typedef void(^passTitleToView)(id);

@property(nonatomic,copy) passTitleToView pass_title;

@end
