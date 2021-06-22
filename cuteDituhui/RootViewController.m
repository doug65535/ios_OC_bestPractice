//
//  RootViewController.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "RootViewController.h"
#import "MenuView.h"
#import "NextViewController.h"
#import "CDRootViewCell.h"
#import "teamsListView.h"

#import "mapViewController.h"

#import "CDLoginRegistVc.h"

#import "CDPersonalSetting.h"

#import "JPUSHService.h"
#import "CDJpushModel.h"
#import "CDJpushOrigin.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath *selectIndexPath;
    NSString *select_team_id;
}

@property(nonatomic,strong)NSMutableArray *mapInfoArr;
@property(nonatomic,strong)NSMutableArray *teamsInfoArr;

@property(nonatomic,assign)BOOL isCloseTeamList;
@property(nonatomic,strong)UIView *teamListView;

@property (weak, nonatomic) IBOutlet UIView *daoqiHideView;

@property (weak, nonatomic) IBOutlet UIButton *cover;
- (IBAction)coverClick:(UIButton *)sender;

- (IBAction)contactUs:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *laber;

@end

@implementation RootViewController

-(NSMutableArray *)mapInfoArr{
    if (!_mapInfoArr) {
        _mapInfoArr = [[NSMutableArray alloc]init];
    }
    
    return _mapInfoArr;
}

-(NSMutableArray *)teamsInfoArr{
    if (!_teamsInfoArr) {
        _teamsInfoArr = [[NSMutableArray alloc]init];
    }
    return _teamsInfoArr;
}


+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
	NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
	NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
	NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
	NSComparisonResult result = [dateA compare:dateB];
	NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
	if (result == NSOrderedDescending) {
			NSLog(@"Date1  is in the future");
		return 1;
	}
	else if (result ==NSOrderedAscending){
			NSLog(@"Date1 is in the past");
		return -1;
	}
		NSLog(@"Both dates are the same");
	return 0;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

	self.title = @"";

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

	[self loadLeftBar];

	CDAcount *account = [CDAcount accountFromSandbox];

	NSDate *currentDate = [NSDate date];//获取当前时间，日期


	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [dateFormatter dateFromString:account.user_role.end_time];


	self.laber.text = [NSString stringWithFormat:@"您好！您的团队“%@”服务已经到期暂停使用，请联系客服",account.user_name];
	
	if ([[self class] compareOneDay:date withAnotherDay:currentDate] >0) {

		self.tableView.hidden = NO;
		self.daoqiHideView.hidden = YES;
	}else{
			CDLog(@"过期");
		self.tableView.hidden = YES;
		self.daoqiHideView.hidden = NO;
	}
    
    self.isCloseTeamList = YES;

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:testView];

    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    [self.creatNewMapView addGestureRecognizer:tapGesture];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
       CDAcount *userInfo = [CDAcount accountFromSandbox];
    select_team_id =userInfo.default_team_id;


	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[SVProgressHUD showWithStatus:@"正在加载地图列表"];
	});
    [self loadMapList:userInfo.default_team_id];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedMap) name:@"deletedMap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatNewMapViewLoadList) name:CDLoadedNewMap object:nil];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(personViewClick) name:CDClickPersonalSetting object:nil];


	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitClick) name:CDClickExit object:nil];

    _sideSlipView = [[JKSideSlipView alloc]initWithSender:self];
    
    MenuView *menu = [MenuView menuView];
    [menu didSelectRowAtIndexPath:^(id cell, NSIndexPath *indexPath) {
        NSLog(@"click");
        [_sideSlipView hide];
        //        NextViewController *next = [[NextViewController alloc]init];
        //        [self.navigationController pushViewController:next animated:YES];
        if (indexPath.row == 0) {
            [[SDWebImageManager sharedManager].imageCache clearDisk];
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"缓存已清除"];
        }else
        {
            
            NextViewController *next = [[NextViewController alloc]init];
            [self.navigationController pushViewController:next animated:YES];
        }
        
        
    }];

    menu.items = @[@{@"title":@"清除缓存",@"imagename":@"icon_delete"},@{@"title":@"关于我们",@"imagename":@"icon_about"}];
    [_sideSlipView setContentView:menu];
//	[_sideSlipView bringSubviewToFront:menu];


//    [[UIApplication sharedApplication].keyWindow addSubview:_sideSlipView];
	[self.navigationController.view addSubview:_sideSlipView];

