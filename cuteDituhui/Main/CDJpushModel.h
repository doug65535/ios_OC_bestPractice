//
//  CDJpushModel.h
  
//
//  Created by lucifer on 2016/12/19.
 
//

#import <Foundation/Foundation.h>
#import "CDJpushOrigin.h"

@interface CDJpushModel : NSObject

@property(nonatomic,copy)NSString *action;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *showType;
@property(nonatomic,strong)CDJpushOrigin *origin;
@property(nonatomic,copy)NSMutableDictionary *result;



@end
