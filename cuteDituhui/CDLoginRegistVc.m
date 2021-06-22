//
//  CDLoginRegistVc.m
  
//
//  Created by lucifer on 16/7/21.
 
//

#import "CDLoginRegistVc.h"
#import "SDCycleScrollView.h"
#import "CDLoginVC.h"
#import "CDRegistVC.h"

@interface CDLoginRegistVc ()<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *logon;
- (IBAction)loginClick:(UIButton *)sender;
- (IBAction)logonClick:(UIButton *)sender;

@end

@implementation CDLoginRegistVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[SVProgressHUD dismiss];

    NSArray *imageNames = @[@"image_page",@"image_page02",@"image_page03",@"image_page04"

                            ];
    

  
    self.cycleScrollView.infiniteLoop = YES;
    _cycleScrollView.localizationImageNamesGroup = imageNames;
    
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.view addSubview:_cycleScrollView];
    

    _cycleScrollView.autoScrollTimeInterval = 3.0;
    _cycleScrollView.currentPageDotColor = [UIColor colorWithRed:68/255.0 green:200/255.0 blue:220/255.0 alpha:1];
   
    _cycleScrollView.pageDotColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1];
    

    self.login.adjustsImageWhenHighlighted = NO;
    self.logon.adjustsImageWhenHighlighted = NO;
    
     self.navigationController.delegate = self;
    
    self.title = @"";
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
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

- (IBAction)loginClick:(UIButton *)sender {
    CDLoginVC *loginVC = [[UIStoryboard storyboardWithName:@"CDLoginVC" bundle:nil]instantiateInitialViewController];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)logonClick:(UIButton *)sender {
    CDRegistVC *registVC = [[UIStoryboard storyboardWithName:@"CDRegistVC" bundle:nil]instantiateInitialViewController];
    [self.navigationController pushViewController:registVC animated:YES];
    
}
@end
