
//
//  CDMapInfo.h
  
//
//  Created by lucifer on 16/7/28.
 
//

#import <Foundation/Foundation.h>
#import "CDPoint.h"

@interface CDMapInfo : NSObject

@property(nonatomic,copy)NSString *map_id;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,strong)CDAcount *user_info;
@property(nonatomic,copy)NSString *team_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *center;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *mapDescription;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *update_time;
	
@property(nonatomic,copy)NSString *rating;
@property(nonatomic,strong)NSArray *layers;
@property(nonatomic,strong)NSArray *partners;


@property(nonatomic,copy)NSString *cluster;



@end
