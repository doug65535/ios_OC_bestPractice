//
//  CDRole.m
  
//
//  Created by lucifer on 2016/11/3.
 
//

#import "CDRole.h"

@implementation CDRole

MJExtensionCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName
{
	return @{@"role_description":@"description"};
}

@end
