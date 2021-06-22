//
//  mapDetailViewController.m
  
//
//  Created by lucifer on 16/8/4.
 
//

#import "mapDetailViewController.h"
#import "titleEidtViewController.h"
#import "mapDetailEditViewController.h"


@interface mapDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *title_arrow;
@property (weak, nonatomic) IBOutlet UILabel *mapDetailViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *mapDetailViewDes;
@property (weak, nonatomic) IBOutlet UIImageView *des_arrow;
@property (weak, nonatomic) IBOutlet UIButton *deleteMapBtn;
- (IBAction)deleteMapClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *detailView;


@property (weak, nonatomic) IBOutlet UISwitch *mapShareSwitch;
- (IBAction)mapShareClick:(id)sender;

@end

@implementation mapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapDetailViewTitle.text = self.mapInfo.title;
    self.mapDetailViewDes.text = self.mapInfo.mapDescription;


	if ([self.mapInfo.rating isEqual:@"1"]) {
		[self.mapShareSwitch setOn:YES];
	}else{
		[self.mapShareSwitch setOn:NO];
	}

    CDAcount *acount = [CDAcount accountFromSandbox];
    if (![acount.user_id isEqual: self.mapInfo.user_id]) {
        self.title_arrow.hidden = YES;
        self.des_arrow.hidden = YES;
        self.deleteMapBtn.hidden = YES;
    }else
    {
        self.titleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleViewClick)];
        [self.titleView addGestureRecognizer:tapGes];
        
        self.detailView.userInteractionEnabled = YES;
        UITapGestureRecognizer *desGes = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(detailViewClick)];
        [self.detailView addGestureRecognizer:desGes];
    }
    
    self.title = @"地图信息";
}

-(void)titleViewClick{
    titleEidtViewController *titleEditVC = [[UIStoryboard storyboardWithName:@"titleEditViewController" bundle:nil]instantiateInitialViewController];
    titleEditVC.mapInfo = self.mapInfo;
    
    // 接受值
    titleEditVC.pass_title = ^(NSString *map_title){
        self.mapDetailViewTitle.text = map_title;
        self.mapInfo.title = map_title;
            // 传递值
        self.pass_title(map_title);
    };
    
[self.navigationController pushViewController:titleEditVC animated:YES];
    
}


-(void)detailViewClick{
    mapDetailEditViewController *detailVC = [[UIStoryboard storyboardWithName:@"mapDetailEditViewController" bundle:nil]instantiateInitialViewController];
    detailVC.mapInfo = self.mapInfo;
    
    // 接受值
    detailVC.passDes = ^(NSString *map_des){
        self.mapDetailViewDes.text = map_des;
        self.mapInfo.mapDescription = map_des;
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)deleteMapClick:(UIButton *)sender {

	UIAlertController *vc = [[UIAlertController alloc]init];

	UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
		CDAcount *account = [CDAcount accountFromSandbox];

		[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
		[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

		NSMutableDictionary *dic = [NSMutableDictionary dictionary];
		dic[@"map_id"] = self.mapInfo.map_id;

		[manager POST:[NSString stringWithFormat:@"%@deletemap",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			if ([responseObject[@"status"] isEqual: @1]) {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
					//发通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deletedMap" object:nil];
				[SVProgressHUD showSuccessWithStatus:@"删除地图成功"];
			}else
				{
				[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
				}
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			CDLog(@"%@",error);
		}];

	}];

	UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[vc dismissViewControllerAnimated:YES completion:nil];
	}];

	vc.title = @"是否确认删除";


	[vc addAction:action2];
	[vc addAction:action1];

	[self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)mapShareClick:(id)sender {
	if (self.mapShareSwitch.on) {
		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

		CDAcount *account = [CDAcount accountFromSandbox];

		[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
		[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

		NSMutableDictionary *dic = [NSMutableDictionary dictionary];

		dic[@"share"] = @"true";
		dic[@"map_id"] = self.mapInfo.map_id;
		dic[@"user_id"] = account.user_id;

		[manager POST:[NSString stringWithFormat:@"%@map/share",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			if ([responseObject[@"status"] isEqual:@1]) {
				[SVProgressHUD showSuccessWithStatus:@"已切换至可分享地图"];
				CDMapInfo *mapinfo = [CDMapInfo mj_objectWithKeyValues:responseObject[@"result"]];

				NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
				dic1[@"mapInfo"] = mapinfo;

				[[NSNotificationCenter defaultCenter]postNotificationName:mapDetailChangeMap object:nil userInfo:dic1];
			}else{
				[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
				[self.mapShareSwitch setOn:NO];
			}
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			CDLog(@"%@",error);
			[SVProgressHUD showErrorWithStatus:@"网络错误"];
		}];
	}else{
		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

		CDAcount *account = [CDAcount accountFromSandbox];

		[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
		[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

		NSMutableDictionary *dic = [NSMutableDictionary dictionary];

		dic[@"share"] = @"false";
		dic[@"map_id"] = self.mapInfo.map_id;
		dic[@"user_id"] = account.user_id;

		[manager POST:[NSString stringWithFormat:@"%@map/share",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			if ([responseObject[@"status"] isEqual:@1]) {
				[SVProgressHUD showSuccessWithStatus:@"已切换至不可分享地图"];
				CDMapInfo *mapinfo = [CDMapInfo mj_objectWithKeyValues:responseObject[@"result"]];

				NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
				dic1[@"mapInfo"] = mapinfo;

				[[NSNotificationCenter defaultCenter]postNotificationName:mapDetailChangeMap object:nil userInfo:dic1];
			}else{
				[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
				[self.mapShareSwitch setOn:YES];
			}
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			CDLog(@"%@",error);
			[SVProgressHUD showErrorWithStatus:@"网络错误"];
		}];
	}

}
@end
