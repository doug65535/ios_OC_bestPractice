//
//  CDRegistVC.m
  
//
//  Created by lucifer on 16/7/22.
 
//

#import "CDRegistVC.h"
#import "CDLoginVC.h"


@interface CDRegistVC ()<UITextFieldDelegate>

{
    int secondsCountDown; //倒计时总时长
    NSTimer *countDownTimer;
    UILabel *lbaer;
}

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengma;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *registClick;
@property (weak, nonatomic) IBOutlet UIButton *sendYanzhengma;


- (IBAction)sendYanzhengma:(UIButton *)sender;
- (IBAction)regitstClick:(UIButton *)sender;


@end

@implementation CDRegistVC
- (IBAction)exit:(id)sender {
	[[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    self.userName.delegate = self;
    self.phoneNum.delegate = self;
    self.yanzhengma.delegate = self;
    self.passWord.delegate = self;
    
    UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(0,0,120,50)];
    laber.text = @"获取验证码";
    laber.textAlignment = NSTextAlignmentCenter;
    laber.textColor = [UIColor whiteColor];
    
    laber.font = [UIFont systemFontOfSize:12];
    lbaer = laber;
    [self.sendYanzhengma addSubview:lbaer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (string) {
        
        if (self.userName.text.length> 1 && self.passWord.text.length >1 && self.yanzhengma.text .length>1 && self.phoneNum.text.length >1) {
            [self.registClick setImage:[UIImage imageNamed:@"btn_register_selected"] forState:UIControlStateNormal];
            self.registClick.userInteractionEnabled = YES;
        }else{
            [self.registClick setImage:[UIImage imageNamed:@"btn_register_disabled"] forState:UIControlStateNormal];
            self.registClick.userInteractionEnabled = NO;
        }

    }else
    {
        if (self.userName.text.length> 0 && self.passWord.text.length >0 && self.yanzhengma.text .length>0 && self.phoneNum.text.length >0) {
            [self.registClick setImage:[UIImage imageNamed:@"btn_register_selected"] forState:UIControlStateNormal];
            self.registClick.userInteractionEnabled = YES;
        }else{
            [self.registClick setImage:[UIImage imageNamed:@"btn_register_disabled"] forState:UIControlStateNormal];
            self.registClick.userInteractionEnabled = NO;
        }
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendYanzhengma:(UIButton *)sender {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
   
    parameters[@"phone"] = self.phoneNum.text;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    CDAcount *account = [CDAcount accountFromSandbox];
//    
//    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
//    [manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@users/checkPhone/%@",baseUrl,self.phoneNum.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
        CDLog(@"%@",responseObject);
        
        if ([responseObject[@"result"]  isEqual: @0]) {
            
            [manager POST:[NSString stringWithFormat:@"%@users/sendCaptcha",baseUrl] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if([responseObject[@"status"] isEqual:@1]){

                    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                    secondsCountDown = 180;
                }else
                {

                    [SVProgressHUD showErrorWithStatus:responseObject[@"messasge"]];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                CDLog(@"%@",error);
            }];
        
        }else
        {

            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CDLog(@"%@",error);
    }];
    

    
    
    
    
}

-(void)timeFireMethod
{

    secondsCountDown--;

    
    lbaer.text = [NSString stringWithFormat:@"%d秒后重新发送",secondsCountDown];
    self.sendYanzhengma.userInteractionEnabled = NO;

    if(secondsCountDown==0){
        [countDownTimer invalidate];
        
        //                self.getCheckNum.titleLabel.text = @"获取验证码";
        lbaer.text = @"获取验证码";
        self.sendYanzhengma.userInteractionEnabled = YES;
    }
}

- (IBAction)regitstClick:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"注册中"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    parameters[@"nickname"] = self.userName.text;
    parameters[@"phone"] = self.phoneNum.text;
    parameters[@"password"] = self.passWord.text;
    parameters[@"smscode"] = self.yanzhengma.text;
    
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    CDAcount *account = [CDAcount accountFromSandbox];
//    
//    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
//    [manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
//    
    [manager GET: [NSString stringWithFormat:@"%@users/checkName/%@",baseUrl,[self.userName.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          CDLog(@"%@",responseObject);
        if ([responseObject[@"result"] isEqual: @0]){

            
            [sender setTitle:@"注册中" forState:UIControlStateNormal];
            sender.userInteractionEnabled = NO;
            
        [manager POST:[NSString stringWithFormat:@"%@phone/register",baseUrl] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                CDLog(@"%@",responseObject);
            [SVProgressHUD dismiss];
            if ([responseObject[@"status"] isEqual:@1]) {

                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                
//                CDNav *nav = [[CDNav alloc]init];
                
//                CDLoginVC *login = [[UIStoryboard storyboardWithName:@"CDLoginVC" bundle:nil]instantiateInitialViewController];

//                [nav addChildViewController:login];
//                
//                [self.navigationController pushViewController:login animated:YES];

				[self.navigationController popViewControllerAnimated:YES];
//                [self presentViewController:nav animated:YES completion:nil];

            }else
            {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                  [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     CDLog(@"%@",responseObject);
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }];
        }else
        {
          
            
        [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];

        }
        
        [sender setTitle:@"注册" forState:UIControlStateNormal];
        sender.userInteractionEnabled = YES;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [sender setTitle:@"注册" forState:UIControlStateNormal];
        sender.userInteractionEnabled = YES;
        CDLog(@"%@",error);
    }];
     
}
@end
