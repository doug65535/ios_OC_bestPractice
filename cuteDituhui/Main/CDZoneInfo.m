//
//  CDZoneInfo.m
  
//
//  Created by lucifer on 16/8/5.
 
//

#import "CDZoneInfo.h"

@implementation CDZoneInfo


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"zoneDescription":@"description",@"circle_geometry":@"zone_geometry"};
}


@end
