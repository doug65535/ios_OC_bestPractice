//
//  CDRootViewCell.m
  
//
//  Created by lucifer on 16/7/27.
 
//

#import "CDRootViewCell.h"


@interface CDRootViewCell()

@end
@implementation CDRootViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

-(void)setMapInfo:(CDMapInfo *)mapInfo
{
    _mapInfo = mapInfo;


//	if ([mapInfo.logo isEqualToString:@"http://dituhui-cute.oss-cn-hangzhou.aliyuncs.com/default_img/2016/5/29/97b4ea70acd4476b8cc0934c45d45d63.png"]) {
//
//		NSString *str =[NSString stringWithFormat:@"%@/draw/%@/%@/%@/%@",@"http://192.168.44.235:8080/cutedituhui",@"110",@"random",@"default",[[self.mapInfo.title substringToIndex:2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//	 NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
//
//	self.mapPic.image = [UIImage imageWithData:data];
//
//	}else{
		[self.mapPic sd_setImageWithURL:[NSURL URLWithString:mapInfo.logo]];
//	}
	
        self.mapTitle.text = self.mapInfo.title;
        [self.authorName setTitle:self.mapInfo.user_info.user_name forState:UIControlStateNormal];
    [self.creatTime setTitle:self.mapInfo.create_time forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
