//
//  CDEnterPWD.m
  
//
//  Created by lucifer on 2016/11/24.
 
//

#import "CDEnterPWD.h"



@interface CDEnterPWD ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation CDEnterPWD

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"设置密码";

	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
	self.navigationItem.rightBarButtonItem = item;

	self.textField.text = self.PWD;


	self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
	self.textField.leftViewMode = UITextFieldViewModeAlways;

}


-(void)done{

	[SVProgressHUD showWithStatus:@"正在处理……"];
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"pswd"] = self.textField.text;

	[manager POST:[NSString stringWithFormat:@"%@coope/setInvitationpswd/%@",baseUrl,self.mapInfo.map_id] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		if ([responseObject[@"status"] isEqual:@1]) {
			[SVProgressHUD dismiss];

			NSDictionary *dic = [NSDictionary dictionaryWithObject:self.textField.text forKey:@"pwd"];

			[[NSNotificationCenter defaultCenter]postNotificationName:CDEnterPWDNoti object:nil userInfo:dic];


			[self.navigationController popViewControllerAnimated:YES];
		}else{
			[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
