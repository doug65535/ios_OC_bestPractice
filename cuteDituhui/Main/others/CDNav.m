//
//  CDNav.m
  
//
//  Created by lucifer on 16/8/22.
 
//

#import "CDNav.h"

@interface CDNav ()

@end

@implementation CDNav



+ (void)initialize
{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    UIColor *color1 = [UIColor colorWithRed:39 /255.0  green:42 /255.0 blue:51/255.0 alpha:1];
    
    //    [bar setBackgroundColor:color];
    [bar setBarTintColor:color1];
    
    bar.tintColor = [UIColor whiteColor];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    bar.titleTextAttributes = dic;
    
    

    UIBarButtonItem *item = [UIBarButtonItem appearance];

    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:md forState:UIControlStateNormal];
    

    NSMutableDictionary *higMd = [NSMutableDictionary dictionary];
    higMd[NSForegroundColorAttributeName] = [UIColor greenColor];
    [item setTitleTextAttributes:higMd forState:UIControlStateHighlighted];
    
    
    NSMutableDictionary *disMd = [NSMutableDictionary dictionary];
    disMd[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:disMd forState:UIControlStateDisabled];
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
