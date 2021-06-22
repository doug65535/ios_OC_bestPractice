//
//  CDChangeName.m
  
//
//  Created by lucifer on 2016/10/11.
 
//

#import "CDChangeName.h"

@interface CDChangeName ()
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@end

@implementation CDChangeName

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CDAcount *acount = [CDAcount accountFromSandbox];
    
    self.textFiled.placeholder = acount.user_name;
//    self.textFiled.text = acount.user_name;
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveName)];
    self.navigationItem.rightBarButtonItem = item;


	self.textFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
	self.textFiled.leftViewMode = UITextFieldViewModeAlways;
	
}

-(void)saveName{
    
    if (self.textFiled.text) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        CDAcount *account = [CDAcount accountFromSandbox];
        
        [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
        [manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"userId"] = account.user_id;
        
        dic[@"nickname"] = self.textFiled.text;
        [manager POST:[NSString stringWithFormat:@"%@users/update",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            CDLog(@"%@",responseObject);
            
            if ([responseObject[@"statecode"] isEqual:@200]&&[responseObject[@"status"] isEqual:@1]) {
                CDAcount *acount = [CDAcount mj_objectWithKeyValues:responseObject[@"result"]];
                account.user_name = acount.user_name;
                [account save];
                [self.navigationController popViewControllerAnimated:YES];
				[[NSNotificationCenter defaultCenter]postNotificationName:CDDidChangeName object:nil];
            }else
            {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
           
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            CDLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
  
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