//	[self.navigationController.view addSubview:_sideSlipView];
////    [self.view addSubview:_sideSlipView];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadMapList:select_team_id];
    }];
    
}


- (void)networkDidReceiveMessage:(NSNotification *)notification {
	NSDictionary * userInfo = [notification userInfo];
	NSString *content = [userInfo valueForKey:@"content"];

	CDJpushModel *model = [CDJpushModel mj_objectWithKeyValues:content];

	CDAcount *account = [CDAcount accountFromSandbox];
	if ([model.origin.user_id isEqual:account.user_id] && [model.origin.device isEqual:@"phone_ios"]) {
			//不处理
	}else{
		if ([model.action isEqualToString:@"com.dituhui.cute.action.user_photo_edit"]
			|| [model.action isEqualToString:@"com.dituhui.cute.action.userinfo_edit"] ||[model.action isEqualToString:@"com.dituhui.cute.action.user_phone_edit"]) {
			CDAcount *acount = [CDAcount mj_objectWithKeyValues:model.result];
			[acount save];

			MenuView *menu = [MenuView menuView];
			[menu didSelectRowAtIndexPath:^(id cell, NSIndexPath *indexPath) {
				NSLog(@"click");
				[_sideSlipView hide];
					//        NextViewController *next = [[NextViewController alloc]init];
					//        [self.navigationController pushViewController:next animated:YES];
				if (indexPath.row == 0) {
					[[SDWebImageManager sharedManager].imageCache clearDisk];
					[self.tableView reloadData];
					[SVProgressHUD showSuccessWithStatus:@"缓存已清除"];
				}else
					{

					NextViewController *next = [[NextViewController alloc]init];
					[self.navigationController pushViewController:next animated:YES];
					}


			}];
			menu.items = @[@{@"title":@"清除缓存",@"imagename":@"icon_delete"},@{@"title":@"关于我们",@"imagename":@"icon_about"}];
			[_sideSlipView setContentView:menu];
		}
	}

	if ([model.action isEqualToString:@"com.dituhui.cute.action.team_edit"]) {
		CDTeamInfo *teamInfo = [CDTeamInfo mj_objectWithKeyValues:model.result];

		CDTeamInfo *team_temp = [[CDTeamInfo alloc]init];
		for (CDTeamInfo *team in self.teamsInfoArr) {
			if ([team.team_id isEqual:teamInfo.team_id]) {
				team_temp = team;
			}
		}
		[self.teamsInfoArr removeObject:team_temp];
		[self.teamsInfoArr addObject:teamInfo];

		[self.teamListView removeFromSuperview];

			//团队列表传值
		teamsListView *teamView = [teamsListView instanceTextView];

		teamView.teamIdPass = ^(CDTeamInfo *teamId){

			self.laber.text = [NSString stringWithFormat:@"您好！您的团队“%@”服务已经到期暂停使用，请联系客服",teamId.team_name];

				//			CDAcount *account = [CDAcount accountFromSandbox];


			NSSet *set = [NSSet setWithObjects:[NSString stringWithFormat:@"team_opera%@",teamId.team_id], nil];
				//注册团队
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[JPUSHService setTags:set alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
					CDLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
				}];
			});


			NSDate *currentDate = [NSDate date];//获取当前时间，日期


			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			NSDate *date = [dateFormatter dateFromString:teamId.create_user.user_role.end_time];


			if ([[self class] compareOneDay:date withAnotherDay:currentDate] >0) {
				CDLog(@"过期");
				self.tableView.hidden = NO;
				self.daoqiHideView.hidden = YES;
			}else{
				self.tableView.hidden = YES;
				self.daoqiHideView.hidden = NO;
			}


			select_team_id = teamId.team_id;
				//            CDLog(@"%@",teamId);

			[SVProgressHUD showWithStatus:@"正在加载地图列表..."];
			[self loadMapList:teamId.team_id];




   UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];

			[imageView sd_setImageWithURL:[NSURL URLWithString:teamId.logo]];

			UIFont * tfont = [UIFont systemFontOfSize:14];

				//计算文本宽度
			CGRect tmpRect = [teamId.team_name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,44 ) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName, nil] context:nil];

			NSLog(@"%f",tmpRect.size.width);

			UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(20 +5, 0, tmpRect.size.width +5, 44)];
			laber.font = [UIFont systemFontOfSize:14.0f];
			laber.text = teamId.team_name;
			laber.textColor = [UIColor whiteColor];

			UIImageView *siginView = [[UIImageView alloc]initWithFrame:CGRectMake(tmpRect.size.width +20 +5, 20, 10, 10)];
			siginView.image = [UIImage imageNamed:@"icon_down"];

			UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(20+tmpRect.size.width +20, 0, 20+tmpRect.size.width +20 +5, 44)];

			UIImage *aimage = [UIImage imageNamed:@"btn_unfold"];
			UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
			UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(personInfoClick)];

			[testView addSubview:imageView];
			[testView addSubview:laber];
			[testView addSubview:siginView];

			UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc]initWithCustomView:testView];

			testView.userInteractionEnabled = YES;
			UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBarevent:)];
			[testView addGestureRecognizer:tapGesture];

			[self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftItem1,leftItem2,nil] animated:YES];
		};


		[teamView setFrame:CGRectMake(0, 64, kWidth, self.teamsInfoArr.count * 40 + 40)];

		teamView.teamsArr = self.teamsInfoArr;

		[self.view addSubview:teamView];

		teamView.hidden = YES;

		self.teamListView = teamView;



		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];

		[imageView sd_setImageWithURL:[NSURL URLWithString:teamInfo.logo]];

		UIFont * tfont = [UIFont systemFontOfSize:14];

			//计算文本宽度
		CGRect tmpRect = [teamInfo.team_name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,44 ) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName, nil] context:nil];

		NSLog(@"%f",tmpRect.size.width);

		UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(20 +5, 0, tmpRect.size.width +5, 44)];
		laber.font = [UIFont systemFontOfSize:14.0f];
		laber.text = teamInfo.team_name;
		laber.textColor = [UIColor whiteColor];

		UIImageView *siginView = [[UIImageView alloc]initWithFrame:CGRectMake(tmpRect.size.width +20 +5, 20, 10, 10)];
		siginView.image = [UIImage imageNamed:@"icon_down"];

		UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(20+tmpRect.size.width +20, 0, 20+tmpRect.size.width +20 +5, 44)];

		UIImage *aimage = [UIImage imageNamed:@"btn_unfold"];
		UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(personInfoClick)];

		[testView addSubview:imageView];
		[testView addSubview:laber];
		[testView addSubview:siginView];

		UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc]initWithCustomView:testView];

		testView.userInteractionEnabled = YES;
		UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBarevent:)];
		[testView addGestureRecognizer:tapGesture];

		[self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftItem1,leftItem2,nil] animated:YES];

	}


	if ([model.action isEqualToString:@"com.dituhui.cute.action.map_create"]) {
		CDMapInfo *newInfo = [CDMapInfo mj_objectWithKeyValues:model.result];


		[self.mapInfoArr addObject:newInfo];

		[self.tableView reloadData];
	}

	if ([model.action isEqualToString:@"com.dituhui.cute.action.map_delete"]) {
		[self loadMapList:select_team_id];
	}
	

}


