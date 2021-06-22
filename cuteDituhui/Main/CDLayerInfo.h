//
//  CDLayerInfo.h
  
//
//  Created by lucifer on 16/8/5.
 
//

#import <Foundation/Foundation.h>
#import "CDHeatMapStyle.h"
#import "CDSpreadmapStyle.h"

@interface CDLayerInfo : NSObject<NSCoding>
@property(nonatomic,copy)NSString *layer_id;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *map_id;
@property(nonatomic,copy)NSString *data_id;
@property(nonatomic,copy)NSString *layer_type;
@property(nonatomic,copy)NSString *style_id;
@property(nonatomic,copy)NSString *layer_name;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *update_time;
@property(nonatomic,copy)NSString *layerDescription;
@property(nonatomic,copy)NSString *extend_id;
@property(nonatomic,copy)NSString *rating;

@property(nonatomic,strong)NSArray *partners;


@property(nonatomic,copy)NSString *show_type;

@property(nonatomic,strong)CDSpreadmapStyle *spreadmap_style;

@property(nonatomic,copy)NSString *all_attributes;
@property(nonatomic,copy)NSString *invisible_attr;
@property(nonatomic,copy)NSString *unshow_attr;

//@property (nonatomic,strong)NSArray *show_arr;

@property(nonatomic,strong)NSArray *datas;

@property(nonatomic,getter=isHide,assign)BOOL isHide;

@property(nonatomic,strong)CDHeatMapStyle *hotmap_style;

@end
