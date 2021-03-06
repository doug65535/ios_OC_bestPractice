//
//  JKSideSlipView.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//
#define SLIP_WIDTH 250

#import "JKSideSlipView.h"
#import <Accelerate/Accelerate.h>

@implementation JKSideSlipView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(nil, @"please init with -initWithSender:sender");
    }
    return self;
}




- (instancetype)initWithSender:(RootViewController *)sender{
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake(-SLIP_WIDTH, 0, SLIP_WIDTH, bounds.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        [self buildViews:sender];
        
        
    }
    return self;
}
-(void)buildViews:(RootViewController *)sender{
    _sender = sender;
    
    _leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    _rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
    _rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
  
    [_sender.view addGestureRecognizer:_leftSwipe];
    [_sender.view addGestureRecognizer:_rightSwipe];
    
    _blurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SLIP_WIDTH, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _blurImageView.userInteractionEnabled = NO;
    
    _blurImageView.alpha = 0;
    _blurImageView.backgroundColor = [UIColor grayColor];
//    _blurImageView.layer.borderWidth = 5;
//    _blurImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_blurImageView];
          _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchMenu)];
}

-(void)setContentView:(UIView*)contentView{
    if (contentView) {
        _contentView = contentView;
    }
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_contentView];

}
-(void)show:(BOOL)show{
    UIImage *image =  [self imageFromView:_sender.parentViewController.view];
   
    if (!_isOpen) {
        _blurImageView.alpha = 1;
    }
    
    CGFloat x = show?0:-SLIP_WIDTH;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
        if(!_isOpen){
        _blurImageView.image = image;
//        _blurImageView.image= [self blurryImage:_blurImageView.image withBlurLevel:0.8];
            //bug
     
            _tap.numberOfTapsRequired = 1;
              [_sender.view addGestureRecognizer:_tap];
            NSLog(@"show");

          
        }
    } completion:^(BOOL finished) {
        _isOpen = show;
        if(!_isOpen){
            _blurImageView.alpha = 0;
            _blurImageView.image = nil;
            NSLog(@"hidden");
            //bug
           
            [_sender.view removeGestureRecognizer:_tap];
//
        }

    }];
    
}


-(void)switchMenu{
    [self show:!_isOpen];
}
-(void)show{
    [self show:YES];
}

-(void)hide {
    [self show:NO];
}


#pragma mark - shot
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - Blur


//- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
//    if ((blur < 0.0f) || (blur > 1.0f)) {
//        blur = 0.5f;
//    }
//    
//    int boxSize = (int)(blur * 100);
//    boxSize -= (boxSize % 2) + 1;
//    
//    CGImageRef img = image.CGImage;
//    
//    vImage_Buffer inBuffer, outBuffer;
//    vImage_Error error;
//    void *pixelBuffer;
//    
//    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
//    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
//    
//    inBuffer.width = CGImageGetWidth(img);
//    inBuffer.height = CGImageGetHeight(img);
//    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
//    
//    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
//    
//    outBuffer.data = pixelBuffer;
//    outBuffer.width = CGImageGetWidth(img);
//    outBuffer.height = CGImageGetHeight(img);
//    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    
//    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
//                                       0, 0, boxSize, boxSize, NULL,
//                                       kvImageEdgeExtend);
//    
//    if (error) {
//        NSLog(@"error from convolution %ld", error);
//    }
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef ctx = CGBitmapContextCreate(
//                                             outBuffer.data,
//                                             outBuffer.width,
//                                             outBuffer.height,
//                                             8,
//                                             outBuffer.rowBytes,
//                                             colorSpace,
//                                             CGImageGetBitmapInfo(image.CGImage));
//    
//    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
//    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
//    
//    //clean up
//    CGContextRelease(ctx);
//    CGColorSpaceRelease(colorSpace);
//    
//    free(pixelBuffer);
//    CFRelease(inBitmapData);
//    
//    CGColorSpaceRelease(colorSpace);
//    CGImageRelease(imageRef);
//    
//    return returnImage;
//}

@end
