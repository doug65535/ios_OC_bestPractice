//
//  CDImageShowVC.m
  
//
//  Created by lucifer on 16/8/29.
 
//

#import "CDImageShowVC.h"
#import "imageShowCell.h"

#import <AVFoundation/AVFoundation.h>


#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


#import "UIViewController+BackButtonHandler.h"


#import "HZPhotoBrowser.h"

@interface CDImageShowVC ()<TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HZPhotoBrowserDelegate>


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;



@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *lastImageView;
@property (nonatomic, assign)CGRect originalFrame;
@property (nonatomic, assign)BOOL isDoubleTap;
@property(nonatomic,strong)HZPhotoBrowser *phtotBrowser;

@property(nonatomic,strong)UIImage *collectimage;
@end

@implementation CDImageShowVC

-(NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc]init];
    }
    return _images;
}

-(NSMutableArray *)iamgeUrls
{
    if (!_iamgeUrls) {
        _iamgeUrls = [[NSMutableArray alloc]init];
    }
    return _iamgeUrls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.images.count) {
          self.title = [NSString stringWithFormat:@"图片列表(%tu)",self
                        .images.count];
    }else
    {
        self.title = [NSString stringWithFormat:@"图片列表(%tu)",self
                      .iamgeUrls.count];

    }
  
    
     self.layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    self.layout.minimumLineSpacing = 10;
    self.layout.minimumInteritemSpacing = 10;
    self.imageCollectView.contentInset = UIEdgeInsetsMake(-44, 10, 10, 10);
    self.layout.itemSize = CGSizeMake((kWidth - 30)/2, (kWidth - 30)/2);
	

    if (!self.isNOEdit) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加图片" style:UIBarButtonItemStylePlain target:self action:@selector(addNewImage)];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                initWithTarget:self
                                                   action:@selector(myHandleTableviewCellLongPressed:)];
        longPress.minimumPressDuration = 1.0;

        [self.imageCollectView addGestureRecognizer:longPress];
    }




}



#pragma mark - photobrowser代理方法


-(void)cellChangeL:(NSInteger)index
{
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	imageShowCell *cell = (imageShowCell *)[self.imageCollectView cellForItemAtIndexPath:indexPath];
	_phtotBrowser.sourceImagesContainerView = cell;

}

-(UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{

	return self.collectimage;

}

-(NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
	if (self.iamgeUrls.count) {
		return _iamgeUrls[index];
	}

	return  nil;

}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

	imageShowCell *cell = (imageShowCell *)[collectionView cellForItemAtIndexPath:indexPath];

	HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
	_phtotBrowser = browserVc;
	browserVc.sourceView =cell;
		//        browserVc.sourceImagesContainerView = cell.superview;

	if (self.iamgeUrls.count) {
		browserVc.imageCount = self.iamgeUrls.count;
		browserVc.currentImageIndex = (int)indexPath.item;
	}
	else
		{
		browserVc.imageCount = 1;
		browserVc.currentImageIndex = 0;
		}


		//     SMLog(@"%d",browserVc.currentImageIndex);
	self.collectimage = cell.imageview.image;
		// 代理
	browserVc.delegate = self;

		//    SMLog(@"%@",cell);
		// 展示图片浏览器
	[self presentViewController:browserVc animated:NO completion:nil];




		//scrollView作为背景
// UIScrollView *bgView = [[UIScrollView alloc] init];
// bgView.frame = [UIScreen mainScreen].bounds;
// bgView.backgroundColor = [UIColor blackColor];
// UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
// [bgView addGestureRecognizer:tapBg];
//
// UIImageView *picView = cell.imageview;
//
// UIImageView *imageView = [[UIImageView alloc] init];
// imageView.image = picView.image;
// imageView.frame = [bgView convertRect:picView.frame fromView:self.view];
// [bgView addSubview:imageView];
//
// [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
//
// self.lastImageView = imageView;
// self.originalFrame = imageView.frame;
// self.scrollView = bgView;
//		//最大放大比例
// self.scrollView.maximumZoomScale = 1.5;
// self.scrollView.delegate = self;
//
// [UIView animateWithDuration:0.5 animations:^{
//  CGRect frame = imageView.frame;
//  frame.size.width = bgView.frame.size.width;
//  frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
//  frame.origin.x = 0;
//  frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5;
//  imageView.frame = frame;
// }];

}

-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer
{
 self.scrollView.contentOffset = CGPointZero;
 [UIView animateWithDuration:0.5 animations:^{
  self.lastImageView.frame = self.originalFrame;
  tapBgRecognizer.view.backgroundColor = [UIColor clearColor];
 } completion:^(BOOL finished) {
  [tapBgRecognizer.view removeFromSuperview];
  self.scrollView = nil;
  self.lastImageView = nil;
 }];
}

	//返回可缩放的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
 return self.lastImageView;
}




- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    
    CGPoint pointTouch = [gestureRecognizer locationInView:self.imageCollectView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.imageCollectView indexPathForItemAtPoint:pointTouch];
        if (indexPath == nil) {
              NSLog(@"nil");
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
            
            UIAlertAction *deleteAction =[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
                if (self.images.count) {
                    UIImage *image = self.images[indexPath.row];
                    [self.images removeObject:image];
                    [self.imageCollectView reloadData];
                    
                }else{
            
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                dic[@"deleImageUrl"] = self.iamgeUrls[indexPath.row];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:CDImageDeleNoti object:nil userInfo:dic];
                
                 [self.iamgeUrls removeObject:self.iamgeUrls[indexPath.row]];
                
                [self.imageCollectView reloadData];
                    
                }
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
}

-(void)addNewImage
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        if (self.images.count) {
            [self.images addObjectsFromArray:photos];
            [self.imageCollectView reloadData];
        }else{
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"addImages"] = photos;
        dic[@"VC"] = self;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CDImageAddNoti object:nil userInfo:dic];
        
        [self.imageCollectView reloadData];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (self.images.count) {
        return self.images.count;
    }else{
        return self.iamgeUrls.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imageShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
  
    if (self.images.count) {
        cell.image = self.images[indexPath.item];
    }else{
    cell.imageUrl = self.iamgeUrls[indexPath.item];
    }
   
    return cell;
}



-(BOOL)navigationShouldPopOnBackButton;
{
    if (self.images.count) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[@"images"] = self.images;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:CDImagePostNoti object:nil userInfo:dic];
    }
    return YES;
}



@end
