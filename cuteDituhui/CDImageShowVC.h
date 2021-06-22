//
//  CDImageShowVC.h
  
//
//  Created by lucifer on 16/8/29.
 
//

#import <UIKit/UIKit.h>

#define CDImageAddNoti @"imageAddNoti"
#define CDImageDeleNoti @"imageDeleNoti"

#define CDImagePostNoti @"imagePostNoti"
@interface CDImageShowVC : UIViewController

@property(nonatomic,strong)NSMutableArray *iamgeUrls;

@property(nonatomic,getter=isNOEdit)BOOL isNOEdit;


@property(nonatomic,strong)NSMutableArray *images;

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectView;

@end
