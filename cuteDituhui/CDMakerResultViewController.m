//
//  CDMakerResultViewController.m
  
//
//  Created by lucifer on 16/8/30.
 
//

#import "CDMakerResultViewController.h"

@interface CDMakerResultViewController ()<BMKPoiSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,strong)NSMutableArray *resultLayers;

@end

@implementation CDMakerResultViewController

-(NSMutableArray *)layerArr
{
    if (!_layerArr) {
        _layerArr = [[NSMutableArray alloc]init];
    }
    return _layerArr;
}
-(NSMutableArray *)resultLayers
{
    if (!_resultLayers) {
        _resultLayers = [[NSMutableArray alloc]init];
    }
    return _resultLayers;
}

-(NSMutableArray *)poimodel
{
    if (!_poimodel) {
        _poimodel = [[NSMutableArray alloc]init];
        
    }return _poimodel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

}
- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    _poisearch.delegate = nil; // 
}
- (void)setSearchText:(NSString *)searchText
{
    
    if (searchText.length == 0) return;
     _searchText = [searchText copy];
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    //    citySearchOption.pageIndex = curPage;
    citySearchOption.pageCapacity = 10;
    
    citySearchOption.city= @"";
    citySearchOption.keyword = self.searchText;
    
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        CDLog(@"城市内检索发送成功");
    }
    else
    {
        CDLog(@"城市内检索发送失败");
    }
    
    [self.resultLayers removeAllObjects];

    for (CDLayerInfo *layer in self.layerArr) {
        
        if ([layer.layer_type isEqualToString:@"0"]) {
     
            NSArray *markerArr = [CDMarkerInfo mj_objectArrayWithKeyValuesArray:layer.datas];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains %@", searchText];

            CDLayerInfo *clayer = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:layer]];

            clayer.datas =[markerArr filteredArrayUsingPredicate:predicate];
            [self.resultLayers addObject:clayer];


        }
        
        if ([layer.layer_type isEqualToString:@"1"]) {
            
            NSArray *lineArr = [CDLineInfo mj_objectArrayWithKeyValuesArray:layer.datas];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains %@ ", searchText];

           CDLayerInfo *clayer = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:layer]];
            
            clayer.datas =[lineArr filteredArrayUsingPredicate:predicate];
            [self.resultLayers addObject:clayer];
        }
        
        if ([layer.layer_type isEqualToString:@"2"]) {
            
            NSArray *zoneArr = [CDZoneInfo mj_objectArrayWithKeyValuesArray:layer.datas];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains %@", searchText];
            
         CDLayerInfo *clayer = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:layer]];
            
            clayer.datas =[zoneArr filteredArrayUsingPredicate:predicate];
            [self.resultLayers addObject:clayer];
        }
        
    }
    

    [self.poimodel removeAllObjects];


    [self.tableView reloadData];

}


- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            
            [self.poimodel addObject:poi];
        
            [self.tableView reloadData];
            //            [SVProgressHUD dismiss];
            
        }
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        CDLog(@"起始点有歧义");
    } else {
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.layerArr.count +1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.poimodel.count == 0) {
            return @"未检索到POI结果";
        }else return @"地图搜索结果";
    }else
    {
        CDLayerInfo *layer = self.layerArr[section-1];
        
        return layer.layer_name;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.poimodel.count;
    }else
    {

        CDLayerInfo *layer = self.layerArr[section -1];
        if ([layer.layer_type isEqual:@"0"]) {
      
             
             
CDLayerInfo *resultmarkerlayer = self. resultLayers[section -1];

            return resultmarkerlayer.datas.count;
         
    }
        
        if ([layer.layer_type isEqual:@"1"]) {
           
            
           CDLayerInfo *resultlinelayer = self. resultLayers[section -1];
            
            return resultlinelayer.datas.count;
            
        }
        
        if ([layer.layer_type isEqual:@"2"]) {
            
           
                 CDLayerInfo *layer = self. resultLayers[section -1];
                
                return layer.datas.count;
          
        }
        return 0;
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"poiResult";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (indexPath.section == 0) {
        if (self.poimodel) {
            BMKPoiInfo *poi = self.poimodel[indexPath.row];
            cell.textLabel.text = poi.name;
            cell.detailTextLabel.text = poi.address;
        }
          
    }else
    {
    CDLayerInfo *layer = self. resultLayers[indexPath.section-1];
        if ([layer.layer_type isEqual:@"0"]) {
            CDMarkerInfo *markerInfo = layer.datas[indexPath.row];
            
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:markerInfo.style.icon_url] placeholderImage:[UIImage imageNamed:@"btn_coordinate_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
            
            cell.textLabel.text = markerInfo.title;
            return cell;
            
        }

        if ([layer.layer_type isEqual:@"1"]) {
            
            CDLineInfo *lineInfo = layer.datas[indexPath.row];
            
            UIImage *image = [UIImage imageNamed:@"icon_line"];
            UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:lineInfo.style.color alpha:@"1"]  level:1.0f];
            
                [cell.imageView setImage:tinted];
            
                cell.textLabel.text = lineInfo.title;
        }
        
        if ([layer.layer_type isEqual:@"2"]) {
        
            CDZoneInfo *zoneInfo = layer.datas[indexPath.row];
        
            UIImage *image = [UIImage imageNamed:@"icon_face"];
            UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:zoneInfo.style.fill_color alpha:zoneInfo.style.fill_opacity]  level:1.0f];
            
            [cell.imageView setImage:tinted];
            
            cell.textLabel.text = zoneInfo.title;
        }
        
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (self.poimodel.count) {
            
            BMKPoiInfo* poi = self.poimodel[indexPath.row];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:poi forKey:@"poiModel"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetPOIseachNotification object:nil userInfo:dic];
            [self.navigationController popToRootViewControllerAnimated:YES];
       
        }
    }else{
            
            CDLayerInfo *layer = self. resultLayers[indexPath.section-1];
            if ([layer.layer_type isEqual:@"0"]) {
                
                CDMarkerInfo *markerInfo = layer.datas[indexPath.row];
                NSDictionary *dic = [NSDictionary dictionaryWithObject:markerInfo.marker_id forKey:@"resultMarkerModel"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SMsectetResultSeachNotification object:nil userInfo:dic];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            if ([layer.layer_type isEqual:@"1"]) {
          
                CDLineInfo *lineInfo = layer.datas[indexPath.row];
                NSDictionary *dic = [NSDictionary dictionaryWithObject:lineInfo.line_id forKey:@"resultLineModel"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SMsectetResultSeachNotification object:nil userInfo:dic];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            if ([layer.layer_type isEqual:@"2"]) {
              
                CDZoneInfo *zoneInfo = layer.datas[indexPath.row];
                NSDictionary *dic = [NSDictionary dictionaryWithObject:zoneInfo.zone_id forKey:@"resultZoneModel"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SMsectetResultSeachNotification object:nil userInfo:dic];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }

 
        }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
