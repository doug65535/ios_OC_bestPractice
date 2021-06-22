//
//  mapDIffLayerView.m
  
//
//  Created by lucifer on 16/9/12.
 
//

#import "mapDIffLayerView.h"

@interface mapDIffLayerView ()
@property (weak, nonatomic) IBOutlet UILabel *layerName;
@property (weak, nonatomic) IBOutlet UILabel *overlayCount;


@end

@implementation mapDIffLayerView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layerName.text = self.layer.layer_name;
    self.overlayCount.text = [NSString stringWithFormat:@"%tu",self.layer.datas.count];
    self.title = @"图层信息";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
