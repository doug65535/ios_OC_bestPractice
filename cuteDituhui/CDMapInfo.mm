//
//  CDMapInfo.m
  
//
//  Created by lucifer on 16/7/28.
 
//

#import "CDMapInfo.h"

@implementation CDMapInfo


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"mapDescription":@"description"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"layers":[CDLayerInfo class]};
}
@end
