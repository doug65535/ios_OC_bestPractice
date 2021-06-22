//
//  CDSort.m
  
//
//  Created by lucifer on 2016/12/22.
 
//

#import "CDSort.h"

@implementation CDSort

MJExtensionCodingImplementation

+(NSDictionary *)mj_objectClassInArray
{
	return @{@"sort_values" :[CDSortValue class]};
}

@end
