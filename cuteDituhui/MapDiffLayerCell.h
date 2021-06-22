//
//  MapDiffLayerCell.h
  
//
//  Created by lucifer on 16/9/9.
 
//

#import <UIKit/UIKit.h>

#define CDHiddenLayerNotification @"hiddenLayerNotification"
#define CDShowLayerNotification @"showLayerNotification"
@interface MapDiffLayerCell : UITableViewCell

@property (nonatomic,strong)CDLayerInfo *layerInfo;

@end
