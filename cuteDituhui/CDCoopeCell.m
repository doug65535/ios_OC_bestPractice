//
//  CDCoopeCell.m
  
//
//  Created by lucifer on 2016/10/25.
 
//

#import "CDCoopeCell.h"

@implementation CDCoopeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCoope:(CDCoope *)coope
{

	_coope = coope;
	[self.avterImageView sd_setImageWithURL:[NSURL URLWithString:self.coope.userinfo.avatar]];

	if ([self.coope.m_id isEqualToString:@"0"]) {
		self.levelLaber.text = @"地图访客";
			self.moreBtn.hidden = NO;
//		self.levelLaber.backgroundColor = [UIColor colorWithRed: 194/255.0f green:235/255.0f blue:99/255.0f alpha:1.0f];
	}else
		if ([self.coope.m_id isEqualToString:@"10"]) {
			self.levelLaber.text = @"C级管理员";
				self.moreBtn.hidden = NO;
//				self.levelLaber.backgroundColor = [UIColor colorWithRed: 99/255.0f green:178/255.0f blue:235/255.0f alpha:1.0f];
		}else
			if ([self.coope.m_id isEqualToString:@"20"]) {
				self.levelLaber.text = @"B级管理员";
					self.moreBtn.hidden = NO;
//					self.levelLaber.backgroundColor = [UIColor colorWithRed: 105/255.0f green:99/255.0f blue:235/255.0f alpha:1.0f];
			}else
				if ([self.coope.m_id isEqualToString:@"30"]) {
					self.levelLaber.text = @"A级管理员";
						self.moreBtn.hidden = NO;
//						self.levelLaber.backgroundColor = [UIColor colorWithRed: 201/255.0f green:99/255.0f blue:234/255.0f alpha:1.0f];
				}else
					if ([self.coope.m_id  isEqualToString:@"40"]) {
						self.levelLaber.text = @"地图责任人";
						self.moreBtn.hidden = NO;
//							self.levelLaber.backgroundColor = [UIColor colorWithRed: 234/255.0f green:99/255.0f blue:162/255.0f alpha:1.0f];
					}else
						if ([self.coope.m_id isEqualToString:@"50"]) {
							self.levelLaber.text = @"地图所有者";
							self.moreBtn.hidden = YES;

//								self.levelLaber.backgroundColor = [UIColor colorWithRed: 234/255.0f green:99/255.0f blue:99/255.0f alpha:1.0f];
						}

	self.nameLaber.text = coope.userinfo.user_name;

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)moreClick:(id)sender {


	[[NSNotificationCenter defaultCenter] postNotificationName:CDPartenerMoreClick object:nil userInfo:[NSDictionary dictionaryWithObject:self.coope forKey:@"coope"]];
}
@end
