//
//  CDSortValue.h
  
//
//  Created by lucifer on 2016/12/22.
 
//

#import <Foundation/Foundation.h>

@interface CDSortValue : NSObject

@property(nonatomic,copy)NSString *sort_id;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *style_id;
@property(nonatomic,copy)NSString *name;

@property(nonatomic,strong)CDMarkerStyle *style;

@end
