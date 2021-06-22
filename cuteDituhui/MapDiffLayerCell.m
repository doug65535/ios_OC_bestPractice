//
//  MapDiffLayerCell.m
  
//
//  Created by lucifer on 16/9/9.
 
//

#import "MapDiffLayerCell.h"


@interface MapDiffLayerCell()
{
    BOOL isLayerHidden;
}

@property (weak, nonatomic) IBOutlet UIButton *layerHiddenButton;
@property (weak, nonatomic) IBOutlet UILabel *layerName;

- (IBAction)layerHiddenClick:(id)sender;

@end

@implementation MapDiffLayerCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self =[super initWithCoder:aDecoder]) {
        // 初始化代码
        isLayerHidden = YES;
    }
    return self;
}

-(void)setLayerInfo:(CDLayerInfo *)layerInfo
{
    _layerInfo = layerInfo;
    self.layerName.text = layerInfo.layer_name;

 if (layerInfo.isHide) {

	 [self.layerHiddenButton setImage:[UIImage imageNamed:@"icon_show_default"] forState:UIControlStateNormal];
 }else
	 {
	 [self.layerHiddenButton setImage:[UIImage imageNamed:@"icon_show_selected"] forState:UIControlStateNormal];
	 }
}

- (IBAction)layerHiddenClick:(id)sender {
    if (isLayerHidden) {
        [self.layerHiddenButton setImage:[UIImage imageNamed:@"icon_show_default"] forState:UIControlStateNormal];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.layerInfo forKey:@"layerInfo"];
        [[NSNotificationCenter defaultCenter]postNotificationName:CDHiddenLayerNotification object:nil userInfo:dic];

    }else
    {
        [self.layerHiddenButton setImage:[UIImage imageNamed:@"icon_show_selected"] forState:UIControlStateNormal];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.layerInfo forKey:@"layerInfo"];
        [[NSNotificationCenter defaultCenter]postNotificationName:CDShowLayerNotification object:nil userInfo:dic];
    }
    
    isLayerHidden = !isLayerHidden;
	self.layerInfo.isHide = !self.layerInfo.isHide;
}



@end
