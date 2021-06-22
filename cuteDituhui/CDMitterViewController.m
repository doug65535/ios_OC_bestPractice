//
//  CDMitterViewController.m
  
//
//  Created by lucifer on 2016/11/22.
 
//

#import "CDMitterViewController.h"
#import "CDPartenerInfo.h"

#import "CDEnterPWD.h"

#import <UMSocialCore/UMSocialCore.h>

#import "CDAddPartCell.h"

#import "CDMapPartUserInfo.h"

@interface CDMitterViewController ()<UITableViewDelegate,UITableViewDataSource>



@property (weak, nonatomic) IBOutlet UISegmentedControl *segement;

@property (weak, nonatomic) IBOutlet UISwitch *linkSwitch;
- (IBAction)linkSwitchClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *linkHideView;

- (IBAction)copyLink:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *passWordSwitch;
- (IBAction)passWordClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *enterPassWordView;
@property (weak, nonatomic) IBOutlet UIView *passWordHideView;

- (IBAction)QQClick:(id)sender;

- (IBAction)weixinClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *linkDescription;
- (IBAction)segementChange:(id)sender;

- (IBAction)addBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *linkViewHeader;


@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic,strong)CDPartenerInfo *partenerInfo;

@property(nonatomic,strong)NSMutableArray *partArr;


@property (weak, nonatomic) IBOutlet UILabel *PwdDescription;
@property (weak, nonatomic) IBOutlet UILabel *pwdShowLabel;

@end

@implementation CDMitterViewController

-(NSMutableArray *)partArr
{
	if (!_partArr) {
		_partArr = [[NSMutableArray alloc] init];
	}
	return _partArr;
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"邀请成员";


	[self.tableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
	

	self.enterPassWordView.userInteractionEnabled = YES;
	UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PWDViewClick)];
	[self.enterPassWordView addGestureRecognizer:tapGes];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePwd:) name:CDEnterPWDNoti object:nil];

	[self loadPartInfo];

	[self loadTabelViewData];


	self.linkHideView.hidden = NO;
	self.linkViewHeader.hidden = NO;
	self.linkDescription.hidden = NO;

	self.tableview.hidden = YES;
}



