//
//  imageShowCell.m
  
//
//  Created by lucifer on 16/8/29.
 
//

#import "imageShowCell.h"

@implementation imageShowCell


-(void)setImage:(UIImage *)image
{
    _image = image;
    
    [self.imageview setImage:self.image];
}

-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
