//
//  extendEditTableViewCell.m
  
//
//  Created by lucifer on 2016/10/20.
 
//

#import "extendEditTableViewCell.h"

@implementation extendEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setKey:(NSString *)key
{
	_key = key;
	self.editKeyLabel.text=  key;
}

-(void)setValue:(NSString *)value
{
	_value = value;
	self.editValueTextField.text = value;
	
}

- (IBAction)exitKeyBorad:(id)sender {
	[[UIApplication sharedApplication].keyWindow endEditing:YES];
}
@end
