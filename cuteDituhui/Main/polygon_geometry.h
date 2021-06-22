//
//  polygon_geometry.h
  
//
//  Created by lucifer on 16/8/8.
 
//

#import <Foundation/Foundation.h>
#import "CDPoint.h"

@interface polygon_geometry : NSObject


@property(nonatomic,copy)NSString *type;
@property(nonatomic,strong)CDPoint *center;
@property(nonatomic,strong)NSArray *apex;


@end
