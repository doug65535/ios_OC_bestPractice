//
//  CDLineSytleView.m
  
//
//  Created by lucifer on 16/9/13.
 
//

#import "CDLineSytleView.h"

#import "SMAnnoImageCell.h"

#import "UIImage+RTTint.h"

#import "UIViewController+BackButtonHandler.h"

@interface CDLineSytleView ()<UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

{
    BOOL selectWidthOpen;
    UIButton *layerCover;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *lineShowView;

@property(nonatomic,strong)NSMutableArray *imgArr3;

@property (nonatomic,strong)NSMutableArray *urlArr1;

@property (weak, nonatomic) IBOutlet UIButton *lineWidthBtn;

- (IBAction)lineWidthClick:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *alphaSpider;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation CDLineSytleView


-(NSMutableArray *)imgArr3
{
    if (!_imgArr3) {
        _imgArr3 = [NSMutableArray arrayWithObjects:@"111",@"112",@"113",@"114",@"115",@"116",@"117",@"118", nil];
    }
    return _imgArr3;
}

-(NSMutableArray *)urlArr1
{
    if (!_urlArr1) {
        _urlArr1 = [NSMutableArray arrayWithObjects:@"#00bcce", @"#5b8dd3", @"#71bc4e", @"#505050", @"#b776bb", @"#f63a39", @"#ff793d", @"#ffc84e", nil];
    }
    return _urlArr1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择线样式";
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;

	if (_lineInfo == nil) {
	[self.lineWidthBtn setTitle:@"5" forState:UIControlStateNormal];
		self.alphaSpider.value = 1;


	}else{
		[self.lineWidthBtn setTitle:self.lineInfo.style.weight forState:UIControlStateNormal];
		self.alphaSpider.value = self.lineInfo.style.opacity.floatValue;

	}




    selectWidthOpen = NO;

	UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(saveBackLine)];
	self.navigationItem.rightBarButtonItem = rightBar;
}



-(void)saveBackLine{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }
    
    return 0;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
    SMAnnoImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

        NSString *imageName1 = self.imgArr3[indexPath.item];
        [cell.annoImage setImage:[UIImage imageNamed:imageName1]];
    
        if (indexPath.item == _indexItem1) {
            cell.backgroundColor = [UIColor lightGrayColor];
            UIImage *image = [self.lineShowView.image rt_tintedImageWithColor:[self getColor:self.urlArr1[_indexItem1] alpha:@"1"]  level:1.0f];
            [self.lineShowView setImage:image];
        }else
        {
            cell.backgroundColor = [UIColor clearColor];
        }
    
    return cell;
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


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *colorStr = self.urlArr1[indexPath.item];
        _indexItem1 = indexPath.item;

   UIImage *image = [self.lineShowView.image rt_tintedImageWithColor:[self getColor:colorStr alpha:@"1"]  level:1.0f];
    [self.lineShowView setImage:image];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"resultLineImage"] = image;
    dic[@"lineCorlor"] = colorStr;
    dic[@"colorIndex"] = [NSNumber numberWithInteger:_indexItem1];
    

    [[NSNotificationCenter defaultCenter]postNotificationName:CDLineStyleChange object:nil userInfo:dic];
    
    [collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40 , 40);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (IBAction)lineWidthClick:(id)sender {
    selectWidthOpen = !selectWidthOpen;
    if (selectWidthOpen == YES) {
        
        layerCover = [[UIButton alloc]initWithFrame:self.view.frame];
        layerCover.backgroundColor = [UIColor blackColor];
        layerCover.alpha = 0.7;
        [self.view addSubview:layerCover];
        
        [self.view bringSubviewToFront:self.pickerView];
        
        [layerCover addTarget:self action:@selector(layerCoverClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.pickerView.hidden = NO;
        [self.pickerView reloadAllComponents];
		
		[self.pickerView selectRow:self.lineInfo.style.weight.intValue -1 inComponent:0 animated:NO];
    }else
    {
        self.pickerView.hidden = YES;
    }
}

-(void)layerCoverClick
{
    selectWidthOpen = !selectWidthOpen;
    [layerCover removeFromSuperview];
    self.pickerView.hidden = YES;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 10;
    
}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"%tu",row+1];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.font = [UIFont systemFontOfSize:8];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
   
    [self.lineWidthBtn setTitle:[NSString stringWithFormat:@"%tu",row+1]  forState:UIControlStateNormal];
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    dic[@"lineWidth"] = [NSString stringWithFormat:@"%tu",row+1];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:CDLineStyleChange object:nil userInfo:dic];

	[self layerCoverClick];
}


-(BOOL)navigationShouldPopOnBackButton
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"lineAlpha"] = [NSString stringWithFormat:@"%f",self.alphaSpider.value];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:CDLineStyleChange object:nil userInfo:dic];
    return YES;
}


@end
