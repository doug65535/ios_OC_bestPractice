//
//  imageShowCell.h
  
//
//  Created by lucifer on 16/8/29.
 
//

#import <UIKit/UIKit.h>

@interface imageShowCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@property(nonatomic,strong)UIImage *image;


@property(nonatomic,copy)NSString *imageUrl;
@end