-(void)exitClick
{
//	  CDLoginRegistVc *loginVC = [[UIStoryboard storyboardWithName:@"CDLoginRegistVC" bundle:nil]instantiateInitialViewController];
//	[self presentViewController:loginVC animated:YES completion:nil];


	CDLoginRegistVc *loginVC = [[UIStoryboard storyboardWithName:@"CDLoginRegistVC" bundle:nil]instantiateInitialViewController];

	UINavigationController *nav =[[CDNav alloc]initWithRootViewController:loginVC];


//	[self dismissViewControllerAnimated:YES completion:nil];

	[self presentViewController:nav animated:YES completion:nil];



	CDAcount *account  = [CDAcount accountFromSandbox];
	account = nil;
	[account save];



}



-(void)personViewClick
{
    
    CDPersonalSetting *vc = [[UIStoryboard storyboardWithName:@"CDPersonalSetting" bundle:nil]instantiateInitialViewController];

	[_sideSlipView hide];
    [self.navigationController pushViewController:vc
										 animated:YES];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)creatNewMapViewLoadList{
		[SVProgressHUD dismiss];
      [self loadMapList:select_team_id];
}

-(void)deletedMap{
    [self loadMapList:select_team_id];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)loadMapList:(NSString *)team_id{


    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    CDAcount *account = [CDAcount accountFromSandbox];

    dic[@"team_id"] = team_id;
    dic[@"user_id"] =account.user_id;
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
    
    [manager GET:[NSString stringWithFormat:@"%@queryMapsByTeamid",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        CDLog(@"%@",responseObject);

//		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

//		});

        if ([responseObject[@"status"] isEqual:@1]) {

			[SVProgressHUD dismiss];
            NSArray *mapInfoArr = [CDMapInfo mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];




            [self.mapInfoArr removeAllObjects];
            
            [self.mapInfoArr addObjectsFromArray:mapInfoArr];
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
        }else{
			if ([responseObject[@"statecode"] isEqual:@401]) {
				[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
				CDNav *nav = [[CDNav alloc]init];
				CDLoginRegistVc *view = [[UIStoryboard storyboardWithName:@"CDLoginRegistVC" bundle:nil]instantiateInitialViewController];
				[nav addChildViewController:view];
				[self presentViewController:nav animated:YES completion:nil];
			}

			}
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}



-(void)loadLeftBar
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    CDAcount *account = [CDAcount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    CDAcount *acount = [CDAcount accountFromSandbox];
    parameters[@"user_id"] =acount.user_id;
    
    [manager GET:[NSString stringWithFormat:@"%@team/queryTeamsByUserid",baseUrl] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"statecode"] isEqual:@401]) {
            CDNav *nav = [[CDNav alloc]init];
            CDLoginRegistVc *view = [[UIStoryboard storyboardWithName:@"CDLoginRegistVC" bundle:nil]instantiateInitialViewController];
            [nav addChildViewController:view];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
        
        CDTeamInfo *teamInfo ;
        
        NSArray *teamInfoArr =[CDTeamInfo mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
        
        [self.teamsInfoArr addObjectsFromArray:teamInfoArr];
        
        //团队列表传值
        teamsListView *teamView = [teamsListView instanceTextView];
        
        teamView.teamIdPass = ^(CDTeamInfo *teamId){

	self.laber.text = [NSString stringWithFormat:@"您好！您的团队“%@”服务已经到期暂停使用，请联系客服",teamId.team_name];

//			CDAcount *account = [CDAcount accountFromSandbox];


			NSSet *set = [NSSet setWithObjects:[NSString stringWithFormat:@"team_opera%@",teamId.team_id], nil];
				//注册团队
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[JPUSHService setTags:set alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
					CDLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
				}];
			});


			NSDate *currentDate = [NSDate date];//获取当前时间，日期


			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			NSDate *date = [dateFormatter dateFromString:teamId.create_user.user_role.end_time];


			if ([[self class] compareOneDay:date withAnotherDay:currentDate] >0) {
				CDLog(@"过期");
				self.tableView.hidden = NO;
				self.daoqiHideView.hidden = YES;
			}else{
				self.tableView.hidden = YES;
				self.daoqiHideView.hidden = NO;
			}


            select_team_id = teamId.team_id;
//            CDLog(@"%@",teamId);

			[SVProgressHUD showWithStatus:@"正在加载地图列表..."];
            [self loadMapList:teamId.team_id];

			


   UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];

			[imageView sd_setImageWithURL:[NSURL URLWithString:teamId.logo]];

			UIFont * tfont = [UIFont systemFontOfSize:14];

				//计算文本宽度
			CGRect tmpRect = [teamId.team_name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,44 ) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName, nil] context:nil];

			NSLog(@"%f",tmpRect.size.width);

			UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(20 +5, 0, tmpRect.size.width +5, 44)];
			laber.font = [UIFont systemFontOfSize:14.0f];
			laber.text = teamId.team_name;
			laber.textColor = [UIColor whiteColor];

			UIImageView *siginView = [[UIImageView alloc]initWithFrame:CGRectMake(tmpRect.size.width +20 +5, 20, 10, 10)];
			siginView.image = [UIImage imageNamed:@"icon_down"];

			UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(20+tmpRect.size.width +20, 0, 20+tmpRect.size.width +20 +5, 44)];

			UIImage *aimage = [UIImage imageNamed:@"btn_unfold"];
			UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
			UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(personInfoClick)];

			[testView addSubview:imageView];
			[testView addSubview:laber];
			[testView addSubview:siginView];

			UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc]initWithCustomView:testView];

			testView.userInteractionEnabled = YES;
			UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBarevent:)];
			[testView addGestureRecognizer:tapGesture];

			[self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftItem1,leftItem2,nil] animated:YES];
        };


        [teamView setFrame:CGRectMake(0, 64, kWidth, self.teamsInfoArr.count * 40 + 40)];

        teamView.teamsArr = self.teamsInfoArr;
        
        [self.view addSubview:teamView];

        teamView.hidden = YES;
     
        self.teamListView = teamView;
        
            
        for (CDTeamInfo *team in teamInfoArr) {
            if ([team.team_id isEqual:acount.default_team_id]) {
                teamInfo = team;
            }
        }

			NSSet *set = [NSSet setWithObjects:[NSString stringWithFormat:@"team_opera%@",teamInfo.team_id], nil];
				//注册团队
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[JPUSHService setTags:set alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
					CDLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
				}];
			});

        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:teamInfo.logo]];
        
        UIFont * tfont = [UIFont systemFontOfSize:14];
        
        //计算文本宽度
        CGRect tmpRect = [teamInfo.team_name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,44 ) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName, nil] context:nil];
        
        NSLog(@"%f",tmpRect.size.width);
        
        UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(20 +5, 0, tmpRect.size.width +5, 44)];
        laber.font = [UIFont systemFontOfSize:14.0f];
        laber.text = teamInfo.team_name;
        laber.textColor = [UIColor whiteColor];
        
        UIImageView *siginView = [[UIImageView alloc]initWithFrame:CGRectMake(tmpRect.size.width +20 +5, 20, 10, 10)];
        siginView.image = [UIImage imageNamed:@"icon_down"];
        
        UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(20+tmpRect.size.width +20, 0, 20+tmpRect.size.width +20 +5, 44)];
        
        UIImage *aimage = [UIImage imageNamed:@"btn_unfold"];
        UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(personInfoClick)];
        
        [testView addSubview:imageView];
        [testView addSubview:laber];
        [testView addSubview:siginView];
        
        UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc]initWithCustomView:testView];
        
        testView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBarevent:)];
        [testView addGestureRecognizer:tapGesture];
        
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftItem1,leftItem2,nil] animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.teamListView.hidden = YES;
}

