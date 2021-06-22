//
//  extendShowTableViewCell.h
  
//
//  Created by lucifer on 2016/10/19.
 
//

#import <UIKit/UIKit.h>

@interface extendShowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *extendKey;

@property (weak, nonatomic) IBOutlet UILabel *extendValue;


@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *value;

//-(CGFloat)setCellHeight:(NSString *)value;

@end
