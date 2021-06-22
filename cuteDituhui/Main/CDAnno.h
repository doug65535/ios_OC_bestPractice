//
//  CDAnno.h
  
//
//  Created by lucifer on 16/8/8.
 
//

#import <Foundation/Foundation.h>
#import "CDMarkerInfo.h"


@interface CDAnno : BMKPointAnnotation

@property(nonatomic,strong)CDMarkerInfo *markerInfo;

@property (nonatomic, assign) NSInteger size;

@end
