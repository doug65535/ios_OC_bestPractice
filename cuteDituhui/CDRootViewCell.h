//
//  CDRootViewCell.h
  
//
//  Created by lucifer on 16/7/27.
 
//

#import <UIKit/UIKit.h>

@interface CDRootViewCell : UITableViewCell

@property(nonatomic,strong)CDMapInfo *mapInfo;


@property (weak, nonatomic) IBOutlet UIImageView *mapPic;

@property (weak, nonatomic) IBOutlet UILabel *mapTitle;

@property (weak, nonatomic) IBOutlet UIButton *authorName;

@property (weak, nonatomic) IBOutlet UIButton *creatTime;
@end