-(void)loadTabelViewData
{

	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"map_id"] = self.mapInfo.map_id;

	[manager GET:[NSString stringWithFormat:@"%@team/members/%@",baseUrl,self.mapInfo.team_id ] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSArray *array = [CDMapPartUserInfo mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];

		[self.partArr addObjectsFromArray:array];

		[self.tableview reloadData];

	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

	}];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.partArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

		static NSString *ID = @"parCell";
		CDAddPartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
		if (cell == nil) {
			cell = [[CDAddPartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
		}

	cell.userInfo = self.partArr[indexPath.row];
	cell.addBtn.tag = indexPath.row;

	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 75;
}



-(void)loadPartInfo
{


	[SVProgressHUD showWithStatus:@"正在加载数据……"];


	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];

	dic[@"team_id"] = self.mapInfo.team_id;
	dic[@"map_id"] = self.mapInfo.map_id;
	dic[@"user_id"] = account.user_id;

	[manager POST:[NSString stringWithFormat:@"%@coope/invitation",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

		if ([responseObject[@"status"] isEqual:@1]) {
			[SVProgressHUD dismiss];
			CDPartenerInfo *info = [CDPartenerInfo mj_objectWithKeyValues:responseObject[@"result"]];

			self.partenerInfo = info;

			if (info.caninvi.intValue >= 0) {

				[self.linkSwitch setOn:YES];
				self.linkDescription.text = @"成员加入项目后，为了防止链接泄露可以选择关闭链接";
				self.linkHideView.hidden = NO;

				if (self.partenerInfo.pswd.length) {
					self.enterPassWordView.hidden = NO;
					[self.passWordSwitch setOn:YES];
				}else{
					self.enterPassWordView.hidden = YES;
					[self.passWordSwitch setOn:NO];
				}

				self.passWordHideView.hidden = NO;

			}else{

				[self.linkSwitch setOn:NO];
				self.linkDescription.text = @"邀请好友加入前，请开启链接";
				self.linkHideView.hidden = YES;
			}

			if (info.pswd.length) {

				self.passWordHideView.hidden = NO;
				[self.passWordSwitch setOn:YES];
				self.enterPassWordView.hidden = NO;

				self.PwdDescription.hidden = NO;
				self.pwdShowLabel.text = info.pswd;
			}else{

				self.pwdShowLabel.text = @"无";
				self.PwdDescription.hidden = YES;

				self.passWordHideView.hidden = NO;
				[self.passWordSwitch setOn:NO];
				self.enterPassWordView.hidden = YES;
			}

		}else{
			[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
		}


	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];
}

-(void)didReceivePwd:(NSNotification *)noti
{
	NSDictionary *dic = noti.userInfo;
	NSString *pwd = dic[@"pwd"];

	self.partenerInfo.pswd = pwd;

	if (pwd.length) {
		self.pwdShowLabel.text = pwd;


	}else{
		self.pwdShowLabel.text= @"无";

		
	}
}

-(void)PWDViewClick{
	CDEnterPWD *vc = [[UIStoryboard storyboardWithName:@"CDEnterPWD" bundle:nil]instantiateInitialViewController];
	vc.PWD = self.partenerInfo.pswd;
	vc.mapInfo = self.mapInfo;
	[self.navigationController pushViewController:vc
													animated:YES];

}

- (IBAction)copyLink:(id)sender {

		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		pasteboard.string = self.partenerInfo.url;
	[SVProgressHUD showSuccessWithStatus:@"已经复制到剪切板"];
}
- (IBAction)linkSwitchClick:(id)sender {


	if (self.linkSwitch.isOn) {
		self.linkDescription.text = @"成员加入项目后，为了防止链接泄露可以选择关闭链接";
		self.linkHideView.hidden = NO;

		if (self.partenerInfo.pswd.length) {
			self.enterPassWordView.hidden = NO;
			[self.passWordSwitch setOn:YES];
		}else{
			self.enterPassWordView.hidden = YES;
			[self.passWordSwitch setOn:NO];
		}

	}else{
		self.linkDescription.text = @"邀请好友加入前，请开启链接";
		self.linkHideView.hidden = YES;
	}

	[SVProgressHUD showWithStatus:@"正在处理……"];
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

	[manager POST:[NSString stringWithFormat:@"%@coope/updateInvitation/%@/%@",baseUrl,self.mapInfo.map_id,[NSString stringWithFormat:@"%tu",!self.linkSwitch.isOn]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		if ([responseObject[@"status"] isEqual:@1]) {
			[SVProgressHUD dismiss];
		}else
			{
			[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
			}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];


}
- (IBAction)passWordClick:(id)sender {


	if (self.passWordSwitch.isOn) {
		self.passWordHideView.hidden = NO;
		self.enterPassWordView.hidden = NO;

		self.PwdDescription.hidden = NO;
		self.pwdShowLabel.text = self.partenerInfo.pswd;

	}else{

		self.PwdDescription.hidden = YES;
		self.pwdShowLabel.text = @"无";

		self.passWordHideView.hidden = NO;
		self.enterPassWordView.hidden = YES;


		[SVProgressHUD showWithStatus:@"正在处理……"];

		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
		CDAcount *account = [CDAcount accountFromSandbox];
		[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
		[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];


		NSString *str =[NSString stringWithFormat:@"%@coope/setInvitationpswd/%@",baseUrl,self.mapInfo.map_id];

		[manager POST:str
		   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			if ([responseObject[@"status"] isEqual:@1]) {
				[SVProgressHUD dismiss];
				self.partenerInfo.pswd = @"";
			}else
				{
				[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
				}
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			CDLog(@"%@",error);
			[SVProgressHUD showErrorWithStatus:@"网络错误"];
		}];

	}



}
- (IBAction)QQClick:(id)sender {


	UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

	messageObject.text = self.partenerInfo.url;

	[[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
		if (error) {
			NSLog(@"************Share fail with error %@*********",error);
		}else{
			NSLog(@"response data is %@",data);
		}
	}];
}

- (IBAction)weixinClick:(id)sender {

	UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
		
	messageObject.text = self.partenerInfo.url;

	[[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
		if (error) {
			NSLog(@"************Share fail with error %@*********",error);
		}else{
			NSLog(@"response data is %@",data);
		}
	}];
}

- (IBAction)segementChange:(id)sender {
	if (self.segement.selectedSegmentIndex == 0) {
		self.linkHideView.hidden = NO;
		self.linkViewHeader.hidden = NO;
		self.linkDescription.hidden = NO;

		self.tableview.hidden = YES;
		
	}else{
		self.tableview.hidden = NO;

		self.linkHideView.hidden = YES;
		self.linkViewHeader.hidden = YES;
		self.linkDescription.hidden = YES;
	}
}

- (IBAction)addBtnClick:(UIButton *)sender {
	CDMapPartUserInfo *info = self.partArr[sender.tag];

	[SVProgressHUD showWithStatus:@"正在处理……"];
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"map_id"] = self.mapInfo.map_id;
	dic[@"user_id"] = info.user_id;
	dic[@"team_id"] = self.mapInfo.team_id;
	dic[@"create_user_id"] = account.user_id;

	[manager POST:[NSString stringWithFormat:@"%@coope/member/%@/%@",baseUrl,self.mapInfo.map_id,info.user_id] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		if ([responseObject[@"status"] isEqual:@1]) {
			[SVProgressHUD dismiss];

			sender.userInteractionEnabled = NO;
			[sender setTitle:@"已邀请" forState:UIControlStateNormal];
			[sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
			[sender setBackgroundColor:[UIColor clearColor]];

		}else{
			[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];

}





@end
