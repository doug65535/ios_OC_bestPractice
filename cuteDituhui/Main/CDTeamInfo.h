//
//  CDTeamInfo.h
  
//
//  Created by lucifer on 16/7/29.
 
//

#import <Foundation/Foundation.h>

@interface CDTeamInfo : NSObject

@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *delete_time;
@property(nonatomic,copy)NSString *Description;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *rating;
@property(nonatomic,copy)NSString *team_id;
@property(nonatomic,copy)NSString *team_name;
@property(nonatomic,copy)NSString *update_time;
@property(nonatomic,copy)NSString *user_id;


@property(nonatomic,strong)CDAcount *create_user;

@end
