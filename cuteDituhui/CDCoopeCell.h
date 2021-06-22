//
//  CDCoopeCell.h
  
//
//  Created by lucifer on 2016/10/25.
 
//

#import <UIKit/UIKit.h>

#import "CDCoope.h"

#define CDPartenerMoreClick @"partenerMoreClick"

@interface CDCoopeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avterImageView;
@property (weak, nonatomic) IBOutlet UILabel *levelLaber;
@property (weak, nonatomic) IBOutlet UILabel *nameLaber;

- (IBAction)moreClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (nonatomic,strong)CDCoope *coope;

@end
