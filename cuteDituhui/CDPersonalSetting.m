//
//  CDPersonalSetting.m
  
//
//  Created by lucifer on 2016/10/11.
 
//

#import "CDPersonalSetting.h"

#import "CDChangeName.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZImageManager.h"

#import "RootViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface CDPersonalSetting ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UIView *personAvaterView;
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIView *phoneView;

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIView *emailView;




@end

@implementation CDPersonalSetting

-(void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:YES];
    CDAcount *acount =[CDAcount accountFromSandbox];
    
    self.userName.text = acount.user_name;
    [self.personImageView sd_setImageWithURL:[NSURL URLWithString:acount.avatar]];
    self.email.text = acount.email;
    self.phoneNum.text = acount.phone;
    
    self.userNameView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userNameViewClick)];
    [self.userNameView addGestureRecognizer:tapGes];
    
    
    self.personAvaterView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personImageViewClick)];
    [self.personAvaterView addGestureRecognizer:tapGes3];
}

- (void)viewDidLoad {
    [super viewDidLoad];


	self.title = @"个人信息";
    // Do any additional setup after loading the view.
   
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
//    self.navigationItem.leftBarButtonItem = item;
}

//-(void)close
//{
//    RootViewController *homeVC = [[UIStoryboard storyboardWithName:@"RootViewController" bundle:nil] instantiateInitialViewController];
//    
//    CDNav *nav =[[CDNav alloc]initWithRootViewController:homeVC];
//    
//    [UIApplication sharedApplication].keyWindow.rootViewController= nav;
//    
//}
-(void)personImageViewClick
{


        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

			[SVProgressHUD showWithStatus:@"正在上传头像……"];

            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            CDAcount *account = [CDAcount accountFromSandbox];
            
            [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
            [manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"user_id"] = account.user_id;
            dic[@"file"] = photos[0];
            
            [manager POST:[NSString stringWithFormat:@"%@user/avatar",baseUrl] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

            NSData *iamgeData = UIImageJPEGRepresentation(photos[0], 0.5);
                    
            [formData appendPartWithFileData:iamgeData name:@"file" fileName:@"a.jpg" mimeType:@"image/jpeg"];
            
            } progress:nil
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject[@"status"]isEqual:@1]){
                    NSString *str = responseObject[@"result"];
                    account.avatar = str;
                    [account save];
                     [self.personImageView sd_setImageWithURL:[NSURL URLWithString:account.avatar]];

					[[NSNotificationCenter defaultCenter]postNotificationName:CDDidChangeName object:nil];

					[SVProgressHUD dismiss];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                CDLog(@"%@",error);
                [SVProgressHUD showErrorWithStatus:@"网络错误"];
            }];
            
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

-(void)userNameViewClick
{
    CDChangeName *changenameVc = [[UIStoryboard storyboardWithName:@"CDChangeName" bundle:nil]instantiateInitialViewController];
    [self.navigationController pushViewController:changenameVc animated:YES];
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
