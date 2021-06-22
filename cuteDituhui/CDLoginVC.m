//
//  CDLoginVC.m
  
//
//  Created by lucifer on 16/7/22.
 
//

#import "CDLoginVC.h"
#import "RootViewController.h"

#import "CDRegistVC.h"
#import "CDRestPassWord.h"

#import "JPUSHService.h"


@interface CDLoginVC ()<UITextFieldDelegate>

{
    BOOL isPassWordShow;
}

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)loginClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *passWordShow;
- (IBAction)passWordShow:(id)sender;
- (IBAction)forgetPWD:(id)sender;

@end

@implementation CDLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    self.userName.delegate = self;
    self.passWord.delegate = self;



	UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLogon)];
	self.navigationItem.rightBarButtonItem = rightBarItem;


	[self.passWord addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];

	[self.passWord addTarget:self action:@selector(textFieldchange) forControlEvents:UIControlEventAllEditingEvents];
	[self.userName addTarget:self action:@selector(textFieldchange) forControlEvents:UIControlEventAllEditingEvents];

}
-(void)didClickLogon
{
	CDRegistVC *vc = [[UIStoryboard storyboardWithName:@"CDRegistVC" bundle:nil]instantiateInitialViewController];
	[self.navigationController pushViewController:vc animated:YES];
}



- (void)textFieldEditChanged:(UITextField *)textField

{
	self.passWordShow.hidden = NO;
}

-(void)textFieldchange
{
	if (self.userName.text.length >0 && self.passWord.text.length>0) {
			        [self.loginBtn setImage:[UIImage imageNamed:@"btn_login_selected"] forState:UIControlStateNormal];
			        self.loginBtn.userInteractionEnabled = YES;
			    }else{
			        [self.loginBtn setImage:[UIImage imageNamed:@"btn_Login_disabled"] forState:UIControlStateNormal];
			        self.loginBtn.userInteractionEnabled = NO;
			    }

}


//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//
//
//
//    if (self.userName.text.length >1 && self.passWord.text.length>1) {
//        [self.loginBtn setImage:[UIImage imageNamed:@"btn_login_selected"] forState:UIControlStateNormal];
//        self.loginBtn.userInteractionEnabled = YES;
//    }else{
//        [self.loginBtn setImage:[UIImage imageNamed:@"btn_Login_disabled"] forState:UIControlStateNormal];
//        self.loginBtn.userInteractionEnabled = NO;
//    }
//    
////    CDLog(@"%tu",self.passWord.text.length);
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginClick:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"登录中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"login"] = self.userName.text;
    dic[@"password"] = self.passWord.text;
    
    NSString *url =[NSString stringWithFormat:@"%@phone/login",baseUrl];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CDLog(@"%@",responseObject);
       
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"status"] isEqual:@1]) {
            CDAcount *userinfo = [CDAcount mj_objectWithKeyValues:responseObject[@"result"]];
//            CDLog(@"%@",userinfo);

            [userinfo save];
            
            RootViewController *homeVC = [[UIStoryboard storyboardWithName:@"RootViewController" bundle:nil] instantiateInitialViewController];
            
            homeVC.userInfo = userinfo;


				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[JPUSHService setTags:nil alias:[NSString stringWithFormat:@"user_opera%@",userinfo.user_id] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
						CDLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
					}];
				});



            CDNav *navigationController =[[CDNav alloc]initWithRootViewController:homeVC];
            
            [self presentViewController:navigationController animated:YES completion:nil];


        }else{
            [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
              [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
   
        CDLog(@"%@",error);
    }];
    

}
- (IBAction)passWordShow:(id)sender {
    if (!isPassWordShow) {
        [sender setImage:[UIImage imageNamed:@"icon_display_selected"] forState:UIControlStateNormal];
        self.passWord.secureTextEntry = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"icon_display_default"] forState:UIControlStateNormal];
        self.passWord.secureTextEntry = YES;
    }

    isPassWordShow = !isPassWordShow;
}

- (IBAction)forgetPWD:(id)sender {
    CDRestPassWord *vc = [[UIStoryboard storyboardWithName:@"CDRestPassWord" bundle:nil]instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
