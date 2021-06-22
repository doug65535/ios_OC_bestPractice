//
//  CDRestPassWord.m
  
//
//  Created by lucifer on 16/10/8.
 
//

#import "CDRestPassWord.h"

@interface CDRestPassWord ()<UITextFieldDelegate>

{
    int secondsCountDown; //倒计时总时长
    NSTimer *countDownTimer;
    UILabel *lbaer;
}
@property (weak, nonatomic) IBOutlet UIButton *resetPWD;
- (IBAction)resetPWD:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengma;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *sendYanzhengma;


- (IBAction)sendYanzhengma:(UIButton *)sender;

@end

@implementation CDRestPassWord

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (string) {
        
        if (self.passWord.text.length >1 && self.yanzhengma.text .length>1 && self.phoneNum.text.length >1) {
            [self.resetPWD setBackgroundColor:baseColor];
            
            self.resetPWD.userInteractionEnabled = YES;
        }else{
            [self.resetPWD setBackgroundColor:[UIColor lightGrayColor]];
            self.resetPWD.userInteractionEnabled = NO;
        }
        
    }else
    {
        if (self.passWord.text.length >0 && self.yanzhengma.text .length>0 && self.phoneNum.text.length >0) {
            [self.resetPWD setBackgroundColor:baseColor];
            self.resetPWD.userInteractionEnabled = YES;
        }else{
            [self.resetPWD setBackgroundColor:[UIColor lightGrayColor]];
            self.resetPWD.userInteractionEnabled = NO;
        }
    }
    
    return YES;
}



-(void)sendYanzhengma:(UIButton *)sender
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    
    parameters[@"phone"] = self.phoneNum.text;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

            
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

- (IBAction)resetPWD:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"smscode"] = self.yanzhengma.text;
    dic[@"phone"] = self.phoneNum.text;
    dic[@"password"] = self.passWord.text;
    
    [manager POST:[NSString stringWithFormat:@"%@phone/users/resetPassword",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CDLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqual:@1]) {
        [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
			[self.navigationController popViewControllerAnimated:YES];
        }else
        {
        [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CDLog(@"%@",error);
    }];
    
    
    
}
@end
