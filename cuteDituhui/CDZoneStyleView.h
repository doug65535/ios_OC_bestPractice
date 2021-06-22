//
//  CDZoneStyleView.h
  
//
//  Created by lucifer on 16/9/13.
 
//

#import <UIKit/UIKit.h>

@interface CDZoneStyleView : UIViewController
@property(nonatomic,assign)NSInteger indexItem1;
@property(nonatomic,assign)NSInteger indexItem2;
@property(nonatomic,strong)CDZoneInfo *zoneInfo;

#define CDZoneStyleChange @"zoneStyleChange"
@end
