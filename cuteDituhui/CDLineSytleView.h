//
//  CDLineSytleView.h
  
//
//  Created by lucifer on 16/9/13.
 
//

#import <UIKit/UIKit.h>



@interface CDLineSytleView : UIViewController

@property(nonatomic,assign)NSInteger indexItem1;

#define CDLineStyleChange @"lineStyleChange"

@property(nonatomic,strong)CDLineInfo *lineInfo;

@end
