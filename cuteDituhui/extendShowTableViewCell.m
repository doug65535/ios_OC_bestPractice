//
//  extendShowTableViewCell.m
  
//
//  Created by lucifer on 2016/10/19.
 
//

#import "extendShowTableViewCell.h"

@implementation extendShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
}

-(void)setKey:(NSString *)key
{
	_key = key;
	self.extendKey.text=  key;
}

-(void)setValue:(NSString *)value
{
	_value = value;
	self.extendValue.text = value;
	CDLog(@"%f",self.extendValue.height);
}


//-(CGFloat)setCellHeight:(NSString *)value
//{
////	CGSize messageSize = [self.extendValue sizeThatFits:CGSizeMake(kWidth -10, MAXFLOAT)];
////	[self.extendValue setPreferredMaxLayoutWidth:kWidth-10];
////	NSDictionary *attrs = @{NSFontAttributeName :self.extendValue.font};
////	CGSize maxSize = CGSizeMake(kWidth - 10, MAXFLOAT);
////	CGSize size = [value boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//
//	CGSize messageSize = [self.extendValue sizeThatFits:CGSizeMake(kWidth -10, MAXFLOAT)];
//	CDLog(@"%f",messageSize.height);
//	return messageSize.height +30;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
