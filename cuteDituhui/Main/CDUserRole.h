//
//  CDUserRole.h
  
//
//  Created by lucifer on 2016/11/3.
 
//

#import <Foundation/Foundation.h>

#import "CDRole.h"
@interface CDUserRole : NSObject

@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *role_id;
@property(nonatomic,copy)NSString *join_time;
@property(nonatomic,copy)NSString *update_time;
@property(nonatomic,copy)NSString *end_time;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,strong)CDRole *role;



@end
