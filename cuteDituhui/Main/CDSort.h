//
//  CDSort.h
  
//
//  Created by lucifer on 2016/12/22.
 
//

#import <Foundation/Foundation.h>
#import "CDSortValue.h"
@interface CDSort : NSObject


@property(nonatomic,copy)NSString *sort_id;
@property(nonatomic,copy)NSString *layer_id;
@property(nonatomic,copy)NSString *sort_key;
@property(nonatomic,copy)NSString *elem_type;
@property(nonatomic,copy)NSString *sort_type;

@property(nonatomic,copy)NSString *sort_count;

@property(nonatomic,strong)NSArray *sort_values;

@end
