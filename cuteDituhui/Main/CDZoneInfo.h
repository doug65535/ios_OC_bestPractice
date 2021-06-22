//
//  CDZoneInfo.h
  
//
//  Created by lucifer on 16/8/5.
 
//

#import <Foundation/Foundation.h>
#import "circle_geometry.h"
#import "polygon_geometry.h"
#import "CDZoneStyle.h"


@interface CDZoneInfo : NSObject


@property(nonatomic,copy)NSString *zone_id;
@property(nonatomic,copy)NSString *update_time;
@property(nonatomic,copy)NSString *delete_time;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *data_id;
@property(nonatomic,copy)NSString *extend_id;
@property(nonatomic,copy)NSString *rating;
@property(nonatomic,copy)NSString *zoneDescription;
@property(nonatomic,copy)NSString *style_id;
@property(nonatomic,copy)NSString *title;


@property(nonatomic,strong)polygon_geometry *zone_geometry;

@property(nonatomic,strong)circle_geometry *circle_geometry;

@property(nonatomic,strong)CDZoneStyle *style;

@property(nonatomic,strong)NSArray *images;
@end
