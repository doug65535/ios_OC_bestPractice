//
//  CDHeatMapStyle.h
  
//
//  Created by lucifer on 16/8/18.
 
//

#import <Foundation/Foundation.h>

@interface CDHeatMapStyle : NSObject

@property(nonatomic,copy)NSString *hotmap_id;
@property(nonatomic,copy)NSString *color_type;

	//quanzhong
@property(nonatomic,copy)NSString *weight_key;
	//banjing
@property(nonatomic,copy)NSString *radius;

@property(nonatomic,copy)NSString *ismarker_show;
@property(nonatomic,copy)NSString *layer_id;

@property(nonatomic,copy)NSString *keys;



@end
