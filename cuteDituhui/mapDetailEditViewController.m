//
//  mapDetailEditViewController.m
  
//
//  Created by lucifer on 16/8/4.
 
//

#import "mapDetailEditViewController.h"

@interface mapDetailEditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *desTextView;

@end

@implementation mapDetailEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.desTextView.text = self.mapInfo.mapDescription;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveDes)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.title = @"修改地图描述";
}


-(void)saveDes
{
    [SVProgressHUD showWithStatus:@"正在修改……"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"map_id"] = self.mapInfo.map_id;
    dic[@"description"] = self.desTextView.text;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    CDAcount *account = [CDAcount accountFromSandbox];


	dic[@"user_id"] = account.user_id;
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
    [manager POST:[NSString stringWithFormat:@"%@editMapInfo",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

		if ([responseObject[@"status"]isEqual:@1]) {
			CDMapInfo *mapInfo = [CDMapInfo mj_objectWithKeyValues:responseObject[@"result"]];
			self.passDes(mapInfo.mapDescription);

			[self.navigationController popViewControllerAnimated:YES];

			[SVProgressHUD dismiss];
		}else{
			[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
		}

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CDLog(@"%@",error);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
