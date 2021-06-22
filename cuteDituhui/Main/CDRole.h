//
//  CDRole.h
  
//
//  Created by lucifer on 2016/11/3.
 
//

#import <Foundation/Foundation.h>

@interface CDRole : NSObject


@property(nonatomic,copy)NSString *role_id;
@property(nonatomic,copy)NSString *role_name;
@property(nonatomic,copy)NSString *role_description;
@property(nonatomic,copy)NSString *create_user_id;
@property(nonatomic,copy)NSString *create_time;

@property(nonatomic,strong)NSArray *users;
@property(nonatomic,strong)NSArray *menus;

@end
