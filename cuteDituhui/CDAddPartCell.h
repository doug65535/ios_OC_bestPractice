//
//  CDAddPartCell.h
  
//
//  Created by lucifer on 2016/11/24.
 
//

#import <UIKit/UIKit.h>

#import "CDMapPartUserInfo.h"

@interface CDAddPartCell : UITableViewCell

@property(nonatomic,strong)CDMapPartUserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@end
