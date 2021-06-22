//
//  CDMapPartenerTableViewController.m
  
//
//  Created by lucifer on 2016/10/25.
 
//

#import "CDMapPartenerTableViewController.h"
#import "CDCoope.h"
#import "CDCoopeCell.h"

#import "CDMitterViewController.h"

@interface CDMapPartenerTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
	NSMutableArray *parterArr;
	CDCoope *delectCoope;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)removeParterner:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *cover;
- (IBAction)coverClick:(UIButton *)sender;

@end

@implementation CDMapPartenerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title = @"协作成员";


		//UIBarButtonItem *barItem  =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_new"] style:UIBarButtonItemStyleDone target:self action:@selector(addMitter)];

	[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

	UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"邀请成员" style:UIBarButtonItemStyleDone target:self action:@selector(addMitter)];
	self.navigationItem.rightBarButtonItem = barItem;

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveCoope:) name:CDPartenerMoreClick object:nil];

	[self loadTableView];

	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[self loadTableView];
	}];
}


-(void)loadTableView{
	[SVProgressHUD showWithStatus:@"正在加载成员数据……"];
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];

	dic[@"map_id"] = self.mapInfo.map_id;
		//	dic[@"user_id"] = account.user_id;

	[manager GET:[NSString stringWithFormat:@"%@coope/querymembers/%@",baseUrl,self.mapInfo.map_id] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

		if ([responseObject[@"status"] isEqual:@1]) {

			[SVProgressHUD dismiss];
			[self.tableView.mj_header endRefreshing];
			parterArr = [CDCoope mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
			[self.tableView reloadData];
		}else
			{
			[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
			}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];
}

-(void)didReceiveCoope:(NSNotification *)noti
{

	CDCoope *coope = noti.userInfo[@"coope"];

	delectCoope = coope;


	self.cover.hidden =NO;
	self.editView.hidden = NO;
	
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)addMitter{
//	[SVProgressHUD showErrorWithStatus:@"APP暂不支持邀请成员，请在PC端操作"];

	CDMitterViewController *vc = [[UIStoryboard storyboardWithName:@"CDMitterViewController" bundle:nil]instantiateInitialViewController];
	vc.mapInfo = self.mapInfo;
	[self.navigationController pushViewController:vc animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return parterArr.count;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	static NSString *ID = @"cell";
	CDCoopeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[CDCoopeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
	}

	cell.coope = parterArr[indexPath.row];
	return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 75;
}

- (IBAction)removeParterner:(UIButton *)sender {

	UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确定移除成员么？" message:@"成员被移出团队后，将无法查看地图，但数据不会被删除" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[SVProgressHUD showWithStatus:@"正在移除成员"];
		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

		CDAcount *account = [CDAcount accountFromSandbox];

		[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
		[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

		[manager POST:[NSString stringWithFormat:@"%@coope/deletemember/%@/%@/%@",baseUrl,self.mapInfo.map_id,delectCoope.user_id,account.user_id] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			if ([responseObject[@"status"] isEqual:@1]) {
				[parterArr removeAllObjects];
				parterArr = [CDCoope mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
				[self.tableView reloadData];
				[SVProgressHUD dismiss];

			}else
				{
				[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
				}

			self.cover.hidden = YES;
			self.editView.hidden = YES;

		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			CDLog(@"%@",error);
			[SVProgressHUD showErrorWithStatus:@"网络错误"];
		}];

	}];


	UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		self.cover.hidden = YES;
		self.editView.hidden = YES;
		[alertVc dismissViewControllerAnimated:YES completion:nil];
	}];


	[alertVc addAction:action1];
	[alertVc addAction:action2];
	[self presentViewController:alertVc animated:YES completion:nil];


}
- (IBAction)coverClick:(UIButton *)sender {
	sender.hidden = YES;
	self.editView.hidden = YES;
}
@end
