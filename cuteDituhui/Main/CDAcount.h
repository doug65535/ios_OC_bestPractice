//
//  CDAcount.h
  
//
//  Created by lucifer on 16/7/21.
 
//

#import <Foundation/Foundation.h>
#import "CDUserRole.h"
@interface CDAcount : NSObject


/**
 *  保存授权模型
 *
 *  @return 是否保存成功
 */
- (BOOL)save;
/**
 *  从沙河中价值授权模型
 *
 *  @return 授权模型
 */
+ (instancetype)accountFromSandbox;




@property (nonatomic,copy)NSString *picture_count;
@property (nonatomic,copy)NSString *user_name;
@property (nonatomic,copy)NSString *avatar;
@property (nonatomic,copy)NSString *marker_count;
@property (nonatomic,copy)NSString *login_count;
@property (nonatomic,copy)NSString *regist_time;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *default_team_id;
@property (nonatomic,copy)NSString *member_count;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,strong)NSArray *roles;
@property (nonatomic,strong)NSArray *teams;
@property (nonatomic,strong)NSArray *layers;

@property (nonatomic,strong)CDUserRole *user_role;


@property (nonatomic,copy)NSString *email;



@end
