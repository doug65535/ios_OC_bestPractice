//
//  CDLineInfo.h
  
//
//  Created by lucifer on 16/8/5.
 
//

#import <Foundation/Foundation.h>
#import "CDLineStyle.h"
#import "line_geometry.h"

@interface CDLineInfo : NSObject

@property(nonatomic,strong)line_geometry *line_geometry;
@property(nonatomic,copy)NSString *update_time;
@property(nonatomic,copy)NSString *delete_time;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *data_legal;
@property(nonatomic,copy)NSString *data_id;
@property(nonatomic,copy)NSString *extend_id;
@property(nonatomic,copy)NSString *rating;
@property(nonatomic,copy)NSString *lineDescription;
@property(nonatomic,copy)NSString *style_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *line_id;

@property(nonatomic,strong)CDLineStyle *style;

@property(nonatomic,strong)NSArray *images;

@end