- (void)leftBarevent:(UITapGestureRecognizer *)gesture {
            NSLog(@"点击了left");
    
    self.isCloseTeamList = !self.isCloseTeamList;
    
    if (self.isCloseTeamList == YES) {
        self.teamListView.hidden = YES;
    }else{
        self.teamListView.hidden =NO;
    }
    
}


- (void)event:(UITapGestureRecognizer *)gesture {
    
    if (!_sideSlipView.isOpen) {
        NSLog(@"单机");
        mapViewController *mapVC = [[UIStoryboard storyboardWithName:@"mapViewController" bundle:nil] instantiateInitialViewController];
        mapVC.selectTeamId = select_team_id;
        mapVC.isNewMap = YES;
        CDNav *nav =[[CDNav alloc]initWithRootViewController:mapVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)personInfoClick{

    [_sideSlipView switchMenu];
}
                                             
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mapInfoArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDRootViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    cell.mapInfo = self.mapInfoArr[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CDMapInfo *mapInfo = self.mapInfoArr[indexPath.row];

		//注册地图tag
	NSSet *set = [NSSet setWithObjects:[NSString stringWithFormat:@"team_opera%@",mapInfo.team_id],[NSString stringWithFormat:@"map_opera%@",mapInfo.map_id], nil];
		//注册团队
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[JPUSHService setTags:set alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
			CDLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
		}];
	});

    mapViewController *mapVC = [[UIStoryboard storyboardWithName:@"mapViewController" bundle:nil] instantiateInitialViewController];
    mapVC.mapInfo = mapInfo;
    
    selectIndexPath = indexPath;
    mapVC.changedMapTitle = ^(NSString *passTitle){
        CDRootViewCell *cell = [tableView cellForRowAtIndexPath:selectIndexPath];
        cell.mapTitle.text = passTitle;
    };
    
    CDNav *nav =[[CDNav alloc]initWithRootViewController:mapVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (IBAction)coverClick:(UIButton *)sender {
}

- (IBAction)contactUs:(UIButton *)sender {

	NSString *allString = [NSString stringWithFormat:@"tel:01059896993"];

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}
@end
