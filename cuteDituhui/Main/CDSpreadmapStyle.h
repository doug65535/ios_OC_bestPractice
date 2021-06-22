//
//  CDSpreadmapStyle.h
  
//
//  Created by lucifer on 2016/10/11.
 
//

#import <Foundation/Foundation.h>
#import "CDMarkerStyle.h"
#import "CDSort.h"
@interface CDSpreadmapStyle : NSObject


@property(nonatomic,copy)NSString *spreadmap_id;
@property(nonatomic,copy)NSString *style_id;
@property(nonatomic,copy)NSString *icon_style;
@property(nonatomic,copy)NSString *title_key;
@property(nonatomic,copy)NSString *border_color;
@property(nonatomic,copy)NSString *fill_color;
@property(nonatomic,copy)NSString *label_location;
@property(nonatomic,copy)NSString *is_labelshow;
@property(nonatomic,copy)NSString *layer_id;

@property(nonatomic,strong)CDMarkerStyle *marker_icon_style;

@property(nonatomic,strong)CDSort *sort;

@end
