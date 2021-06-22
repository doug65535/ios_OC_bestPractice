//
//  extendEditTableViewCell.h
  
//
//  Created by lucifer on 2016/10/20.
 
//

#import <UIKit/UIKit.h>

@interface extendEditTableViewCell : UITableViewCell

@property(nonatomic,copy)NSString *key;

@property(nonatomic,copy)NSString *value;

@property (weak, nonatomic) IBOutlet UILabel *editKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *editValueTextField;
- (IBAction)exitKeyBorad:(id)sender;

@end
