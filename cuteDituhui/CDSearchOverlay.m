//
//  CDSearchOverlay.m
  
//
//  Created by lucifer on 16/8/30.
 
//

#import "CDSearchOverlay.h"

#import "CDMakerResultViewController.h"

#import "ALView+PureLayout.h"

@interface CDSearchOverlay ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cover;


- (IBAction)resign:(UIButton *)sender;


@property (nonatomic, weak)CDMakerResultViewController  *makerResultVc;

@end

@implementation CDSearchOverlay



- (IBAction)resign:(UIButton *)sender {
	self.cover.hidden = YES;

	[self.searchBar resignFirstResponder];

	_searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];

	[_searchBar setShowsCancelButton:NO animated:YES];



	_searchBar.text = nil;

	_makerResultVc.view.hidden = YES;
}

- (CDMakerResultViewController *)makerResultVc
{
    if (!_makerResultVc) {
        CDMakerResultViewController *makerResultVc = [[CDMakerResultViewController alloc] init];
        
//        makerResultVc.mapmodel = self.mapModel;
        
        [self addChildViewController:makerResultVc];
        [self.view addSubview:makerResultVc.view];
        
        [makerResultVc.layerArr addObjectsFromArray:self.layersArr];
        
        [makerResultVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        [makerResultVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView];
        
        self.makerResultVc = makerResultVc;
        
    }
    return _makerResultVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"搜索标注点";
    

    self.tableView.sectionIndexColor = [UIColor blackColor];
    

	[self resign];
}

-(void)resign
{

	self.cover.hidden = YES;

    [self.searchBar resignFirstResponder];

    _searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];

    [_searchBar setShowsCancelButton:NO animated:YES];


    _searchBar.text = nil;

    _makerResultVc.view.hidden = YES;
}

#pragma mark - <UISearchBarDelegate>
/**

 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

  
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];

    self.cover.hidden = NO;
}
/**

 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];

    [searchBar setShowsCancelButton:NO animated:YES];

}
/**

 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];

    self.cover.hidden = YES;

    searchBar.text = nil;

    self.makerResultVc.view.hidden = YES;
}


/**
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.makerResultVc.view.hidden = (searchText.length == 0);
    self.makerResultVc.searchText = searchText;
}


#pragma mark - Table view data source


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.layersArr.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    CDLayerInfo *layer = self.layersArr[section];
    
      return layer.layer_name;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    CDLayerInfo *layer = self.layersArr[section];
  
    return layer.datas.count;
    
}

-(UIColor *)getColor:(NSString *)hexColor alpha:(NSString *)alpha{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha.floatValue];
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
      cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    CDLayerInfo *layer = self.layersArr[indexPath.section];
    
        if ([layer.layer_type isEqual:@"0"]) {
            NSArray *markerInfoArr = [CDMarkerInfo mj_objectArrayWithKeyValuesArray:layer.datas];
            
            CDMarkerInfo *markerInfo = markerInfoArr[indexPath.row];
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:markerInfo.style.icon_url] placeholderImage:[UIImage imageNamed:@"btn_coordinate_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
            
            cell.textLabel.text = markerInfo.title;
        }else
        
        if ([layer.layer_type isEqual:@"1"]) {
            
            NSArray *lineInfoArr = [CDLineInfo mj_objectArrayWithKeyValuesArray:layer.datas];
            CDLineInfo *lineInfo = lineInfoArr[indexPath.row];
            
            UIImage *image = [UIImage imageNamed:@"icon_line"];
            UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:lineInfo.style.color alpha:@"1"]  level:1.0f];
            
            
            
            [cell.imageView setImage:tinted];
            
            cell.textLabel.text = lineInfo.title;
        }else
        
        if ([layer.layer_type isEqual:@"2"]) {
            
            NSArray *zoneInfoArr = [CDZoneInfo mj_objectArrayWithKeyValuesArray:layer.datas];
            CDZoneInfo *zoneInfo = zoneInfoArr[indexPath.row];
            
            UIImage *image = [UIImage imageNamed:@"icon_face"];
            UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:zoneInfo.style.fill_color alpha:zoneInfo.style.fill_opacity]  level:1.0f];

            [cell.imageView setImage:tinted];
            
            cell.textLabel.text = zoneInfo.title;
        }
    
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    view.tintColor = [UIColor clearColor];
//    
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        CDLayerInfo *layer = self.layersArr[indexPath.section];
        if ([layer.layer_type isEqual:@"0"]) {
            
            
               NSArray *markerInfoArr = [CDMarkerInfo mj_objectArrayWithKeyValuesArray:layer.datas];
            
            CDMarkerInfo *markerInfo = markerInfoArr[indexPath.row];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:markerInfo.marker_id forKey:@"resultMarkerModel"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SMsectetResultSeachNotification object:nil userInfo:dic];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        if ([layer.layer_type isEqual:@"1"]) {
            
              NSArray *lineInfoArr = [CDLineInfo mj_objectArrayWithKeyValuesArray:layer.datas];
            
            CDLineInfo *lineInfo = lineInfoArr[indexPath.row];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:lineInfo.line_id forKey:@"resultLineModel"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SMsectetResultSeachNotification object:nil userInfo:dic];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        if ([layer.layer_type isEqual:@"2"]) {
            
              NSArray *zoneInfoArr = [CDZoneInfo mj_objectArrayWithKeyValuesArray:layer.datas];
            
            CDZoneInfo *zoneInfo = zoneInfoArr[indexPath.row];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:zoneInfo.zone_id forKey:@"resultZoneModel"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SMsectetResultSeachNotification object:nil userInfo:dic];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
