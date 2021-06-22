//
//  MenuView.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MenuView.h"
#import "MenuCell.h"
#import "CDLoginRegistVc.h"

#import "CDPersonalSetting.h"


#import "CDChangeName.h"

@implementation MenuView
+(instancetype)menuView
{
    MenuView *result = nil;

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    for (id object in nibView)
    {
        if ([object isKindOfClass:[self class]])
        {
            result = object;
            
            break;
        }
    }
    

//

    return result;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {


	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didchangeName) name:CDDidChangeName object:nil];
		

	}
	return self;
}

-(void)didchangeName{
	CDAcount *account = [CDAcount accountFromSandbox];

	[self.userPic sd_setImageWithURL:[NSURL URLWithString:account.avatar]];

	self.userName.text  = account.user_name;
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter]removeObserver: self];
}

-(void)didSelectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didSelectRowAtIndexPath{
    _didSelectRowAtIndexPath = [didSelectRowAtIndexPath copy];
}

- (IBAction)exitLogin:(UIButton *)sender {
    //退出登录

    
    NSString *accountPath = [@"account.data" appendDocumentDir];
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    
    [fileManager removeItemAtPath:accountPath error:nil];

//    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    
//    CDLoginRegistVc *loginVC = [[UIStoryboard storyboardWithName:@"CDLoginRegistVC" bundle:nil]instantiateInitialViewController];
//
//
//	[[self getCurrentVC] presentViewController:loginVC animated:YES completion:nil];


	[[NSNotificationCenter defaultCenter] postNotificationName:CDClickExit object:nil];


//    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:loginVC];
//    [self.window makeKeyAndVisible];

}


- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}



-(void)setItems:(NSArray *)items{
    _items = items;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personevent:)];
    [self.personView addGestureRecognizer:tapGesture];
    
    CDAcount *account = [CDAcount accountFromSandbox];
    self.phoneNum.text =account.phone;
    [self.userPic sd_setImageWithURL:[NSURL URLWithString:account.avatar]];
    self.userName.text  = account.user_name;
    
    //uiview 添加事件
    self.personView.userInteractionEnabled = YES;
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.myTableView setTableFooterView:view];
    
}



- (void)personevent:(UITapGestureRecognizer *)gesture {
    // 跳转到个人详情
   

//    CDPersonalSetting *vc = [[UIStoryboard storyboardWithName:@"CDPersonalSetting" bundle:nil]instantiateInitialViewController];

//     CDNav *nav = [[CDNav alloc]initWithRootViewController:vc];

//	CDNav *nav = (CDNav *)[self getCurrentVC];

//	CDNav *vc1 = (CDNav *)[self getCurrentVC];

	
//	[nav pushViewController:vc animated:YES];
//  UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = nav;

	[[NSNotificationCenter defaultCenter]postNotificationName:CDClickPersonalSetting object:nil];

    
}



#pragma -mark tableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_didSelectRowAtIndexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        _didSelectRowAtIndexPath(cell,indexPath);
    }
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.myTableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.lable.text = [self.items[indexPath.row] objectForKey:@"title"];
    cell.icon.image = [UIImage imageNamed:[self.items[indexPath.row] objectForKey:@"imagename"]];
    
    return cell;
}




@end
