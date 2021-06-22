//
//  CDMarkerInfo.h
  
//
//  Created by lucifer on 16/8/5.
 
//

#import <Foundation/Foundation.h>
#import "CDMarkerStyle.h"

@interface CDMarkerInfo : NSObject

@property(nonatomic,copy)NSString *marker_id;
@property(nonatomic,copy)NSString *data_id;
@property(nonatomic,copy)NSString *style_id;

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *bd_x;
@property(nonatomic,copy)NSString *bd_y;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *update_time;
@property(nonatomic,copy)NSString *markerDescription;

@property(nonatomic,strong)CDMarkerStyle *style;

@property(nonatomic,strong)NSArray *images;

@property(nonatomic,strong)NSMutableDictionary *extend_data;


@end
