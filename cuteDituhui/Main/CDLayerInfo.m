//
//  CDLayerInfo.m
  
//
//  Created by lucifer on 16/8/5.
 
//

#import "CDLayerInfo.h"

@implementation CDLayerInfo
MJExtensionCodingImplementation

//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.datas forKey:@"layername"];
//    
//}
//
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super init]) {
//        self.datas = [aDecoder decodeObjectForKey:@"layername"];
//    
//    }
//    return self;
//}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"layerDescription":@"description"};
}


//-(BOOL)isHide{
//	return YES;
//}

//-(void)setShow_arr:(NSArray *)show_arr
//{
//	NSMutableArray *array1 = [_all_attributes componentsSeparatedByString:@","].mutableCopy;
//	NSMutableArray *array2 = [_invisible_attr componentsSeparatedByString:@","].mutableCopy;
//	NSMutableArray *array3 = [_unshow_attr componentsSeparatedByString:@","].mutableCopy;
//
//	if (array1.count) {
//		if (array2.count) {
//			for (NSString *key in array2) {
//				[array1 removeObject:key];
//			}
//		}
//		if (array3.count) {
//			for (NSString *key in array3) {
//				[array1 removeObject:key];
//			}
//		}
//
////		return array1;
//	}
//	_show_arr = array1;
////	else return nil;
//
//}
//-(NSArray *)show_arr
//{
//
//}


@end
