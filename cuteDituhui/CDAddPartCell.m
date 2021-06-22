//
//  CDAddPartCell.m
  
//
//  Created by lucifer on 2016/11/24.
 
//

#import "CDAddPartCell.h"
#import "CDMapPartUserInfo.h"

@interface CDAddPartCell()
@property (weak, nonatomic) IBOutlet UIImageView *avterView;

@property (weak, nonatomic) IBOutlet UILabel *titleLaber;


@end

@implementation CDAddPartCell

-(void)setUserInfo:(CDMapPartUserInfo *)userInfo
{
	_userInfo = userInfo;

	[self.avterView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
	self.titleLaber.text = userInfo.user_name;

	if ([userInfo.isCoope isEqualToString:@"1"]) {
		[self.addBtn setBackgroundColor:[UIColor clearColor]];
		[self.addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[self.addBtn setTitle:@"已添加" forState:UIControlStateNormal];
		self.addBtn.userInteractionEnabled = NO;
	}


}


@end
