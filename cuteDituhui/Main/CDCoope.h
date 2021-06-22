//
//  CDCoope.h
  
//
//  Created by lucifer on 2016/10/25.
 
//

#import <Foundation/Foundation.h>

@interface CDCoope : NSObject


@property(nonatomic,copy)NSString *m_id;
@property(nonatomic,copy)NSString *map_id;
@property(nonatomic,copy)NSString *user_id;

@property (nonatomic,strong)CDAcount *userinfo;

@end
