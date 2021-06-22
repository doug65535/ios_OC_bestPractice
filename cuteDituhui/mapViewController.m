	//
	//  mapViewController.m
	  
	//
	//  Created by lucifer on 16/8/3.
	 
	//
//#import "BMKClusterManager.h"
#import "mapViewController.h"
#import "extendShowTableViewCell.h"
#import "mapDetailViewController.h"


#import "CDJpushOrigin.h"
#import "CDJpushModel.h"

#import "line_geometry.h"

#import "CDMapPartenerTableViewController.h"

#import "CDAnno.h"

#import "CDOverLayInfoView.h"

#import <AVFoundation/AVFoundation.h>
#import "SMAnnoImageViewController.h"


#import "CDImageShowVC.h"

#import "CDSearchOverlay.h"
#import "CDMakerResultViewController.h"

#import "MapDiffLayerCell.h"
#import "mapDIffLayerView.h"

#import "CDLineSytleView.h"

#import "CDZoneStyleView.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "CDImagesUrls.h"

#import "extendEditTableViewCell.h"


//#import "PoiDetailViewController.h"
#import "CoordinateQuadTree.h"
#import "ClusterAnnotation.h"
#import "ClusterAnnotationView.h"
#import "ClusterTableViewCell.h"
#import "CustomCalloutView.h"


#import "JPUSHService.h"

#define kCalloutViewMargin -12

@interface mapViewController ()<UITextViewDelegate,
TZImagePickerControllerDelegate,BMKMapViewDelegate,
BMKLocationServiceDelegate,UITextFieldDelegate,
UIPickerViewDelegate,UIPickerViewDataSource,
SMAnnoImageViewControllerDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CustomCalloutViewTapDelegate>
{

	NSURLSessionDataTask *req;

	UITextField *selectTextFiled;
	BMKLocationService* _locService;
	CGFloat pointy;
	CGFloat editPointY;

	NSMutableArray *layersArr;

		//    NSMutableArray *markerDataArr;

	NSMutableArray *AnnoOverlayArr;
	NSMutableArray *AnnoOverLayArr_tem;

	NSMutableArray *lineOverlayArr;
	NSMutableArray *circleOverlayArr;
	NSMutableArray *polygonOverlayArr;

	NSMutableArray *zoneDataArr;
	NSMutableArray *lineDataArr;


	NSMutableArray *measureAnnoArr;
	NSMutableArray *measureLineArr;

	NSMutableArray *makeLineAnnoArr;
	NSMutableArray *makeZoneAnnoArr;

	NSMutableArray *makeLineArr;



	NSMutableArray *makeZoneArr;

	CDAnno *mesureAnno;

	CDAnno *lineMakeAnno;


	CGFloat overlayDelay ;
	CGFloat overlayHeight;
	CGFloat overlayEditHeight;


	BOOL isEditting;
	BOOL isAddAnno;

	BOOL selectLayerBtnOpen;

	BOOL isMapDiffOpne;
	UIButton *mapDiffButton;

	BOOL isSelectSateliteMap;

	CDLayerInfo *selectedAddLyaerInfo;
	CDLayerInfo *selectedInfoLyaerInfo;

	NSMutableArray *markerLayers;
	NSMutableArray *lineLayers;
	NSMutableArray *zoneLayers;

	CDAnno *selectedAnno;
	CDLineInfo *selectedLineInfo;
	CDZoneInfo *selectedZoneInfo;

	NSInteger indexPath1;
	NSInteger indexPath2;
	NSInteger indexPath3;
	NSInteger selectiindex;

	BMKPoiInfo *poi;

	NSMutableArray *_selectedPhotos;

	BOOL _isSelectOriginalPhoto;


	NSMutableArray *imagespost;


	UIButton *layerCover;


	BOOL isClickNav;


	CDAnno *editRemoveAnno;

	BOOL isMoreOpen;

	NSMutableDictionary *extendAttr;

	BOOL isMeasureOpen;
	BOOL isMakeLine;
	BOOL isMakeZone;
	CLLocationDistance totolDistance;
	CLLocationDistance lineTotolDistance;

	NSMutableArray *lineDisTanceArr;

}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


@property (nonatomic, strong) CustomCalloutView *customCalloutView;

@property (weak, nonatomic) IBOutlet UIImageView *styleShowImageView;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *mapInfoView;
@property (weak, nonatomic) IBOutlet UILabel *mapTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overlayInfoHeight;

@property (weak, nonatomic) IBOutlet CDOverLayInfoView *overlayInfoView;
@property (weak, nonatomic) IBOutlet UITableView *extendShowTB;
@property (weak, nonatomic) IBOutlet UITableView *extendEditTB;
- (IBAction)reloadMapClick:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapInfoViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overlayInfoViewBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overlayEditViewBottom;
@property (weak, nonatomic) IBOutlet UIView *moreView;

@property (weak, nonatomic) IBOutlet UIButton *overlayPic;

@property (weak, nonatomic) IBOutlet UILabel *overlayTitle;
@property (weak, nonatomic) IBOutlet UIButton *overlayNav;

- (IBAction)overlayNavClick:(UIButton *)sender;
- (IBAction)copyMapLink:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overlayTitlePosition;
@property (weak, nonatomic) IBOutlet UIButton *overlayPicCount;

	//@property (weak, nonatomic) IBOutlet UITextView *overlayDes;

@property (weak, nonatomic) IBOutlet UILabel *overlayDes;

@property (weak, nonatomic) IBOutlet UIImageView *icon_up_image;
- (IBAction)map_locate:(UIButton *)sender;

- (IBAction)map_fangda:(UIButton *)sender;
- (IBAction)map_suoxiao:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *locateBtn;
@property (weak, nonatomic) IBOutlet UIButton *fangdaBtn;
@property (weak, nonatomic) IBOutlet UIButton *suoxiaoBtn;

@property (weak, nonatomic) IBOutlet UIView *overlayEditView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overlayEditViewHeight;
- (IBAction)overlayInfoEditClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *addAnnoBtn;
- (IBAction)addAnnoClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overlayEditTop;

@property (weak, nonatomic) IBOutlet UIImageView *edit_icon_up_image;

@property (weak, nonatomic) IBOutlet  UIButton*overlaySave;
- (IBAction)overlaySaveClick:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UITextField *overlayEditTitle;
@property (weak, nonatomic) IBOutlet UIButton *changeAnnoStyle;

- (IBAction)changeAnnoStyle:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *upLoadPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadCount;

- (IBAction)upLoadPic:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *overlayEditDes;
- (IBAction)deleteAnno:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *edti_tool_bar;
@property (weak, nonatomic) IBOutlet UIButton *addAnnoCenter;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addAnnoCenterY;

@property (weak, nonatomic) IBOutlet UIButton *selectLayerBtn;
- (IBAction)selectLayerClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *layerSelectView;
@property (weak, nonatomic) IBOutlet UIButton *deleteAnnoBtn;


@property(nonatomic,copy)NSString *finalStr;

@property(nonatomic,strong) CDAnno *lineAnno;

@property(nonatomic,strong) CDAnno *zoneAnno;

@property (weak, nonatomic) IBOutlet UIView *mapDiffView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapDiffViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *normalDiffButton;
- (IBAction)normalDiffClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *sateliteDiffButton;
- (IBAction)sateliteDiffClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *layerShowTableView;

@property(nonatomic,copy)NSString *lineChangeCorlor;
@property(nonatomic,copy)NSString *lineWidth;
@property(nonatomic,copy)NSString *lineAlpha;
@property(nonatomic,assign)NSInteger lineIndex1;

@property(nonatomic,copy)NSString *zoneChangeCorlor;
@property(nonatomic,copy)NSString *zoneWidth;
@property(nonatomic,copy)NSString *zoneAlpha;
@property(nonatomic,assign)NSInteger zoneIndex1;
@property(nonatomic,assign)NSInteger zoneIndex2;
@property(nonatomic,copy)NSString *zoneLineAlpha;
@property(nonatomic,copy)NSString *zoneLineCorlor;


- (IBAction)overlayPicClick:(id)sender;

- (IBAction)saveMapStatus:(id)sender;


@property (nonatomic, strong) CoordinateQuadTree* coordinateQuadTree;

//@property (nonatomic, strong) CustomCalloutView *customCalloutView;


- (IBAction)meaSureDistance:(UIButton *)sender;

@property (nonatomic, strong) NSMutableArray *selectedPoiArray;

@property (nonatomic, assign) BOOL shouldRegionChangeReCalculate;

//@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *currentRequest;

@property (weak, nonatomic) IBOutlet UIView *topMeasureView;

@property (weak, nonatomic) IBOutlet UILabel *measureLabel;

- (IBAction)clearMeasureResult:(UIButton *)sender;

- (IBAction)closeMeasureView:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIButton *makeLineBtn;

- (IBAction)makeLineClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *makeZone;

- (IBAction)makeZoneClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *addLinePoint;

- (IBAction)addLinePoint:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *addZonePoint;

- (IBAction)addZonePoint:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *closeMakeBtn;
- (IBAction)closeMakeClick:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *returnMakeBtn;

- (IBAction)returnMakeClick:(id)sender;

@end

@implementation mapViewController

/* 更新annotation. */
- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations
{

	NSMutableSet *before = [NSMutableSet setWithArray:self.mapView.annotations];

	if (self.lineAnno) {
		[before removeObject:self.lineAnno];
	}

	if (self.zoneAnno) {
		[before removeObject:self.zoneAnno];
	}


//	[before removeObject:[self.mapView userLocation]];

	NSSet *after = [NSSet setWithArray:annotations];

	NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
	[toKeep intersectSet:after];


	NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
	[toAdd minusSet:toKeep];


	NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
	[toRemove minusSet:after];


	dispatch_async(dispatch_get_main_queue(), ^{
		[self.mapView addAnnotations:[toAdd allObjects]];
		[self.mapView removeAnnotations:[toRemove allObjects]];
	});
}

- (void)addAnnotationsToMapView:(BMKMapView *)mapView
{
	@synchronized(self)
	{
	if (self.coordinateQuadTree.root == nil || !self.shouldRegionChangeReCalculate)
		{
		NSLog(@"tree is not ready.");
		return;
		}

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

		double zoomScale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;

		NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:mapView.visibleMapRect
																			withZoomScale:zoomScale
																			 andZoomLevel: mapView.zoomLevel];

		[self updateMapViewAnnotationsWithAnnotations:annotations];
	});
	}
}
#pragma mark - CustomCalloutViewTapDelegate
- (void)didDetailButtonTapped:(NSInteger)index
{

	if (_shouldRegionChangeReCalculate) {

		CDAnno *anno = self.selectedPoiArray[index];


		CLLocationCoordinate2D coord = {0};

		coord.longitude = [anno.markerInfo.bd_x floatValue];
		coord.latitude= [anno.markerInfo.bd_y floatValue];

		[self.mapView setMapCenterToScreenPt:CGPointMake(kWidth/2, kHeight/2)];

		[_mapView setCenterCoordinate:coord];

		[self.mapView selectAnnotation:anno animated:YES];
		if (_shouldRegionChangeReCalculate) {
			self.mapView.zoomLevel = self.mapView.zoomLevel + 1;

			self.mapView.centerCoordinate = coord;
			self.mapView.zoomLevel = 21.0f;
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self.mapView selectAnnotation:anno animated:YES];
			});
		}

		_overlayTitle.text = anno.markerInfo.title;

		selectedAnno = anno;
		selectedLineInfo = nil;
		selectedZoneInfo = nil;

		[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
		self.addAnnoCenter.hidden = YES;
		isEditting = NO;
		isAddAnno = NO;

		self.overlayNav.hidden = NO;
		self.edti_tool_bar.hidden = NO;

		[self.extendShowTB reloadData];

		[self imagesSetNil:selectedAnno.markerInfo.images];

		if (anno.markerInfo.markerDescription) {
			self.overlayDes.text = anno.markerInfo.markerDescription;
		}else
			{
			self.overlayDes.text = @"无";
			}

		[self imageShowDisplay:nil line:nil marker:anno];
		[self overlayUp];

	}

}

-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{

	if (_shouldRegionChangeReCalculate) {
		[self.selectedPoiArray removeAllObjects];
		[self.customCalloutView dismissCalloutView];
		self.customCalloutView.delegate = nil;
	}

}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{

	if (isMeasureOpen) {
		return;
	}

	if (isMakeLine || isMakeZone) {
		return;
	}
	
	if ([view isKindOfClass:[ClusterAnnotationView class]]) {

		ClusterAnnotation *annotation = (ClusterAnnotation *)view.annotation;
		
		[self.mapView setCenterCoordinate:annotation.coordinate];
		float level =  self.mapView.zoomLevel;
		if ( level <21.0f) {
			self.mapView.zoomLevel = self.mapView.zoomLevel + 1.0;

		}else{

						ClusterAnnotation *annotation = (ClusterAnnotation *)view.annotation;
						for (CDAnno *anno in annotation.pois)
						{
							[self.selectedPoiArray addObject:anno];
						}

						[self.customCalloutView setPoiArray:self.selectedPoiArray];
						self.customCalloutView.delegate = self;
				
							// 调整位置
						self.customCalloutView.center = CGPointMake(CGRectGetMidX(view.bounds), -CGRectGetMidY(self.customCalloutView.bounds) - CGRectGetMidY(view.bounds) - kCalloutViewMargin);
				
				
						[view addSubview:self.customCalloutView];

		}
		return;

	}else
	{



	if (self.lineAnno) {

		return;
	}

	if (self.zoneAnno) {
		return;
	}

	selectedLineInfo = nil;
	selectedZoneInfo = nil;


	[self.changeAnnoStyle setTitle:@"点样式" forState:UIControlStateNormal];

	[self.mapView setMapCenterToScreenPt:CGPointMake(kWidth/2, kHeight/2)];

	[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
	self.addAnnoCenter.hidden = YES;
	isEditting = NO;
	isAddAnno = NO;

	self.overlayNav.hidden = NO;
	self.edti_tool_bar.hidden = NO;



	CDAnno *anno = (CDAnno *)view.annotation;

	[self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(anno.markerInfo.bd_y.doubleValue, anno.markerInfo.bd_x.doubleValue) animated:YES];

	selectedAnno = anno;

	for (CDLayerInfo *layerInfo in layersArr) {
		if ([selectedAnno.markerInfo.data_id isEqual:layerInfo.data_id]) {

			selectedInfoLyaerInfo = layerInfo;

		}
	}


	[self.extendShowTB reloadData];


	[self imagesSetNil:selectedAnno.markerInfo.images];

	self.overlayTitle.text = anno.markerInfo.title;

	if (anno.markerInfo.markerDescription) {
		self.overlayDes.text = anno.markerInfo.markerDescription;
	}else
		{
		self.overlayDes.text = @"无";
		}

	[self imageShowDisplay:nil line:nil marker:anno];
	[self overlayUp];

	}

}

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{


	if (_shouldRegionChangeReCalculate) {
		[self addAnnotationsToMapView:self.mapView];
	}
}


-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
		if ([annotation isKindOfClass:[ClusterAnnotation class]])
			{
			/* dequeue重用annotationView. */
			static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseID";

			ClusterAnnotationView *annotationView = (ClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];

			if (!annotationView)
				{
				annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation
																   reuseIdentifier:AnnotatioViewReuseID];
				}


			annotationView.annotation = annotation;
			annotationView.count = [(ClusterAnnotation *)annotation count];

			annotationView.canShowCallout = NO;

			return annotationView;
			}else
		{

		BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"AnimatedAnnotation"];

		if (annotationView == nil) {
			annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnimatedAnnotation"];
		}


		if (annotation == self.lineAnno) {
			annotationView.image = nil;
			return annotationView;
		}

		if (annotation == self.zoneAnno) {
			annotationView.image = nil;
			return annotationView;
		}


		if (isMakeLine || isMakeZone ||isMeasureOpen) {
			[annotationView setImage:[UIImage imageNamed:@"bai"]];
		}else{

		UIImageView *imageView = [[UIImageView alloc]init];

		CDAnno *anno = (CDAnno *)annotation;
		[imageView sd_setImageWithURL:[NSURL URLWithString:anno.markerInfo.style.icon_url] placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

			CGSize size;

			if ([anno.markerInfo.style.icon_type isEqual:@"1"]) {
     size = CGSizeMake(anno.markerInfo.style.size_width.floatValue *1.8, anno.markerInfo.style.size_height.floatValue*1.8 );
			}else
				{
  size = CGSizeMake(image.size.width *1.8, image.size.height *1.8);
				}

			UIGraphicsBeginImageContext(size);
			[imageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];

			UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

			UIGraphicsEndImageContext();

			[annotationView setImage:scaledImage];

			CGPoint p = CGPointMake(0,-image.size.height/5);

			[annotationView setCenterOffset:p];

			for (CDLayerInfo *layerInfo in markerLayers) {
				if([anno.markerInfo.data_id isEqual:layerInfo.data_id]){
					if ([layerInfo.spreadmap_style.is_labelshow isEqual:@"1"]) {

					if ([layerInfo.spreadmap_style.title_key isEqual:@"title"]) {
							UILabel *laber = [[UILabel alloc]init];
							CGFloat contentHeight = 12;
							CGSize size = [anno.markerInfo.title boundingRectWithSize:CGSizeMake(MAXFLOAT, contentHeight) options:
								NSStringDrawingUsesLineFragmentOrigin
																		attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;

							laber.frame =CGRectMake(annotationView.width, annotationView.height/4, size.width , 12);
							laber.font = [UIFont systemFontOfSize:12.0f];

							laber.text = anno.markerInfo.title;
							laber.backgroundColor = [self stringTOColor:layerInfo.spreadmap_style.fill_color alpha:@"1"];

							laber.layer.borderColor = [self stringTOColor:layerInfo.spreadmap_style.border_color alpha:@"1"].CGColor;
							laber.layer.borderWidth = 1;
							[annotationView addSubview:laber];
						}else
							if ( [anno.markerInfo.extend_data.allKeys containsObject:layerInfo.spreadmap_style.title_key]) {
								UILabel *laber = [[UILabel alloc]init];
								NSString *str = anno.markerInfo.extend_data[layerInfo.spreadmap_style.title_key];

								CGFloat contentHeight = 12;

								CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, contentHeight) options:
											   NSStringDrawingUsesLineFragmentOrigin
															 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
								laber.frame =CGRectMake(annotationView.width, annotationView.height/4, size.width , 12);

								laber.backgroundColor = [self stringTOColor:layerInfo.spreadmap_style.fill_color alpha:@"1"];

								laber.layer.borderColor = [self stringTOColor:layerInfo.spreadmap_style.border_color alpha:@"1"].CGColor;
								laber.layer.borderWidth = 1;
								laber.font = [UIFont systemFontOfSize:12.0f];
								laber.text = str;
								[annotationView addSubview:laber];
							}else
								if ([layerInfo.spreadmap_style.title_key isEqual:@"description"]) {
									UILabel *laber = [[UILabel alloc]init];
									CGFloat contentHeight = 12;

									CGSize size = [anno.markerInfo.markerDescription boundingRectWithSize:CGSizeMake(MAXFLOAT, contentHeight) options:
												   NSStringDrawingUsesLineFragmentOrigin
																							   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
									laber.frame =CGRectMake(annotationView.width, annotationView.height/4, size.width , 12);

									laber.backgroundColor = [self stringTOColor:layerInfo.spreadmap_style.fill_color alpha:@"1"];

									laber.layer.borderColor = [self stringTOColor:layerInfo.spreadmap_style.border_color alpha:@"1"].CGColor;

									laber.layer.borderWidth =1;
									laber.font = [UIFont systemFontOfSize:12.0f];
									laber.text = anno.markerInfo.markerDescription;
									[annotationView addSubview:laber];
								}else{
									if ([layerInfo.spreadmap_style.title_key isEqual:@""]) {
										layerInfo.spreadmap_style.is_labelshow  = @"0";
										for (UILabel *laber in annotationView.subviews) {
											[laber removeFromSuperview];
										}
									}
								}
					}
				}
			}
		}
	];
		}
		
		return annotationView;

		}

}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
	NSDictionary * userInfo = [notification userInfo];
	NSString *content = [userInfo valueForKey:@"content"];

	CDJpushModel *model = [CDJpushModel mj_objectWithKeyValues:content];

	CDAcount *account = [CDAcount accountFromSandbox];
	if ([model.origin.user_id isEqual:account.user_id] && [model.origin.device isEqual:@"phone_ios"]) {

	}else{
		if ([model.action isEqualToString:@"com.dituhui.cute.action.marker_add"]){
			CDMarkerInfo *markerInfo = [CDMarkerInfo mj_objectWithKeyValues:model.result];

			CDAnno* annotation = [[CDAnno alloc]init];
			CLLocationCoordinate2D coor;
			coor.latitude = markerInfo.bd_y.floatValue;
			coor.longitude = markerInfo.bd_x.floatValue;
			annotation.coordinate = coor;
			annotation.title = markerInfo.title;
			annotation.markerInfo = markerInfo;

			[AnnoOverlayArr addObject:annotation];
			[self.mapView addAnnotation:annotation];


		}


		if ([model.action isEqualToString:@"com.dituhui.cute.action.line_add"]) {
			CDLineInfo *newInfo = [CDLineInfo mj_objectWithKeyValues:model.result];


			CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * newInfo.line_geometry.apex.count);

			for (int i=0; i<newInfo.line_geometry.apex.count; i++) {
				CDPoint *point = newInfo.line_geometry.apex[i];
				coords[i].longitude = [point.lng floatValue];
				coords[i].latitude= [point.lat floatValue];
			}

			BMKPolyline *pline = [BMKPolyline polylineWithCoordinates:coords count:newInfo.line_geometry.apex.count];


			pline.subtitle = newInfo.line_id;

			[lineOverlayArr addObject:pline];
			[lineDataArr addObject:newInfo];

			[_mapView addOverlay:pline];

		}

		if ([model.action isEqualToString:@"com.dituhui.cute.action.zone_add"]) {
			CDZoneInfo *newInfo = [CDZoneInfo mj_objectWithKeyValues:model.result];

			[zoneDataArr addObject:newInfo];

			if (newInfo.zone_geometry.apex ==nil) {
				newInfo.zone_geometry = nil;
			}

			if (newInfo.circle_geometry.radius ==nil) {
				newInfo.circle_geometry = nil;
			}
			if (newInfo.circle_geometry) {
				CLLocationCoordinate2D coor ;
				coor.latitude = [newInfo.circle_geometry.center.lat floatValue];
				coor.longitude = [newInfo.circle_geometry.center.lng floatValue];

				BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:newInfo.circle_geometry.radius.floatValue];

				circle.subtitle = newInfo.zone_id;
				circle.title = newInfo.data_id;

				[circleOverlayArr addObject:circle];

				[_mapView addOverlay:circle];
			}

			if (newInfo.zone_geometry) {

				CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * newInfo.zone_geometry.apex.count);

				for (int i=0; i<newInfo.zone_geometry.apex.count; i++) {
					CDPoint *point = newInfo.zone_geometry.apex[i];
					coords[i].latitude = point.lat.doubleValue;
					coords[i].longitude = point.lng.doubleValue;
				}

				BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:newInfo.zone_geometry.apex.count];
				polygon.subtitle = newInfo.zone_id;
				polygon.title = newInfo.data_id;


				[polygonOverlayArr addObject:polygon];
				[_mapView addOverlay:polygon];

				
			}
			
		}

		if ([model.action isEqualToString:@"com.dituhui.cute.action.marker_del"]) {
			CDMarkerInfo *markerInfo = [CDMarkerInfo mj_objectWithKeyValues:model.result];

		  for (CDAnno *anno in AnnoOverlayArr) {
		if ([anno.markerInfo.marker_id isEqual:markerInfo.marker_id]) {
			[self.mapView removeAnnotation:anno];
				}
			}
		}

		if ([model.action isEqualToString:@"com.dituhui.cute.action.line_del"]) {
			CDLineInfo *lineInfo = [CDLineInfo mj_objectWithKeyValues:model.result];
			for (BMKPolyline *lineOverlay in lineOverlayArr) {
				if ([lineOverlay.subtitle isEqual:lineInfo.line_id]) {
					[self.mapView removeOverlay:lineOverlay];
				}
			}




		}
	}

if ([model.action isEqualToString:@"com.dituhui.cute.action.zone_del"]) {
	CDZoneInfo *zoneInfo = [CDZoneInfo mj_objectWithKeyValues:model.result];
	for (BMKPolygon *polygon in polygonOverlayArr) {
		if ([polygon.subtitle isEqual:zoneInfo.zone_id]) {
			[self.mapView removeOverlay:polygon];
		}
	}

	for (BMKCircle *circle in circleOverlayArr) {
		if ([circle.subtitle isEqual:zoneInfo.zone_id]) {
			[self.mapView removeOverlay:circle];
		}
	}
}

if ([model.action isEqualToString:@"com.dituhui.cute.action.marker_fields_edit"]) {
	CDMarkerInfo *markerInfo = [CDMarkerInfo mj_objectWithKeyValues:model.result];

	CDMarkerStyle *annoStyle = [[CDMarkerStyle alloc]init];
	CDAnno *del_anno = [[CDAnno alloc]init];
	for (CDAnno *anno in AnnoOverlayArr) {
		if ([anno.markerInfo.marker_id isEqual:markerInfo.marker_id]) {
			[self.mapView removeAnnotation:anno];
			annoStyle = anno.markerInfo.style;
			del_anno = anno;
		}
	}


	CDAnno* annotation = [[CDAnno alloc]init];
	annotation.markerInfo = markerInfo;
	annotation.markerInfo.style = annoStyle;

	CLLocationCoordinate2D coor;
	coor.latitude = markerInfo.bd_y.floatValue;
	coor.longitude = markerInfo.bd_x.floatValue;
	annotation.coordinate = coor;
	annotation.title = markerInfo.title;

	[AnnoOverlayArr removeObject:del_anno];
	[AnnoOverlayArr addObject:annotation];
	[self.mapView addAnnotation:annotation];

}

	if ([model.action isEqualToString:@"com.dituhui.cute.action.markerstyle_edit"]) {
		CDMarkerInfo *markerInfo = [CDMarkerInfo mj_objectWithKeyValues:model.result];


		CDAnno *del_anno = [[CDAnno alloc]init];
		for (CDAnno *anno in AnnoOverlayArr) {
			if ([anno.markerInfo.marker_id isEqual:markerInfo.marker_id]) {
				[self.mapView removeAnnotation:anno];
				del_anno = anno;
			}
		}


		CDAnno* annotation = [[CDAnno alloc]init];
		annotation.markerInfo = markerInfo;


		CLLocationCoordinate2D coor;
		coor.latitude = markerInfo.bd_y.floatValue;
		coor.longitude = markerInfo.bd_x.floatValue;
		annotation.coordinate = coor;
		annotation.title = markerInfo.title;

		[AnnoOverlayArr removeObject:del_anno];
		[AnnoOverlayArr addObject:annotation];
		[self.mapView addAnnotation:annotation];
	}


	if ([model.action isEqualToString:@"com.dituhui.cute.action.marker_sort_key_style_edit"]) {

		CDLayerInfo *newLayerInfo = [CDLayerInfo mj_objectWithKeyValues:model.result];

		for (CDAnno *anno in AnnoOverlayArr) {
			if([anno.markerInfo.data_id isEqual:newLayerInfo.data_id]){

					if ([newLayerInfo.spreadmap_style.sort.sort_key isEqual:@"title"]) {
						for (CDSortValue *sortValue in newLayerInfo.spreadmap_style.sort.sort_values) {
							if ([sortValue.name isEqual:anno.markerInfo.title]) {

								[self.mapView removeAnnotation:anno];
								anno.markerInfo.style = sortValue.style;
								[self.mapView addAnnotation:anno];
							}else{

								if ([sortValue.name isEqualToString:@"剩余所有"]) {
									[self.mapView removeAnnotation:anno];
									anno.markerInfo.style = sortValue.style;
									[self.mapView addAnnotation:anno];
								}

							}
						}

					}else
						if ([anno.markerInfo.extend_data.allKeys containsObject:newLayerInfo.spreadmap_style.sort.sort_key]) {

							NSString *str = anno.markerInfo.extend_data[newLayerInfo.spreadmap_style.sort.sort_key];

							for (CDSortValue *sortValue in newLayerInfo.spreadmap_style.sort.sort_values) {
								if ([sortValue.name isEqual:str]) {

									[self.mapView removeAnnotation:anno];
									anno.markerInfo.style = sortValue.style;
									[self.mapView addAnnotation:anno];
								}else{

									if ([sortValue.name isEqualToString:@"剩余所有"]) {
										[self.mapView removeAnnotation:anno];
										anno.markerInfo.style = sortValue.style;
										[self.mapView addAnnotation:anno];
									}
									
								}
							}


						}else
							if ([newLayerInfo.spreadmap_style.sort.sort_key isEqual:@"description"]) {




								for (CDSortValue *sortValue in newLayerInfo.spreadmap_style.sort.sort_values) {
									if ([sortValue.name isEqual:anno.markerInfo.markerDescription]) {

										[self.mapView removeAnnotation:anno];
										anno.markerInfo.style = sortValue.style;
										[self.mapView addAnnotation:anno];
									}else{

										if ([sortValue.name isEqualToString:@"剩余所有"]) {
											[self.mapView removeAnnotation:anno];
											anno.markerInfo.style = sortValue.style;
											[self.mapView addAnnotation:anno];
										}
										
									}
								}

							}
				}
			}

	}


	if ([model.action isEqualToString:@"com.dituhui.cute.action.marker_common_style_edit"]) {
		CDLayerInfo *newLayerInfo = [CDLayerInfo mj_objectWithKeyValues:model.result];
		for (CDLayerInfo *layer in markerLayers) {
			if ([layer.layer_id isEqual:newLayerInfo.layer_id]) {
				for (CDAnno *anno in AnnoOverlayArr) {

					if ([anno.markerInfo.data_id isEqual:layer.data_id]) {

						[self.mapView removeAnnotation:anno];
						anno.markerInfo.style = newLayerInfo.spreadmap_style.marker_icon_style;
						[self.mapView addAnnotation:anno];
					}
				}
			}
		}
	}


	if ([model.action isEqualToString:@"com.dituhui.cute.action_line_fields_edit"]) {
		CDLineInfo *newInfo = [CDLineInfo mj_objectWithKeyValues:model.result];

		CDLineInfo *lineInfo_temp = [[CDLineInfo alloc]init];

		for (CDLineInfo *lineinfo in lineDataArr) {
			if ([lineinfo.line_id isEqual:newInfo.line_id]) {
				lineInfo_temp = lineinfo;
				newInfo.style = lineinfo.style;
			}
		}

		for (BMKPolyline *lineOverlay in lineOverlayArr) {
			if ([lineOverlay.subtitle isEqual:newInfo.line_id]) {
				[self.mapView removeOverlay:lineOverlay];
			}
		}
		[lineDataArr removeObject:lineInfo_temp];
		[lineDataArr addObject:newInfo];


		CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * newInfo.line_geometry.apex.count);

		for (int i=0; i<newInfo.line_geometry.apex.count; i++) {
			CDPoint *point = newInfo.line_geometry.apex[i];
			coords[i].longitude = [point.lng floatValue];
			coords[i].latitude= [point.lat floatValue];
		}

		BMKPolyline *pline = [BMKPolyline polylineWithCoordinates:coords count:newInfo.line_geometry.apex.count];


		pline.subtitle = newInfo.line_id;

		[lineOverlayArr addObject:pline];
		[lineDataArr addObject:newInfo];

		[_mapView addOverlay:pline];


	}


	if ([model.action isEqualToString:@"com.dituhui.cute.action.linestyle_edit"]) {
		CDLineInfo *newInfo = [CDLineInfo mj_objectWithKeyValues:model.result];

		CDLineInfo *lineInfo_temp = [[CDLineInfo alloc]init];

		for (CDLineInfo *lineinfo in lineDataArr) {
			if ([lineinfo.line_id isEqual:newInfo.line_id]) {
				lineInfo_temp = lineinfo;
			}
		}

		for (BMKPolyline *lineOverlay in lineOverlayArr) {
			if ([lineOverlay.subtitle isEqual:newInfo.line_id]) {
				[self.mapView removeOverlay:lineOverlay];
			}
		}
		[lineDataArr removeObject:lineInfo_temp];
		[lineDataArr addObject:newInfo];


		CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * newInfo.line_geometry.apex.count);

		for (int i=0; i<newInfo.line_geometry.apex.count; i++) {
			CDPoint *point = newInfo.line_geometry.apex[i];
			coords[i].longitude = [point.lng floatValue];
			coords[i].latitude= [point.lat floatValue];
		}

		BMKPolyline *pline = [BMKPolyline polylineWithCoordinates:coords count:newInfo.line_geometry.apex.count];


		pline.subtitle = newInfo.line_id;

		[lineOverlayArr addObject:pline];
		[lineDataArr addObject:newInfo];

		[_mapView addOverlay:pline];

	}

	if ([model.action isEqual:@"com.dituhui.cute.action.zone_fields_edit"]) {
		CDZoneInfo *newInfo = [CDZoneInfo mj_objectWithKeyValues:model.result];

		CDZoneInfo *zoneInfo_temp = [[CDZoneInfo alloc]init];

		for (CDZoneInfo *zoneinfo in zoneDataArr) {
			if ([zoneinfo.zone_id isEqual:newInfo.zone_id]) {
				zoneInfo_temp = zoneinfo;
				newInfo.style = zoneinfo.style;
			}
		}

		for (BMKPolygon *polygon in polygonOverlayArr) {
			if ([polygon.subtitle isEqual:newInfo.zone_id]) {
				[self.mapView removeOverlay:polygon];
			}
		}

		for (BMKCircle *circle in circleOverlayArr) {
			if ([circle.subtitle isEqual:newInfo.zone_id]) {
				[self.mapView removeOverlay:circle];
			}
		}
		[zoneDataArr removeObject:zoneInfo_temp];
		[zoneDataArr addObject:newInfo];

		if (newInfo.zone_geometry.apex ==nil) {
			newInfo.zone_geometry = nil;
		}

		if (newInfo.circle_geometry.radius ==nil) {
			newInfo.circle_geometry = nil;
		}
		if (newInfo.circle_geometry) {
			CLLocationCoordinate2D coor ;
			coor.latitude = [newInfo.circle_geometry.center.lat floatValue];
			coor.longitude = [newInfo.circle_geometry.center.lng floatValue];

			BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:newInfo.circle_geometry.radius.floatValue];

			circle.subtitle = newInfo.zone_id;
			circle.title = newInfo.data_id;

			[circleOverlayArr addObject:circle];

			[_mapView addOverlay:circle];
		}

		if (newInfo.zone_geometry) {

			CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * newInfo.zone_geometry.apex.count);

			for (int i=0; i<newInfo.zone_geometry.apex.count; i++) {
				CDPoint *point = newInfo.zone_geometry.apex[i];
				coords[i].latitude = point.lat.doubleValue;
				coords[i].longitude = point.lng.doubleValue;
			}

			BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:newInfo.zone_geometry.apex.count];
			polygon.subtitle = newInfo.zone_id;
			polygon.title = newInfo.data_id;


			[polygonOverlayArr addObject:polygon];
			[_mapView addOverlay:polygon];


		}


	}


	if ([model.action isEqualToString:@"com.dituhui.cute.action.zonestyle_edit"]) {
		CDZoneInfo *newInfo = [CDZoneInfo mj_objectWithKeyValues:model.result];

		CDZoneInfo *zoneInfo_temp = [[CDZoneInfo alloc]init];

		for (CDZoneInfo *zoneinfo in zoneDataArr) {
			if ([zoneinfo.zone_id isEqual:newInfo.zone_id]) {
				zoneInfo_temp = zoneinfo;
			}
		}

		for (BMKPolygon *polygon in polygonOverlayArr) {
			if ([polygon.subtitle isEqual:newInfo.zone_id]) {
				[self.mapView removeOverlay:polygon];
			}
		}

		for (BMKCircle *circle in circleOverlayArr) {
			if ([circle.subtitle isEqual:newInfo.zone_id]) {
				[self.mapView removeOverlay:circle];
			}
		}
		[zoneDataArr removeObject:zoneInfo_temp];
		[zoneDataArr addObject:newInfo];

		if (newInfo.zone_geometry.apex ==nil) {
			newInfo.zone_geometry = nil;
		}

		if (newInfo.circle_geometry.radius ==nil) {
			newInfo.circle_geometry = nil;
		}
		if (newInfo.circle_geometry) {
			CLLocationCoordinate2D coor ;
			coor.latitude = [newInfo.circle_geometry.center.lat floatValue];
			coor.longitude = [newInfo.circle_geometry.center.lng floatValue];

			BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:newInfo.circle_geometry.radius.floatValue];

			circle.subtitle = newInfo.zone_id;
			circle.title = newInfo.data_id;

			[circleOverlayArr addObject:circle];

			[_mapView addOverlay:circle];
		}

		if (newInfo.zone_geometry) {

			CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * newInfo.zone_geometry.apex.count);

			for (int i=0; i<newInfo.zone_geometry.apex.count; i++) {
				CDPoint *point = newInfo.zone_geometry.apex[i];
				coords[i].latitude = point.lat.doubleValue;
				coords[i].longitude = point.lng.doubleValue;
			}

			BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:newInfo.zone_geometry.apex.count];
			polygon.subtitle = newInfo.zone_id;
			polygon.title = newInfo.data_id;


			[polygonOverlayArr addObject:polygon];
			[_mapView addOverlay:polygon];
			
			
		}
	}

	if ([model.action isEqualToString:@"com.dituhui.cute.action.layerinfo_edit"]) {
		CDLayerInfo *layerInfo = [CDLayerInfo mj_objectWithKeyValues:model.result];

		CDLayerInfo *layerinfo_temp = [[CDLayerInfo alloc]init];

		for (CDLayerInfo *layerinfo in layersArr) {
			if ([layerinfo.layer_id isEqual:layerInfo.layer_id]) {
				layerinfo_temp = layerinfo;
			}
		}

		[layersArr removeObject:layerinfo_temp];
		[layersArr addObject:layerInfo];

		[self.layerShowTableView reloadData];
	}


	if ([model.action isEqualToString:@"com.dituhui.cute.action.map_delete"]) {

		[self dismissViewControllerAnimated:YES completion:nil];
			[[NSNotificationCenter defaultCenter]postNotificationName:CDLoadedNewMap object:nil];
	}
}


- (void)viewDidLoad {
	[super viewDidLoad];

	lineDisTanceArr = [[NSMutableArray alloc]init];

	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

	measureLineArr = [[NSMutableArray alloc]init];

	makeLineArr = [[NSMutableArray alloc]init];
	makeLineAnnoArr = [[NSMutableArray alloc]init];

	makeZoneArr = [[NSMutableArray alloc]init];
	makeZoneAnnoArr = [[NSMutableArray alloc]init];

	 [self.extendEditTB setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
	

	measureAnnoArr = [[NSMutableArray alloc]init];
	AnnoOverLayArr_tem = [[NSMutableArray alloc]init];

	self.mapView.rotateEnabled = NO;
	self.coordinateQuadTree = [[CoordinateQuadTree alloc] init];

	self.selectedPoiArray = [[NSMutableArray alloc] init];

	self.customCalloutView = [[CustomCalloutView alloc] init];
	_shouldRegionChangeReCalculate = NO;

	lineDataArr = [NSMutableArray array];
	zoneDataArr = [NSMutableArray array];

		// Do any additional setup after loading the view.
	extendAttr = [NSMutableDictionary dictionary];

	_selectedPhotos = [NSMutableArray array];

	isEditting = NO;
	isAddAnno = NO;
	selectLayerBtnOpen = NO;
	isMapDiffOpne = NO;

	markerLayers = [NSMutableArray array];
	lineLayers = [NSMutableArray array];
	zoneLayers = [NSMutableArray array];

	imagespost = [NSMutableArray array];

	layersArr = [NSMutableArray array];
	AnnoOverlayArr = [NSMutableArray array];
	lineOverlayArr = [NSMutableArray array];
	circleOverlayArr = [NSMutableArray array];
	polygonOverlayArr = [NSMutableArray array];

	overlayDelay = 0.5;
	overlayHeight = 120;
	overlayEditHeight = 130;

	[self navOverlayNorChange];

	if (!self.isNewMap) {
		self.mapTitle.text = self.mapInfo.title;
	}

	self.mapInfoView.userInteractionEnabled = YES;

	if (self.mapInfo.center) {
		NSArray *array = [self.mapInfo.center componentsSeparatedByString:@","];

		CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([array[1] doubleValue], [array[0] doubleValue]);

		[_mapView setCenterCoordinate:coor];
		[_mapView setZoomLevel:[self.mapInfo.level doubleValue]];
	}

	UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapInfoViewClick)];
	[self.mapInfoView addGestureRecognizer:tapGesture];

	self.overlayInfoHeight.constant = kHeight -64;
	self.overlayEditViewHeight.constant = kHeight -64;

	UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction:)];
	[self.overlayInfoView addGestureRecognizer:panGestureRecognizer];

	UITapGestureRecognizer *overlayInfoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
	[self.overlayInfoView addGestureRecognizer:overlayInfoTap];

	UIPanGestureRecognizer * panEditGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanActionEdit:)];
	[self.overlayEditView addGestureRecognizer:panEditGestureRecognizer];

	UITapGestureRecognizer *overlayInfoTapEdit = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ActiondoEdit:)];

	
	[self.overlayEditView addGestureRecognizer:overlayInfoTapEdit];
	self.overlayEditTitle.delegate = self;
	self.overlayEditDes.delegate = self;

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelectPOISeacher:) name:SMSectetPOIseachNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelectResultSeacher:) name:SMsectetResultSeachNotification object:nil];

	self.mapDiffView.hidden = YES;

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideLayer:) name:CDHiddenLayerNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLayer:) name:CDShowLayerNotification object:nil];

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(lineStyleChange:) name:CDLineStyleChange object:nil];

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zoneStyleChange:) name:CDZoneStyleChange object:nil];

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imageAddMethod:) name:CDImageAddNoti object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imageDeleMethod:) name:CDImageDeleNoti object:nil];

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imagesPost:) name:CDImagePostNoti object:nil];

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMapInfo:) name:mapDetailChangeMap object:nil];

	if (self.isNewMap) {
		[self loadNewMap];
	}else{
		[self loadAllLayers:self.mapInfo.map_id];
	}

	UIView *view1 = [UIView new];

	view1.backgroundColor = [UIColor clearColor];

	[self.layerShowTableView setTableFooterView:view1];

	self.title = @"";

	isClickNav = NO;

	isMoreOpen = NO;
	
	self.moreView.hidden = YES;

	self.extendShowTB.estimatedRowHeight = 200.0;
	self.extendShowTB.rowHeight = UITableViewAutomaticDimension;


}

-(NSMutableArray *)getShow_arr:(CDLayerInfo *)layerInfo
	{
		NSMutableArray *array1 = [layerInfo.all_attributes componentsSeparatedByString:@","].mutableCopy;
		NSMutableArray *array2 = [layerInfo.invisible_attr componentsSeparatedByString:@","].mutableCopy;
		NSMutableArray *array3 = [layerInfo.unshow_attr componentsSeparatedByString:@","].mutableCopy;
	
		if (array1.count) {
			if (array2.count) {
				for (NSString *key in array2) {
					[array1 removeObject:key];
				}
			}
			if (array3.count) {
				for (NSString *key in array3) {
					[array1 removeObject:key];
				}
			}
			return array1;
		}
//		_show_arr = array1;
		else return nil;
}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

	if (tableView == self.extendShowTB ) {
		return [self getShow_arr:selectedInfoLyaerInfo].count;
	}
	else if(tableView == self.extendEditTB){
		if (selectedAnno) {
			return [self getShow_arr:selectedInfoLyaerInfo].count;
		}
		else if(isAddAnno){
			return [self getShow_arr:selectedAddLyaerInfo].count;
		}else if(isMakeLine || isMakeZone){
			return [self getShow_arr:selectedAddLyaerInfo].count;
		}
	}
	else if(tableView == self.layerShowTableView){
	return layersArr.count;
	}

	return 0;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.extendShowTB) {
		static NSString *ID = @"extendShowCell";
		extendShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
		if (cell == nil) {
			cell = [[extendShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
		}

	cell.key = [NSString stringWithFormat:@"%@",[self getShow_arr:selectedInfoLyaerInfo][indexPath.row]];

    if ([selectedAnno.markerInfo.extend_data.allKeys containsObject: [self getShow_arr:selectedInfoLyaerInfo][indexPath.row]]) {

	cell.value = [NSString stringWithFormat:@"%@",selectedAnno.markerInfo.extend_data[[self getShow_arr:selectedInfoLyaerInfo][indexPath.row]]];

	}else{
		cell.value = @"无";
	}

		return cell;
	}else
		if (tableView == self.extendEditTB) {
			static NSString *ID = @"extendEditCell";
			extendEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
			if (cell == nil) {
				cell = [[extendEditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
			}
			cell.editValueTextField.tag = indexPath.row;

			selectTextFiled = cell.editValueTextField;

			if (selectedAnno) {
	cell.key = [NSString stringWithFormat:@"%@",[self getShow_arr:selectedInfoLyaerInfo][indexPath.row]];

				if ([selectedAnno.markerInfo.extend_data.allKeys containsObject: [self getShow_arr:selectedInfoLyaerInfo][indexPath.row]]) {

					cell.value = [NSString stringWithFormat:@"%@",selectedAnno.markerInfo.extend_data[[self getShow_arr:selectedInfoLyaerInfo][indexPath.row]]];

				}else{
					cell.value = @"无";
				}

			}else
				{
				cell.key = [NSString stringWithFormat:@"%@",[self getShow_arr:selectedAddLyaerInfo][indexPath.row]];
				cell.value = nil;
				}
			return cell;
		} 
	else{
		static NSString *ID = @"cell";
		MapDiffLayerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
		if (cell == nil) {
			cell = [[MapDiffLayerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
		}
		cell.layerInfo = layersArr[indexPath.row];
		return cell;
	}

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.extendShowTB) {

	}else{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	CDLayerInfo *layerInfo = layersArr[indexPath.row];
	mapDIffLayerView *diff = [[UIStoryboard storyboardWithName:@"mapDIffLayerView" bundle:nil]instantiateInitialViewController];
	diff.layer = layerInfo;

	[self.navigationController pushViewController:diff animated:YES];
	}
}


- (void)keyboardDidShow:(NSNotification *)note
{

	NSTimeInterval time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
	NSInteger animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];


	[UIView animateWithDuration:time delay:0 options:animationCurve << 16 animations:^{

		CDLog(@"%tu",selectTextFiled.tag);
		self.extendEditTB.contentOffset  = CGPointMake(0,(selectTextFiled.tag +1) * 44) ;

	} completion:nil];


}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	self.locateBtn.hidden = YES;
	self.fangdaBtn.hidden =YES;
	self.suoxiaoBtn.hidden = YES;

	[self navEditState3Change];

	self.overlaySave.hidden = YES;
	self.edit_icon_up_image.hidden = YES;

	[UIView animateWithDuration:overlayDelay animations:^{
		self.overlayInfoViewBottom.constant = 0;
		self.overlayEditViewBottom.constant = kHeight -64;
	}];

	if (isEditting ) {

		if (textField != self.overlayEditTitle) {
					selectTextFiled = textField;
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];

			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldChangeC:) name:UITextFieldTextDidChangeNotification object:nil];
		}

	}
}

-(void)textfieldChangeC:(NSNotification *)noti{
		UITextField *textField = noti.object;
		extendEditTableViewCell *cell = (extendEditTableViewCell *)textField.superview.superview;
//
		extendAttr[cell.key] = textField.text;
}


-(void)navOverlayState3Change
{
	self.navigationItem.rightBarButtonItem =

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(overlayNavClick:)];

	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(mapInfoUp)];

	self.navigationItem.titleView = nil;
	self.title = @"浏览";
}

-(void)navOverlayNorChange
{
	UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭地图" style:UIBarButtonItemStylePlain
																  target:self action:@selector(closeMap)];
	self.navigationItem.leftBarButtonItem = leftBarItem;

	UIButton *buttonSearch = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];

	[buttonSearch setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];

	[buttonSearch addTarget:self action:@selector(overlaySearch) forControlEvents:UIControlEventTouchUpInside];

	UIButton *mapDiff = [[UIButton alloc]initWithFrame:CGRectMake(44, 0, 44, 44)];
	[mapDiff setImage:[UIImage imageNamed:@"btn_coverage"] forState:UIControlStateNormal];
	[mapDiff addTarget:self action:@selector(openMapDiff) forControlEvents:UIControlEventTouchUpInside];
	mapDiffButton = mapDiff;

	UIButton *parterBtn = [[UIButton alloc]initWithFrame:CGRectMake(88, 0, 44, 44)];
	[parterBtn setImage:[UIImage imageNamed:@"btn_team"] forState:UIControlStateNormal];
	[parterBtn addTarget:self action:@selector(parterBtnClick) forControlEvents:UIControlEventTouchUpInside];

	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 88 +44, 44)];
	[view addSubview:buttonSearch];
	[view addSubview:mapDiff];
	[view addSubview:parterBtn];


	self.navigationItem.titleView = view;

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_more-2"] style:UIBarButtonItemStylePlain target:self action:@selector(openMore)];
	[[UIApplication sharedApplication].keyWindow endEditing:YES];

	self.extendEditTB.userInteractionEnabled = NO;
}

-(void)parterBtnClick
{
	CDMapPartenerTableViewController *vc = [[UIStoryboard storyboardWithName:@"CDMapPatater" bundle:nil]instantiateInitialViewController];
	vc.mapInfo =self.mapInfo;
	[self.navigationController pushViewController:vc animated:YES];
}

-(void)navEditState3Change
{


	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(overlaySaveClick:)];

	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(mapInfoUp)];


	self.navigationItem.titleView = nil;

	if (selectedAnno ||selectedZoneInfo||selectedLineInfo) {
		self.title = @"编辑";
	}else
		{
		self.title = @"添加";
		}

	self.extendEditTB.userInteractionEnabled = YES;

}




-(void)openMore
{
	if (!isMoreOpen) {
		self.moreView.hidden = NO;
	}else
		{
		self.moreView.hidden = YES;
		}
	isMoreOpen = !isMoreOpen;
}


-(void)changeMapInfo:(NSNotification *)noti
{
	CDMapInfo *mapinfo = [noti.userInfo valueForKey:@"mapInfo"];
	self.mapInfo = mapinfo;
}


-(void)imagesPost:(NSNotification *)noti
{
	NSMutableArray *images = [noti.userInfo valueForKey:@"images"];
	imagespost = images;
	[self.uploadCount setTitle:[NSString stringWithFormat:@"%tu",images.count] forState:UIControlStateNormal];
	[self.upLoadPicBtn setImage:images[0] forState:UIControlStateNormal];
}

-(void)imageDeleMethod:(NSNotification *)noti
{
	NSString *deleUrl =[noti.userInfo valueForKey:@"deleImageUrl"];
	[self deleteElePic:deleUrl];
}


-(void)imageAddMethod:(NSNotification *)noti
{
	NSArray *images = [noti.userInfo valueForKey:@"addImages"];

	CDImageShowVC *VC =[noti.userInfo valueForKey:@"VC"];

	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

	[SVProgressHUD showWithStatus:@"正在上传图片……"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	if (selectedZoneInfo) {
		dic[@"ele_id"] = selectedZoneInfo.zone_id;
		dic[@"ele_type"] = @"2";
	}else
		if (selectedLineInfo) {
			dic[@"ele_id"] = selectedLineInfo.line_id;
			dic[@"ele_type"] = @"1";
		}else
			if (selectedAnno) {
				dic[@"ele_id"] = selectedAnno.markerInfo.marker_id;
				dic[@"ele_type"] = @"0";
			}


	dic[@"user_id"] = account.user_id;

	[manager POST:[NSString stringWithFormat:@"%@phone/element/uploadimgs",baseUrl] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

		for (UIImage *image in images) {
			NSData *iamgeData = UIImageJPEGRepresentation(image, 0.5);

			[formData appendPartWithFileData:iamgeData name:@"file" fileName:@"a.jpg" mimeType:@"image/jpeg"];
		}
	} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		CDLog(@"%@",responseObject);

		CDImagesUrls *CDurls = [CDImagesUrls mj_objectWithKeyValues:responseObject[@"result"]];
		NSArray *urls = CDurls.path;


		if (urls.count) {
			[self.upLoadPicBtn sd_setImageWithURL:[NSURL URLWithString:urls[0]] forState:UIControlStateNormal];
			[self.uploadCount setTitle:[NSString stringWithFormat:@"%tu",urls.count] forState:UIControlStateNormal];
		}else
			{
			[self.upLoadPicBtn setImage:[UIImage imageNamed:@"btn_image"] forState:UIControlStateNormal];
			[self.uploadCount setTitle:nil forState:UIControlStateNormal];
			}


		[_selectedPhotos removeAllObjects];
		[_selectedPhotos addObjectsFromArray:urls];


		VC.iamgeUrls = _selectedPhotos;
		[VC.imageCollectView reloadData];

		if (selectedAnno) {
			for (CDAnno *anno in AnnoOverlayArr) {
				if (anno  == selectedAnno) {
					anno.markerInfo.images = urls;
				}
			}
		}else
			if (selectedLineInfo){
				for (CDLineInfo *lineInfo in lineDataArr) {
					if (selectedLineInfo == lineInfo) {
						lineInfo.images = urls;
					}
				}
			}else
				if (selectedZoneInfo) {
					for (CDZoneInfo *zoneInfo in zoneDataArr) {
						if (selectedZoneInfo == zoneInfo) {
							zoneInfo.images = urls;
						}
					}
				}


		[SVProgressHUD dismiss];
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];


}
-(void)deleteElePic:(NSString *)deleteUrl
{

	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"imgurl"] = deleteUrl;

	if (selectedAnno) {
		dic[@"ele_type"] = @"0";
		dic[@"ele_id"] = selectedAnno.markerInfo.marker_id;
	}else
		if (selectedLineInfo) {
			dic[@"ele_type"] = @"1";
			dic[@"ele_id"] = selectedLineInfo.line_id;
		}else
			if (selectedZoneInfo) {
				dic[@"ele_type"] = @"2";
				dic[@"ele_id"] = selectedZoneInfo.zone_id;
			}

	[manager POST:[NSString stringWithFormat:@"%@phone/element/deleteimg",baseUrl]
	   parameters:dic progress:nil
		  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
	 {


	 CDLog(@"%@",responseObject);
	 CDImagesUrls *CDurls = [CDImagesUrls mj_objectWithKeyValues:
							 responseObject[@"result"]];
	 NSArray *urls = CDurls.path;



	 [_selectedPhotos removeAllObjects];
	 [_selectedPhotos addObjectsFromArray:urls];

	 if (urls.count) {
		 [self.upLoadPicBtn sd_setImageWithURL:[NSURL URLWithString:urls[0]]
									  forState:UIControlStateNormal];
		 [self.uploadCount setTitle:[NSString stringWithFormat:@"%tu",urls.count]
						   forState:UIControlStateNormal];
	 }else
		 {
		 [self.upLoadPicBtn setImage:[UIImage imageNamed:@"btn_image"]
							forState:UIControlStateNormal];
		 [self.uploadCount setTitle:nil forState:UIControlStateNormal];
		 }

	 if (selectedAnno) {
		 for (CDAnno *anno in AnnoOverlayArr) {
			 if (anno  == selectedAnno) {
				 anno.markerInfo.images = urls;
			 }
		 }
	 }else
		 if (selectedLineInfo){
			 for (CDLineInfo *lineInfo in lineDataArr) {
				 if (selectedLineInfo == lineInfo) {
					 lineInfo.images = urls;
				 }
			 }
		 }else
			 if (selectedZoneInfo) {
				 for (CDZoneInfo *zoneInfo in zoneDataArr) {
					 if (selectedZoneInfo == zoneInfo) {
						 zoneInfo.images = urls;
					 }
				 }
			 }

	 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		 CDLog(@"%@",error);
		 [SVProgressHUD showErrorWithStatus:@"网络错误"];
	 }];

}
-(void)zoneStyleChange:(NSNotification *)noti
{

	if ([noti.userInfo valueForKey:@"zoneCorlor"]) {
		self.zoneChangeCorlor =[noti.userInfo valueForKey:@"zoneCorlor"];

		UIImage *image = [[UIImage imageNamed:@"icon_face"] rt_tintedImageWithColor:[self getColor:self.zoneChangeCorlor alpha:@"1"]  level:1.0f];
		[self.styleShowImageView setImage:image];

	}

	if ([noti.userInfo valueForKey:@"zoneWidth"]) {
	self.zoneWidth = [noti.userInfo valueForKey:@"zoneWidth"];
	}

	if ([noti.userInfo valueForKey:@"zoneAlpha"]) {
	self.zoneAlpha = [noti.userInfo valueForKey:@"zoneAlpha"];
	}

	if ( [noti.userInfo valueForKey:@"colorIndex"]) {
	NSNumber *num = [noti.userInfo valueForKey:@"colorIndex"];
		NSInteger index1 = num.integerValue;
		self.zoneIndex1 = index1;
	}

	if ( [noti.userInfo valueForKey:@"colorIndex2"]) {
	NSNumber *num = [noti.userInfo valueForKey:@"colorIndex2"];
		NSInteger index1 = num.integerValue;
		self.zoneIndex2 = index1;
	}

	if ([noti.userInfo valueForKey:@"zoneLineAlpha"]) {
		self.zoneLineAlpha =[noti.userInfo valueForKey:@"zoneLineAlpha"];
	}

	if ([noti.userInfo valueForKey:@"zoneLineCorlor"]) {
		self.zoneLineCorlor = [noti.userInfo valueForKey:@"zoneLineCorlor"];



		self.styleShowImageView.layer.borderColor = [self stringTOColor:self.zoneLineCorlor alpha:@"1"].CGColor;
		self.styleShowImageView.layer.borderWidth = 2.0f;
	}

	
}
-(void)lineStyleChange:(NSNotification *)noti
{

	if ([noti.userInfo valueForKey:@"lineCorlor"]) {
		self.lineChangeCorlor =[noti.userInfo valueForKey:@"lineCorlor"];

		UIImage *image = [[UIImage imageNamed:@"icon_face_line"] rt_tintedImageWithColor:[self getColor:self.lineChangeCorlor alpha:@"1"]  level:1.0f];
		[self.styleShowImageView setImage:image];
	}

	if ([noti.userInfo valueForKey:@"lineWidth"]) {
		self.lineWidth = [noti.userInfo valueForKey:@"lineWidth"];
	}

	if ([noti.userInfo valueForKey:@"lineAlpha"]) {
		self.lineAlpha = [noti.userInfo valueForKey:@"lineAlpha"];
	}

	if ([noti.userInfo valueForKey:@"colorIndex"]) {
		NSNumber *num = [noti.userInfo valueForKey:@"colorIndex"];
		NSInteger index1 = num.integerValue;
		self.lineIndex1 = index1;
	}


}

-(void)loadNewMap
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"user_id"] = account.user_id;
	dic[@"team_id"] = self.selectTeamId;

	[manager POST:[NSString stringWithFormat:@"%@createMap",baseUrl]
	   parameters:dic progress:nil
		  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			  CDMapInfo *mapInfo = [CDMapInfo mj_objectWithKeyValues:responseObject[@"result"]];
			  self.layerShowTableView.delegate = self;
			  self.layerShowTableView.dataSource = self;
			  [self.layerShowTableView reloadData];

			  self.mapInfo = mapInfo;

			  [layersArr addObjectsFromArray:mapInfo.layers];

			  self.mapDiffViewHeight.constant = 44* layersArr.count +100;

			  if (self.mapDiffViewHeight.constant > kHeight /2) {
				  self.mapDiffViewHeight.constant = kHeight /2;
			  }

			  [self.layerShowTableView reloadData];
			  for (CDLayerInfo *layerInfo  in layersArr) {
				  if ([layerInfo.layer_type isEqualToString:@"0"]) {
					  [markerLayers addObject:layerInfo];
				  }
				  if ([layerInfo.layer_type isEqualToString:@"1"]) {
					  [lineLayers addObject:layerInfo];
				  }
				  if ([layerInfo.layer_type isEqualToString:@"2"]) {
					  [zoneLayers addObject:layerInfo];
				  }
			  }

			  self.mapTitle.text = self.mapInfo.title;
			  [[NSNotificationCenter defaultCenter]postNotificationName:CDLoadedNewMap object:nil];

		  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			  CDLog(@"%@",error);
			  [SVProgressHUD showErrorWithStatus:@"网络错误"];
		  }];
}


-(void)loadAllLayers:(NSString *)map_id{



	dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

		dispatch_async(dispatch_get_main_queue(), ^{

			[SVProgressHUD showWithStatus:@"正在加载地图"];
		});
	});

	[AnnoOverlayArr removeAllObjects];
	[lineOverlayArr removeAllObjects];
	[circleOverlayArr removeAllObjects];
	[polygonOverlayArr removeAllObjects];


	[markerLayers removeAllObjects];
	[zoneLayers removeAllObjects];
	[lineLayers removeAllObjects];

	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"map_id"] = map_id;
	dic[@"user_id"] = account.user_id;
	req =  [manager GET:[NSString stringWithFormat:@"%@phone/map/layers2",baseUrl]
	  parameters:dic progress:nil
		 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			 if ([responseObject[@"status"] isEqual:@1]) {

				 layersArr = [CDLayerInfo mj_objectArrayWithKeyValuesArray: responseObject[@"result"]];

				 self.layerShowTableView.delegate = self;
				 self.layerShowTableView.dataSource = self;
				 [self.layerShowTableView reloadData];

				 for (CDLayerInfo *layerInfo in layersArr) {

					 if ([layerInfo.layer_type isEqualToString:@"0"]) {



						 [markerLayers addObject:layerInfo];

						NSArray *markerInfoArr =[CDMarkerInfo mj_objectArrayWithKeyValuesArray:layerInfo.datas];

						NSMutableArray *markersArr = [NSMutableArray array];

						 for (CDMarkerInfo *makerInfo in markerInfoArr) {
							 CDAnno* annotation = [[CDAnno alloc]init];
							 CLLocationCoordinate2D coor;
							 coor.latitude = makerInfo.bd_y.floatValue;
							 coor.longitude = makerInfo.bd_x.floatValue;
							 annotation.coordinate = coor;
							 annotation.title = makerInfo.title;

							 annotation.markerInfo = makerInfo;
							 [markersArr addObject:annotation];
							 [AnnoOverlayArr addObject:annotation];
						 }

						 if ([layerInfo.show_type isEqual:@"3"]) {

							 BMKHeatMap* heatMap = [[BMKHeatMap alloc]init];

							 NSMutableArray* data = [NSMutableArray array];


							 for (CDAnno *anno  in markersArr) {

								 BMKHeatMapNode *heapmapnode_test = [[BMKHeatMapNode alloc]init];

								 heapmapnode_test.pt = anno.coordinate;


						if ([layerInfo.hotmap_style.weight_key isEqual:@"title"]){
									 if (anno.markerInfo.title.floatValue >0) {
										 heapmapnode_test.intensity = anno.markerInfo.title.floatValue;
									 }else{
										 heapmapnode_test.intensity = 1.0f;
									 }
						}

						if ([layerInfo.hotmap_style.weight_key isEqual:@"description"]) {
								if (anno.markerInfo.markerDescription.floatValue >0){
									 heapmapnode_test.intensity = anno.markerInfo.markerDescription.floatValue;
								}else{
									heapmapnode_test.intensity = 1.0f;
								}
							}

					if ([anno.markerInfo.extend_data.allKeys containsObject:layerInfo.hotmap_style.weight_key]) {
						NSString *str =anno.markerInfo.extend_data[layerInfo.hotmap_style.weight_key];
						if (str.floatValue >0){
							heapmapnode_test.intensity =str.floatValue;
						}else{
							heapmapnode_test.intensity = 1.0f;
						}
					}


								 [data addObject:heapmapnode_test];
							 }

							 UIColor* color1 = [UIColor blueColor];
							 UIColor* color2 = [UIColor greenColor];
							 UIColor* color3 = [UIColor yellowColor];
							 UIColor* color4 = [UIColor redColor];

							 NSArray*colorInitialArray = [[NSArray alloc]initWithObjects:color1,color2,color3,color4,nil];


							 BMKGradient* gradient =[[BMKGradient alloc]initWithColors:colorInitialArray startPoints:@[@"0.08",@"0.5",@"0.8",@"1"]];
							 heatMap.mGradient = gradient;
							 

							 heatMap.mData = data;
							 heatMap.mRadius = layerInfo.hotmap_style.radius.floatValue *2;
						
							 [_mapView addHeatMap:heatMap];

							 if ([layerInfo.hotmap_style.ismarker_show isEqual:@"1"]) {
								  [_mapView addAnnotations:markersArr];
							 }

						 }else{
							 [_mapView addAnnotations:markersArr];
						 }



					 }

					 if ([layerInfo.layer_type isEqualToString:@"1"]) {

						 [lineLayers addObject:layerInfo];

						 NSMutableArray *lineInfoArr =
						 [CDLineInfo  mj_objectArrayWithKeyValuesArray:layerInfo.datas];

					[lineDataArr addObjectsFromArray:lineInfoArr];

						 for (CDLineInfo *lineInfo in lineInfoArr) {

							 CLLocationCoordinate2D *coords =
							 malloc(sizeof(CLLocationCoordinate2D) * lineInfo.line_geometry.apex.count);

							 for (int i=0; i<lineInfo.line_geometry.apex.count; i++) {
								 CDPoint *point = lineInfo.line_geometry.apex[i];
								 coords[i].longitude = [point.lng floatValue];
								 coords[i].latitude= [point.lat floatValue];
							 }

							 BMKPolyline *pline = [BMKPolyline polylineWithCoordinates:coords count:lineInfo.line_geometry.apex.count];



							 pline.subtitle = lineInfo.line_id;
							 pline.title = lineInfo.data_id;

							 [lineOverlayArr addObject:pline];
							 [_mapView addOverlay:pline];

						 }
					 }

					 if ([layerInfo.layer_type isEqualToString:@"2"]) {

						 [zoneLayers addObject:layerInfo];

						 NSMutableArray *zoneInfoArr = [CDZoneInfo   mj_objectArrayWithKeyValuesArray:layerInfo.datas];

						 for (CDZoneInfo *zoneInfo in zoneInfoArr) {

							 if (zoneInfo.zone_geometry.apex ==nil) {
								 zoneInfo.zone_geometry = nil;
							 }

							 if (zoneInfo.circle_geometry.radius ==nil) {
								 zoneInfo.circle_geometry = nil;
							 }

							 if (zoneInfo.circle_geometry) {
								 CLLocationCoordinate2D coor ;
								 coor.latitude = [zoneInfo.circle_geometry.center.lat floatValue];
								 coor.longitude = [zoneInfo.circle_geometry.center.lng floatValue];

								 BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:zoneInfo.circle_geometry.radius.floatValue];

								 circle.subtitle = zoneInfo.zone_id;
								 circle.title = zoneInfo.data_id;

								 [circleOverlayArr addObject:circle];
								 [_mapView addOverlay:circle];

							 }

							 if (zoneInfo.zone_geometry) {
								 CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * zoneInfo.zone_geometry.apex.count);

								 for (int i=0; i<zoneInfo.zone_geometry.apex.count; i++) {
									 CDPoint *point = zoneInfo.zone_geometry.apex[i];
									 coords[i].latitude = point.lat.doubleValue;
									 coords[i].longitude = point.lng.doubleValue;
								 }

								 BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:zoneInfo.zone_geometry.apex.count];
								 polygon.subtitle = zoneInfo.zone_id;
								 polygon.title = zoneInfo.data_id;

								 [polygonOverlayArr addObject:polygon];
								 [_mapView addOverlay:polygon];
							 }
						 }

						 [zoneDataArr addObjectsFromArray:zoneInfoArr];
//						 zoneDataArr = zoneInfoArr;
					 }


//						 if ([_mapInfo.cluster isEqualToString:@"0"]) {


	}





				 if (AnnoOverlayArr.count >2000) {

					[AnnoOverLayArr_tem addObjectsFromArray:AnnoOverlayArr];
					 @synchronized(self)
					 {
					 self.shouldRegionChangeReCalculate = NO;

					 [self.selectedPoiArray removeAllObjects];
					 [self.customCalloutView dismissCalloutView];

					 [self.mapView removeAnnotations:self.mapView.annotations];

					 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

						 [self.coordinateQuadTree buildTreeWithPOIs:AnnoOverlayArr];
						 self.shouldRegionChangeReCalculate = YES;
						 [self addAnnotationsToMapView:self.mapView];
						 
					 });
					 }
				 }

//							[SVProgressHUD dismiss];


				 dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

					 dispatch_async(dispatch_get_main_queue(), ^{
//						 [hud hideAnimated:YES];
						 	[SVProgressHUD dismiss];
					 });
				 });

			 }else
				 {
				 [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
				 }
		 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			 CDLog(@"%@",error);
//			 [SVProgressHUD dismiss];
		 }];
//	manager1 = manager;
}

-(void)hideLayer:(NSNotification *)notification{


	CDLayerInfo *layerInfo = [notification.userInfo valueForKey:@"layerInfo"];


	if ([layerInfo.layer_type isEqualToString:@"0"]) {

		if (AnnoOverlayArr.count <2000) {
			for (CDAnno *anno in AnnoOverlayArr) {
				if ([anno.markerInfo.data_id isEqual:layerInfo.data_id]) {
					[self.mapView removeAnnotation:anno];
				}
			}
		}else{


			for (CDAnno *anno in AnnoOverlayArr) {
				if ([anno.markerInfo.data_id isEqual:layerInfo.data_id]) {
					[AnnoOverLayArr_tem removeObject:anno];
					}
			}

			@synchronized(self)
			{
			self.shouldRegionChangeReCalculate = NO;
				// 清理
			[self.selectedPoiArray removeAllObjects];
			[self.customCalloutView dismissCalloutView];
			[self.mapView removeAnnotations:self.mapView.annotations];

			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

				if (AnnoOverLayArr_tem.count) {
					[self.coordinateQuadTree buildTreeWithPOIs:AnnoOverLayArr_tem];
					self.shouldRegionChangeReCalculate = YES;
					[self addAnnotationsToMapView:self.mapView];
				}


			});
			}

		}

	}


	if ([layerInfo.layer_type isEqualToString:@"1"]) {
		for (BMKPolyline *line in lineOverlayArr) {
			if ([line.title isEqual:layerInfo.data_id]) {
				[self.mapView removeOverlay:line];
			}
		}

	}

	if ([layerInfo.layer_type isEqualToString:@"2"]) {
		for (BMKCircle *circle in circleOverlayArr) {
			if ([circle.title isEqual:layerInfo.data_id]) {
				[self.mapView removeOverlay:circle];
			}
		}

		for (BMKPolygon *polygon in polygonOverlayArr) {
			if ([polygon.title isEqual:layerInfo.data_id]) {
				[self.mapView removeOverlay:polygon];
			}
		}

	}
}

-(void)showLayer:(NSNotification *)noti{
	CDLayerInfo *layerInfo = [noti.userInfo valueForKey:@"layerInfo"];
	if ([layerInfo.layer_type isEqualToString:@"0"]) {

		if (AnnoOverlayArr.count <2000) {
			for (CDAnno *anno in AnnoOverlayArr) {
				if ([anno.markerInfo.data_id isEqual:layerInfo.data_id]) {
					[self.mapView addAnnotation:anno];
				}
			}
		}else{

			for (CDAnno *anno in AnnoOverlayArr) {
				if ([anno.markerInfo.data_id isEqual:layerInfo.data_id]) {
					[AnnoOverLayArr_tem addObject:anno];
				}
			}

			@synchronized(self)
			{
			self.shouldRegionChangeReCalculate = NO;

			[self.selectedPoiArray removeAllObjects];
			[self.customCalloutView dismissCalloutView];
			[self.mapView removeAnnotations:self.mapView.annotations];

			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{


				if (AnnoOverLayArr_tem.count) {
					[self.coordinateQuadTree buildTreeWithPOIs:AnnoOverLayArr_tem];
					self.shouldRegionChangeReCalculate = YES;
					[self addAnnotationsToMapView:self.mapView];
				}


			});
			}
		}

	}

	if ([layerInfo.layer_type isEqualToString:@"1"]) {
		for (BMKPolyline *line in lineOverlayArr) {
			if ([line.title isEqual:layerInfo.data_id]) {
				[self.mapView addOverlay:line];
			}
		}

	}

	if ([layerInfo.layer_type isEqualToString:@"2"]) {
		for (BMKCircle *circle in circleOverlayArr) {
			if ([circle.title isEqual:layerInfo.data_id]) {
				[self.mapView addOverlay:circle];
			}
		}

		for (BMKPolygon *polygon in polygonOverlayArr) {
			if ([polygon.title isEqual:layerInfo.data_id]) {
				[self.mapView addOverlay:polygon];
			}
		}

	}
}


-(void)openMapDiff{

	if (isMapDiffOpne) {
		[mapDiffButton setImage:[UIImage imageNamed:@"btn_coverage"] forState:UIControlStateNormal];
		[UIView animateWithDuration:0.4 animations:^{
			self.mapDiffView.alpha = 0;
		}completion:^(BOOL finished) {
			self.mapDiffView.hidden = YES;
		}];
	}else
		{
		[mapDiffButton setImage:[UIImage imageNamed:@"btn_coverage_selected"] forState:UIControlStateNormal];
		[UIView animateWithDuration:0 animations:^{
			self.mapDiffView.alpha = 1;
		}completion:^(BOOL finished) {
			self.mapDiffView.hidden = NO;
		}];
		}

	if (isSelectSateliteMap) {
		[self.sateliteDiffButton setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"] forState:UIControlStateNormal];
		[self.normalDiffButton setBackgroundImage: [UIImage imageNamed:@"bg_login_textfield"] forState:UIControlStateNormal];
	}else
		{
		[self.normalDiffButton setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"] forState:UIControlStateNormal];
		[self.sateliteDiffButton setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"] forState:UIControlStateNormal];
		}

	isMapDiffOpne = !isMapDiffOpne;
}


-(void)didSelectResultSeacher:(NSNotification *)notification{

	_mapView.delegate = self;
	[self overlayUp];
	NSDictionary *dic = notification.userInfo;
	if ([dic.allKeys containsObject:@"resultMarkerModel"]) {
		NSString *markerId = dic[@"resultMarkerModel"];
		for (CDAnno *anno in AnnoOverlayArr) {
			if ([anno.markerInfo.marker_id isEqual: markerId]) {

				CLLocationCoordinate2D coord = {0};

				coord.longitude = [anno.markerInfo.bd_x floatValue];
				coord.latitude= [anno.markerInfo.bd_y floatValue];

				[self.mapView setMapCenterToScreenPt:CGPointMake(kWidth/2, kHeight/2)];

				[_mapView setCenterCoordinate:coord];

				[self.mapView selectAnnotation:anno animated:YES];
				if (_shouldRegionChangeReCalculate) {
					self.mapView.zoomLevel = self.mapView.zoomLevel + 1;

						self.mapView.centerCoordinate = coord;
					self.mapView.zoomLevel = 21.0f;
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						[self.mapView selectAnnotation:anno animated:YES];
					});
				}

				_overlayTitle.text = anno.markerInfo.title;

				selectedAnno = anno;
				selectedLineInfo = nil;
				selectedZoneInfo = nil;

				[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
				self.addAnnoCenter.hidden = YES;
				isEditting = NO;
				isAddAnno = NO;

				self.overlayNav.hidden = NO;
				self.edti_tool_bar.hidden = NO;

				[self.extendShowTB reloadData];

				[self imagesSetNil:selectedAnno.markerInfo.images];

				if (anno.markerInfo.markerDescription) {
					self.overlayDes.text = anno.markerInfo.markerDescription;
				}else
					{
					self.overlayDes.text = @"无";
					}
				
				[self imageShowDisplay:nil line:nil marker:anno];
				[self overlayUp];

			}
		}
	}else
		if([dic.allKeys containsObject:@"resultLineModel"]){
			for (CDLineInfo *lineInfo in lineDataArr) {
				NSString *lineID = dic[@"resultLineModel"];
				if ([lineInfo.line_id isEqual: lineID]) {
					if (!self.lineAnno) {
						self.lineAnno = [[CDAnno alloc]init];
					}
					CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * lineInfo.line_geometry.apex.count);

					for (int i=0; i<lineInfo.line_geometry.apex.count; i++) {
						CDPoint *point = lineInfo.line_geometry.apex[i];
						coords[i].longitude = [point.lng floatValue];
						coords[i].latitude= [point.lat floatValue];
					}

					_lineAnno.coordinate =coords[lineInfo.line_geometry.apex.count/2];


					[_mapView setCenterCoordinate:_lineAnno.coordinate animated:YES];

					_lineAnno.title = lineInfo.title;

					[_mapView addAnnotation:_lineAnno];

					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						[self.mapView selectAnnotation:_lineAnno animated:YES];
						_lineAnno = nil;
					});

					_overlayTitle.text = lineInfo.title;
					_overlayDes.text = lineInfo.lineDescription;


					selectedAnno = nil;
					selectedLineInfo = lineInfo;
					selectedZoneInfo = nil;

					[self.mapView setMapCenterToScreenPt:CGPointMake(kWidth/2, kHeight/2)];

					[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
					self.addAnnoCenter.hidden = YES;
					isEditting = NO;
					isAddAnno = NO;

					self.overlayNav.hidden = NO;
					self.edti_tool_bar.hidden = NO;


					[self.extendShowTB reloadData];


					[self imagesSetNil:selectedLineInfo.images];


					[self imageShowDisplay:nil line:lineInfo marker:nil];

				}
			}
		}else
			if([dic.allKeys containsObject:@"resultZoneModel"]){

				if (!self.zoneAnno) {
					self.zoneAnno =
					[[CDAnno alloc]init];
				}

				for (CDZoneInfo *zoneInfo in zoneDataArr) {
					NSString *zoneID = dic[@"resultZoneModel"];
					if ([zoneInfo.zone_id isEqual: zoneID]) {





						if (zoneInfo.circle_geometry) {


							CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(zoneInfo.circle_geometry.center.lat.doubleValue, zoneInfo.circle_geometry.center.lng.doubleValue);

							self.zoneAnno.coordinate = coordinate;

							self.zoneAnno.title = zoneInfo.title;

							[_mapView addAnnotation:self.zoneAnno];

							[self.mapView setCenterCoordinate:coordinate animated:YES];

							dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
								[self.mapView selectAnnotation:self.zoneAnno  animated:YES];
									_zoneAnno = nil;
							});


							_overlayTitle.text = zoneInfo.title;
							_overlayDes.text = zoneInfo.zoneDescription;

							[self imageShowDisplay:selectedZoneInfo line:nil marker:nil];

							selectedAnno = nil;
							selectedLineInfo = nil;
							selectedZoneInfo = zoneInfo;

							[self.mapView setMapCenterToScreenPt:CGPointMake(kWidth/2, kHeight/2)];

							[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
							self.addAnnoCenter.hidden = YES;
							isEditting = NO;
							isAddAnno = NO;

							self.overlayNav.hidden = NO;
							self.edti_tool_bar.hidden = NO;

							[self.extendShowTB reloadData];

							[self imagesSetNil:selectedZoneInfo.images];

						}
						if (zoneInfo.zone_geometry) {

							NSArray *array = zoneInfo.zone_geometry.apex;
							CDPoint *pt = array[0];
							CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(pt.lat.doubleValue, pt.lng.doubleValue);

							self.zoneAnno.coordinate = coordinate;

							self.zoneAnno.title = zoneInfo.title;

							[_mapView addAnnotation:self.zoneAnno];

							[self.mapView setCenterCoordinate:coordinate animated:YES];

							dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
								[self.mapView selectAnnotation:self.zoneAnno  animated:YES];
									_zoneAnno = nil;
							});


							_overlayTitle.text = zoneInfo.title;
							_overlayDes.text = zoneInfo.zoneDescription;


							[self imageShowDisplay:selectedZoneInfo line:nil marker:nil];


							selectedAnno = nil;
							selectedLineInfo = nil;
							selectedZoneInfo = zoneInfo;

							[self.mapView setMapCenterToScreenPt:CGPointMake(kWidth/2, kHeight/2)];

							[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
							self.addAnnoCenter.hidden = YES;
							isEditting = NO;
							isAddAnno = NO;

							self.overlayNav.hidden = NO;
							self.edti_tool_bar.hidden = NO;


							[self.extendShowTB reloadData];
							
							
							[self imagesSetNil:selectedZoneInfo.images];


						}
					}
				}
			}
}

-(void)overlayUp{


	self.locateBtn.hidden = NO;
	self.fangdaBtn.hidden = NO;
	self.suoxiaoBtn.hidden = NO;

	if (editRemoveAnno) {
		[_mapView addAnnotation:editRemoveAnno];
		editRemoveAnno = nil;
	}

	[extendAttr removeAllObjects] ;

	[UIView animateWithDuration:overlayDelay animations:^{
		self.mapInfoViewBottom.constant = -50;
		self.overlayInfoViewBottom.constant = overlayHeight;
		self.overlayEditViewBottom.constant = 0;

		self.overlayInfoView.y = kHeight - overlayHeight;
		self.mapInfoView.y = kHeight;
		self.overlayEditView.y = kHeight;
	}];




	self.edti_tool_bar.hidden = NO;

	if (selectedAnno) {
		self.overlayNav.hidden = NO;
	}else
		{
		self.overlayNav.hidden = YES;
		}

	self.overlaySave.hidden = YES;

	self.layerSelectView.hidden =YES;

	self.addAnnoCenter.hidden =YES;
}

-(void)overlayEditUp
{


	self.locateBtn.hidden = NO;
	self.fangdaBtn.hidden = NO;
	self.suoxiaoBtn.hidden = NO;

	if (self.addAnnoCenter.hidden == NO) {
		self.addAnnoCenterY.constant = -15;
	}

	[UIView animateWithDuration:overlayDelay animations:^{
		self.mapInfoViewBottom.constant = -50;
		self.overlayInfoViewBottom.constant = 0;
		self.overlayEditViewBottom.constant = overlayEditHeight;

		self.overlayInfoView.y = kHeight - overlayHeight;
		self.mapInfoView.y = kHeight;
		self.overlayEditView.y = kHeight;
	}];
	self.edti_tool_bar.hidden = YES;
	self.overlayNav.hidden = YES;
	self.overlaySave.hidden = NO;




	if (selectedZoneInfo) {
		[self.deleteAnnoBtn setTitle:@"删除面" forState:UIControlStateNormal];
	}else
		if (selectedLineInfo) {
			[self.deleteAnnoBtn setTitle:@"删除线" forState:UIControlStateNormal];
		}else
			if (selectedAnno) {
				[self.deleteAnnoBtn setTitle:@"删除点" forState:UIControlStateNormal];
			}else
				{
				self.deleteAnnoBtn.hidden = YES;
				}
}

-(void)mapInfoUp{
	[UIView animateWithDuration:overlayDelay animations:^{
		self.mapInfoViewBottom.constant = 0;
		self.overlayInfoViewBottom.constant = 0;
		self.overlayEditViewBottom.constant = 0;

		self.overlayInfoView.y = kHeight;
		self.mapInfoView.y = kHeight - 50;
		self.overlayEditView.y = kHeight;
	}];

	if (editRemoveAnno) {
		[_mapView addAnnotation:editRemoveAnno];
		editRemoveAnno = nil;
	}

	if (isMakeZone || isMakeLine) {
		[self pointStatus2BackMap];

		[imagespost removeAllObjects];
		[_selectedPhotos removeAllObjects];
		[self.upLoadPicBtn setImage:[UIImage imageNamed:@"btn_image"] forState:UIControlStateNormal];
		[self.uploadCount setTitle:nil forState:UIControlStateNormal];

		self.styleShowImageView.image = nil;

		if (isMakeLine) {
			self.closeMakeBtn.hidden =YES;
			self.returnMakeBtn.hidden =YES;
			self.addLinePoint.hidden = YES;
			self.addAnnoCenter.hidden = YES;
			[self addBtnAllShow];

			[self.mapView removeAnnotations:makeLineAnnoArr];
			[makeLineAnnoArr removeAllObjects];
			[self.mapView removeOverlays:makeLineArr];
			[makeLineArr removeAllObjects];

			lineMakeAnno = nil;

			isMakeLine = NO;
			lineTotolDistance = 0;


		}else
			if (isMakeZone) {
				self.closeMakeBtn.hidden =YES;
				self.returnMakeBtn.hidden =YES;
				self.addZonePoint.hidden = YES;
				self.addAnnoCenter.hidden = YES;
				[self addBtnAllShow];

				[self.mapView removeAnnotations:makeZoneAnnoArr];
				[makeZoneAnnoArr removeAllObjects];
				[self.mapView removeOverlays:makeZoneArr];
				[makeZoneArr removeAllObjects];
				[self.mapView removeOverlays:makeLineArr];
				[makeLineArr removeAllObjects];
				

				isMakeZone = NO;
			}

	}

	self.layerSelectView.hidden = YES;
	self.addAnnoCenter.hidden = YES;
	[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];

	[self navOverlayNorChange];




}


-(void)didSelectPOISeacher:(NSNotification *)notification

{
	_mapView.delegate = self;

	selectedAnno = nil;

	BMKPoiInfo *poi_1 = [[notification userInfo] valueForKey:@"poiModel"];

	poi = poi_1;
	BMKMapStatus *status = [[BMKMapStatus alloc]init];

	status.targetGeoPt = poi_1.pt;


	[self.mapView setMapStatus:status withAnimation:YES];


	if (selectedAddLyaerInfo) {
		NSString *str = [NSString stringWithFormat:@"所属图层:%@",selectedAddLyaerInfo.layer_name];

		[self.selectLayerBtn setTitle:str forState:UIControlStateNormal];
	}else
		{
		for (CDLayerInfo *layerInfo in markerLayers) {

			[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerInfo.layer_name] forState:UIControlStateNormal];
			selectedAddLyaerInfo = layerInfo;
		}
		}

	self.deleteAnnoBtn.hidden = YES;
	self.addAnnoCenter.hidden = NO;
	[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_pressed"] forState:UIControlStateNormal];
	self.overlayEditTitle.text = @"";
	self.overlayDes.text = @"";

	[self overlayEditUp];

	self.addAnnoCenter.hidden = NO;
	self.overlayEditTitle.text = poi.name;
}


-(void)overlaySearch
{
	CDSearchOverlay *tb = [[UIStoryboard storyboardWithName:@"CDSearchOverlay" bundle:nil] instantiateInitialViewController];

	tb.layersArr = layersArr;
	[self.navigationController pushViewController:tb animated:YES];

	[mapDiffButton setImage:[UIImage imageNamed:@"btn_coverage"] forState:UIControlStateNormal];
	[UIView animateWithDuration:0.4 animations:^{
		self.mapDiffView.alpha = 0;
	}completion:^(BOOL finished) {
		self.mapDiffView.hidden = YES;
	}];

	isMapDiffOpne = NO;
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{




	self.locateBtn.hidden = YES;
	self.fangdaBtn.hidden =YES;
	self.suoxiaoBtn.hidden = YES;

	[self navEditState3Change];



	self.overlaySave.hidden = YES;
	self.edit_icon_up_image.hidden = YES;

	[UIView animateWithDuration:overlayDelay animations:^{
		self.overlayInfoViewBottom.constant = 0;
		self.overlayEditViewBottom.constant = kHeight -64;
	}];
}






-(void)imagesSetNil:(NSArray *)imageurls
{
	[_selectedPhotos removeAllObjects];
	[imagespost removeAllObjects];
	[_selectedPhotos addObjectsFromArray:imageurls];

	self.uploadCount.titleLabel.text = nil;
	[self.upLoadPicBtn setImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];

	[self.changeAnnoStyle setImage:nil forState:UIControlStateNormal];
	self.styleShowImageView.image = nil;
	self.lineChangeCorlor = nil;
	self.lineAlpha = nil;
	self.lineWidth = nil;


	self.zoneChangeCorlor = nil;
	self.zoneAlpha = nil;
	self.zoneWidth = nil;
	self.zoneLineCorlor = nil;
	self.zoneLineAlpha = nil;



}



- (void)mapView:(BMKMapView *)mapView onClickedBMKOverlayView:(BMKOverlayView *)overlayView
{
	
	if (isMakeLine|| isMakeZone) {
		return;
	}


	selectedAnno = nil;
	selectedZoneInfo = nil;


	[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
	self.addAnnoCenter.hidden = YES;
	isEditting = NO;
	isAddAnno = NO;

	self.overlayNav.hidden = NO;
	self.edti_tool_bar.hidden = NO;

	[self.changeAnnoStyle setTitle:@"线样式" forState:UIControlStateNormal];
	[self overlayUp];

	for (CDLineInfo *lineInfo in lineDataArr) {
		if ([overlayView.overlay.subtitle isEqual: lineInfo.line_id]) {

			CDLog(@"%@",overlayView.overlay.subtitle);
			selectedLineInfo = lineInfo;

			self.overlayTitle.text = lineInfo.title;
			if (lineInfo.lineDescription) {
				self.overlayDes.text = lineInfo.lineDescription;
			}else
				{
				self.overlayDes.text = @"无";
				}

			[self imageShowDisplay:nil line:lineInfo marker:nil];

			if (!self.lineAnno) {
				self.lineAnno = [[CDAnno alloc]init];
			}

			CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * lineInfo.line_geometry.apex.count);
			for (int i=0; i<lineInfo.line_geometry.apex.count; i++) {
				CDPoint *point = lineInfo.line_geometry.apex[i];
				coords[i].longitude = [point.lng floatValue];
				coords[i].latitude= [point.lat floatValue];
			}



			_lineAnno.title = lineInfo.title;
			[self imagesSetNil:selectedLineInfo.images];
			[_mapView addAnnotation:_lineAnno];

			_lineAnno.coordinate =coords[lineInfo.line_geometry.apex.count/2];

			[self.mapView setCenterCoordinate:_lineAnno.coordinate];

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self.mapView selectAnnotation:_lineAnno animated:YES];

				self.lineAnno = nil;

			});


		}
	}
}



-(void)imageShowDisplay:(CDZoneInfo *)zoneInfo line:(CDLineInfo *)
line marker:(CDAnno *)anno
{

	if (zoneInfo) {

		[self.changeAnnoStyle setTitle:@"面样式" forState:UIControlStateNormal];

		if (!zoneInfo.images.count) {

			self.overlayTitlePosition.constant = -40;
			self.overlayPicCount.hidden = YES;
			self.overlayPic.hidden = YES;
		}else
			{
			self.overlayPicCount.hidden = NO;
			self.overlayPic.hidden = NO;

			[self.overlayPicCount setTitle:[NSString stringWithFormat:@"%tu",zoneInfo.images.count] forState:UIControlStateNormal];
			[self.overlayPic sd_setImageWithURL:zoneInfo.images[0] forState:UIControlStateNormal];
			self.overlayTitlePosition.constant = 20;
			}
	}else
		if (line) {

				[self.changeAnnoStyle setTitle:@"线样式" forState:UIControlStateNormal];
			if (!line.images.count) {

				self.overlayTitlePosition.constant = -40;
				self.overlayPicCount.hidden = YES;
				self.overlayPic.hidden = YES;
			}else
				{
				self.overlayPicCount.hidden = NO;
				self.overlayPic.hidden = NO;

				[self.overlayPicCount setTitle:[NSString stringWithFormat:@"%tu",line.images.count] forState:UIControlStateNormal];
				[self.overlayPic sd_setImageWithURL:line.images[0] forState:UIControlStateNormal];
				self.overlayTitlePosition.constant = 20;
				}
		}else
			if (anno) {

	[self.changeAnnoStyle setTitle:@"点样式" forState:UIControlStateNormal];

				if (!anno.markerInfo.images.count) {

					self.overlayTitlePosition.constant = -40;
					self.overlayPicCount.hidden = YES;
					self.overlayPic.hidden = YES;
				}else
					{
					self.overlayPicCount.hidden = NO;
					self.overlayPic.hidden = NO;
					self.overlayTitlePosition.constant = 20;
					[self.overlayPicCount setTitle:[NSString stringWithFormat:@"%tu",anno.markerInfo.images.count] forState:UIControlStateNormal];
					[self.overlayPic sd_setImageWithURL:anno.markerInfo.images[0] forState:UIControlStateNormal];

					}
			}


}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{

	if (isMakeLine || isMakeZone) {
		return;
	}

	if (isMeasureOpen) {
		self.measureLabel.text = @"选择下一个测距点";
		CDAnno *anno = [[CDAnno alloc] init];
		anno.coordinate = coordinate;
		anno.title = @"测距点";

		CDMarkerInfo *markerInfo = [[CDMarkerInfo alloc]init];

		markerInfo.bd_x = [NSString stringWithFormat:@"%f",coordinate.longitude];
		markerInfo.bd_y = [NSString stringWithFormat:@"%f",coordinate.latitude];

		CDMarkerStyle *markerStyle = [[CDMarkerStyle alloc]init];
		markerStyle.icon_url =@"http://a.dituhui.com/images/marker/icon/default/25d748ed9abe1c6b27a1d33b84a851c9.png";
		markerInfo.style = markerStyle;

		anno.markerInfo = markerInfo;

		if (!mesureAnno) {
			anno.title = @"起点";
		}else{

			CLLocationCoordinate2D *coords =
			malloc(sizeof(CLLocationCoordinate2D) * 2);

			coords[0] =mesureAnno.coordinate;
			coords[1] =coordinate;

			BMKPolyline *pline = [BMKPolyline polylineWithCoordinates:coords count:2];

			[_mapView addOverlay:pline];

			[measureLineArr addObject:pline];

			BMKMapPoint point1 = BMKMapPointForCoordinate(mesureAnno.coordinate);
			BMKMapPoint point2 = BMKMapPointForCoordinate(coordinate);

			CLLocationDistance distance =
			 BMKMetersBetweenMapPoints(point1,point2);

			totolDistance +=distance;

			anno.title = [NSString stringWithFormat:@"%0.2f 千米",totolDistance/1000];

		}

		mesureAnno = anno;
		[measureAnnoArr addObject:anno];

		[self.mapView addAnnotation:anno];

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.mapView selectAnnotation:anno animated:YES];
		});


	}else{
	selectLayerBtnOpen = NO;
	_layerSelectView.hidden = YES;
	bool isClickOverLay = NO;
	for (CDZoneInfo *zoneInfo in zoneDataArr) {
		if (zoneInfo.zone_geometry) {
			CLLocationCoordinate2D coords[(zoneInfo.zone_geometry.apex.count)];

			for (int i=0; i<zoneInfo.zone_geometry.apex.count; i++) {
				CDPoint *point = zoneInfo.zone_geometry.apex[i];
				coords[i].latitude = point.lat.doubleValue;
				coords[i].longitude = point.lng.doubleValue;
			}

			if (BMKPolygonContainsCoordinate(coordinate, coords, zoneInfo.zone_geometry.apex.count)) {
				isClickOverLay = YES;

				[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
				self.addAnnoCenter.hidden = YES;
				isEditting = NO;
				isAddAnno  = NO;
				CDLog(@"quyu");
				[self.changeAnnoStyle setTitle:@"面样式" forState:UIControlStateNormal];
				selectedAnno = nil;
				selectedZoneInfo = zoneInfo;
				selectedLineInfo = nil;
				[self imagesSetNil:selectedZoneInfo.images];
				self.overlayTitle.text = zoneInfo.title;
				if (zoneInfo.zoneDescription) {
					self.overlayDes.text = zoneInfo.zoneDescription;
				}else
					{
					self.overlayDes.text = @"无";
					}

				[self imageShowDisplay:zoneInfo line:nil marker:nil];


				self.overlayNav.hidden = NO;
				self.edti_tool_bar.hidden = NO;

				[self overlayUp];


				if (!self.zoneAnno) {
					self.zoneAnno =
					[[CDAnno alloc]init];
				}

				self.zoneAnno .coordinate = coordinate;

				self.zoneAnno .title = zoneInfo.title;

				[_mapView addAnnotation:self.zoneAnno];

				[self.mapView setCenterCoordinate:coordinate];


				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self.mapView selectAnnotation:self.zoneAnno  animated:YES];
					self.zoneAnno = nil;
				});
			}
		}

		if (zoneInfo.circle_geometry) {

			CLLocationCoordinate2D centerCoor = CLLocationCoordinate2DMake(zoneInfo.circle_geometry.center.lat.doubleValue, zoneInfo.circle_geometry.center.lng.doubleValue);

			if (BMKCircleContainsCoordinate(coordinate, centerCoor,zoneInfo.circle_geometry.radius.doubleValue)) {

				self.overlayTitle.text = zoneInfo.title;
				if (zoneInfo.zoneDescription) {
					self.overlayDes.text = zoneInfo.zoneDescription;
				}else
					{
					self.overlayDes.text = @"无";
					}

				[self imageShowDisplay:zoneInfo line:nil marker:nil];



				isClickOverLay = YES;
				[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
				self.addAnnoCenter.hidden = YES;
				isEditting = NO;
				isAddAnno = NO;
				CDLog(@"yuan");
				[self.changeAnnoStyle setTitle:@"面样式" forState:UIControlStateNormal];
				selectedAnno = nil;
				selectedLineInfo = nil;
				selectedZoneInfo = zoneInfo;


				[self imagesSetNil:zoneInfo.images];

				self.overlayNav.hidden = NO;
				self.edti_tool_bar.hidden = NO;

				[self overlayUp];

				if (!self.zoneAnno) {
					self.zoneAnno = [[CDAnno alloc]init];
				}

				CLLocationCoordinate2D centerCoor = CLLocationCoordinate2DMake(zoneInfo.circle_geometry.center.lat.doubleValue, zoneInfo.circle_geometry.center.lng.doubleValue);


				[_zoneAnno setCoordinate:centerCoor];

				[self.mapView setCenterCoordinate:centerCoor] ;

				_zoneAnno.title = zoneInfo.title;

				[_mapView addAnnotation:_zoneAnno];

				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self.mapView selectAnnotation:_zoneAnno animated:YES];
					self.zoneAnno =nil;
				});



			}
		}
	}

	if (isClickOverLay == NO) {

		if (self.overlayEditView.y >= kHeight) {

			[UIView animateWithDuration:overlayDelay animations:^{
//				self.overlayInfoView.y = kHeight;
//				self.mapInfoView.y = kHeight - 50;
				[UIView animateWithDuration:overlayDelay animations:^{
					self.mapInfoViewBottom.constant = 0;
					self.overlayInfoViewBottom.constant = 0;
					self.overlayEditViewBottom.constant = 0;

					self.overlayInfoView.y = kHeight;
					self.mapInfoView.y = kHeight - 50;
					self.overlayEditView.y = kHeight;
				}];
			}];
		}

	}
	}
}


- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi

{

	if (isMakeLine || isMakeZone) {
		return;
	}

	CLLocationCoordinate2D coordinate = mapPoi.pt;
	if (isMeasureOpen) {
		self.measureLabel.text = @"选择下一个测距点";
		CDAnno *anno = [[CDAnno alloc] init];
		anno.coordinate = coordinate;
		anno.title = @"测距点";

		CDMarkerInfo *markerInfo = [[CDMarkerInfo alloc]init];
		markerInfo.bd_x = [NSString stringWithFormat:@"%f",coordinate.longitude];
		markerInfo.bd_y = [NSString stringWithFormat:@"%f",coordinate.latitude];

		CDMarkerStyle *markerStyle = [[CDMarkerStyle alloc]init];
		markerStyle.icon_url =@"http://a.dituhui.com/images/marker/icon/default/25d748ed9abe1c6b27a1d33b84a851c9.png";
		markerInfo.style = markerStyle;

		anno.markerInfo = markerInfo;

		if (!mesureAnno) {
			anno.title = @"起点";
		}else{

			CLLocationCoordinate2D *coords =
			malloc(sizeof(CLLocationCoordinate2D) * 2);

			coords[0] =mesureAnno.coordinate;
			coords[1] =coordinate;

			BMKPolyline *pline = [BMKPolyline polylineWithCoordinates:coords count:2];

			[_mapView addOverlay:pline];

			[measureLineArr addObject:pline];

			BMKMapPoint point1 = BMKMapPointForCoordinate(mesureAnno.coordinate);
			BMKMapPoint point2 = BMKMapPointForCoordinate(coordinate);

			CLLocationDistance distance =
			BMKMetersBetweenMapPoints(point1,point2);

			totolDistance += distance;

			anno.title = [NSString stringWithFormat:@"%0.2f 千米",totolDistance/1000];

		}

		mesureAnno = anno;
		[measureAnnoArr addObject:anno];

		[self.mapView addAnnotation:anno];

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(-.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.mapView selectAnnotation:anno animated:YES];
		});
		
		
	}else{

	selectLayerBtnOpen = NO;
	_layerSelectView.hidden = YES;
	bool isClickOverLay = NO;
	for (CDZoneInfo *zoneInfo in zoneDataArr) {
		if (zoneInfo.zone_geometry) {
			CLLocationCoordinate2D coords[(zoneInfo.zone_geometry.apex.count)];

			for (int i=0; i<zoneInfo.zone_geometry.apex.count; i++) {
				CDPoint *point = zoneInfo.zone_geometry.apex[i];
				coords[i].latitude = point.lat.doubleValue;
				coords[i].longitude = point.lng.doubleValue;
			}

			if (BMKPolygonContainsCoordinate(mapPoi.pt, coords, zoneInfo.zone_geometry.apex.count)) {
				isClickOverLay = YES;

				[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
				self.addAnnoCenter.hidden = YES;
				isEditting = NO;
				isAddAnno = NO;
				CDLog(@"quyu");
				selectedAnno = nil;
				selectedLineInfo =nil;
				selectedZoneInfo = zoneInfo;

				[self imagesSetNil:zoneInfo.images];

				self.overlayTitle.text = zoneInfo.title;
				if (zoneInfo.zoneDescription) {
					self.overlayDes.text = zoneInfo.zoneDescription;
				}else
					{
					self.overlayDes.text = @"无";
					}

				[self imageShowDisplay:zoneInfo line:nil marker:nil];

				self.overlayNav.hidden = NO;
				self.edti_tool_bar.hidden = NO;

				[self overlayUp];


				if (!self.zoneAnno) {
					self.zoneAnno =
					[[CDAnno alloc]init];
				}

				self.zoneAnno .coordinate = mapPoi.pt;

				self.zoneAnno .title = zoneInfo.title;

				[_mapView addAnnotation:self.zoneAnno];

				[self.mapView setCenterCoordinate:mapPoi.pt];


				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self.mapView selectAnnotation:self.zoneAnno  animated:YES];
					self.zoneAnno = nil;
				});
			}
		}

		if (zoneInfo.circle_geometry) {

			CLLocationCoordinate2D centerCoor = CLLocationCoordinate2DMake(zoneInfo.circle_geometry.center.lat.doubleValue, zoneInfo.circle_geometry.center.lng.doubleValue);

			if (BMKCircleContainsCoordinate(mapPoi.pt, centerCoor,zoneInfo.circle_geometry.radius.doubleValue)) {

				self.overlayTitle.text = zoneInfo.title;
				if (zoneInfo.zoneDescription) {
					self.overlayDes.text = zoneInfo.zoneDescription;
				}else
					{
					self.overlayDes.text = @"无";
					}


				[self imageShowDisplay:zoneInfo line:nil marker:nil];

				isClickOverLay = YES;
				[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];
				self.addAnnoCenter.hidden = YES;
				isEditting = NO;
				isAddAnno = NO;
				CDLog(@"yuan");

				[self imagesSetNil:zoneInfo.images];
				selectedAnno = nil;
				selectedLineInfo =nil;
				selectedZoneInfo = zoneInfo;

				self.overlayNav.hidden = NO;
				self.edti_tool_bar.hidden = NO;

				[self overlayUp];
				if (!self.zoneAnno) {
					self.zoneAnno = [[CDAnno alloc]init];
				}

				CLLocationCoordinate2D centerCoor = CLLocationCoordinate2DMake(zoneInfo.circle_geometry.center.lat.doubleValue, zoneInfo.circle_geometry.center.lng.doubleValue);


				[_zoneAnno setCoordinate:centerCoor];

				[self.mapView setCenterCoordinate:centerCoor] ;

				_zoneAnno.title = zoneInfo.title;

				[_mapView addAnnotation:_zoneAnno];

				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self.mapView selectAnnotation:_zoneAnno animated:YES];
					self.zoneAnno = nil;
				});

			}
		}
	}

	if (isClickOverLay == NO) {
		if (self.overlayEditView.y >= kHeight) {
			[UIView animateWithDuration:overlayDelay animations:^{
				self.overlayInfoView.y = kHeight;
				self.mapInfoView.y = kHeight - 50;
			}];
		}
	}
	}
}


-(void)Actiondo:(UITapGestureRecognizer *)sender{
	CGPoint point = [sender locationInView:self.overlayInfoView];
	CDLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);

	CGFloat pointNor = (kHeight - overlayHeight)/2  ;//2

	if (self.overlayInfoView.y == kHeight -overlayHeight) {
		if (point.y <overlayHeight && point.y >0) {
			[UIView animateWithDuration:overlayDelay // 动画时长
							 animations:^{
								 self.overlayInfoView.y = pointNor;
								 self.locateBtn.hidden = YES;
								 self.fangdaBtn.hidden = YES;
								 self.suoxiaoBtn.hidden = YES;
								 [self pointInfoChangeMap];
							 }];
			self.icon_up_image.hidden = YES;
		}
	}else
		if (self.overlayInfoView.y == pointNor) {
			if (point.y <overlayHeight && point.y >0) {
				[UIView animateWithDuration:overlayDelay // 动画时长
								 animations:^{
									 self.overlayInfoView.y = kHeight -overlayHeight;

									 [self pointStatus2BackMap];
								 }completion:^(BOOL finished) {
									 self.locateBtn.hidden = NO;
									 self.fangdaBtn.hidden = NO;
									 self.suoxiaoBtn.hidden = NO;
								 }];
				self.icon_up_image.hidden = NO;
			}
		}
}


-(void)ActiondoEdit:(UITapGestureRecognizer *)sender{
	CGPoint point = [sender locationInView:self.overlayEditView];
	CDLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);

	CGFloat pointNor = (kHeight - overlayEditHeight)/2 ;

	if (self.overlayEditView.y == kHeight -overlayEditHeight) {


		if (point.y <overlayEditHeight && point.y >0) {
			[UIView animateWithDuration:overlayDelay
							 animations:^{
								 self.overlayEditView.y = pointNor;
								 self.overlayEditViewBottom.constant = kHeight-pointNor;
									 //                                 self.overlayEditView.y = pointNor;
								 self.locateBtn.hidden = YES;
								 self.fangdaBtn.hidden = YES;
								 self.suoxiaoBtn.hidden = YES;

								 [self pointStatus2ChangeMap];
							 }];
			self.edit_icon_up_image.hidden = YES;
		}

	}else

		if (self.overlayEditView.y == pointNor) {
			if (point.y <overlayEditHeight && point.y >0) {
				[UIView animateWithDuration:overlayDelay
								 animations:^{
									 self.overlayEditView.y = kHeight -overlayEditHeight;
									 self.overlayEditViewBottom.constant = overlayEditHeight
									 ;
									 self.locateBtn.hidden = NO;
									 self.fangdaBtn.hidden = NO;
									 self.suoxiaoBtn.hidden = NO;


									 [self  pointStatus2BackMap];

								 }];
				self.edit_icon_up_image.hidden = NO;
			}
		}
}

-(void)pointInfoChangeMap{
	[self.mapView setMapCenterToScreenPt:CGPointMake(kWidth/2, (kHeight - (kHeight - overlayHeight)/2-64)/2  +64)];

	self.extendShowTB.userInteractionEnabled = NO;
}



-(void)pointStatus2ChangeMap
{
	[self.mapView setMapCenterToScreenPt:CGPointMake(kWidth/2, ((kHeight - (kHeight - overlayEditHeight)/2 -64)/2 +64))];

	if (self.addAnnoCenter.hidden == NO) {
		self.addAnnoCenterY.constant = -(kHeight/2 -  ((kHeight - (kHeight - overlayEditHeight)/2 -64)/2 +64))-15;
	}

	self.extendEditTB.userInteractionEnabled = NO;

}
-(void)pointStatus2BackMap
{
	[self.mapView setMapCenterToScreenPt:CGPointMake(kWidth/2, kHeight/2)];
	if (self.addAnnoCenter.hidden == NO) {
		self.addAnnoCenterY.constant = -15;
	}

}


- (void) doHandlePanActionEdit:(UIPanGestureRecognizer *)paramSender{


	[[UIApplication sharedApplication].keyWindow endEditing:YES];

	CGPoint pointEdit = [paramSender translationInView:self.overlayEditView];

	paramSender.view.y = paramSender.view.y +pointEdit.y;
	CDLog(@"%f",  pointEdit.y);

	[paramSender setTranslation:CGPointMake(0,0) inView:self.view];

	CGFloat point0 = 64;//1

		//    CGFloat point1 = (kHeight-64)/4 +64;

	CGFloat point2 = (kHeight - overlayEditHeight)/2 ;//2

		//    CGFloat point3 = (kHeight -64)/4 *3  +64;

	CGFloat point4 = kHeight - overlayEditHeight;//3


	if (paramSender.view.y >=point4) {
		paramSender.view.y = point4;
		self.locateBtn.hidden = NO;
		self.fangdaBtn.hidden =NO;
		self.suoxiaoBtn.hidden = NO;
		self.title = @"";
		self.overlaySave.hidden = NO;
		self.edit_icon_up_image.hidden = YES;

		[self navOverlayNorChange];


	}else

		if (paramSender.view.y <= 64) {
			paramSender.view.y = 64;

			self.locateBtn.hidden = YES;
			self.fangdaBtn.hidden =YES;
			self.suoxiaoBtn.hidden = YES;


			[self navEditState3Change];



			self.overlaySave.hidden = YES;
			self.edit_icon_up_image.hidden = YES;



		}else

			if (paramSender.view.y < point2 && paramSender.view.y>point0) {
				if (editPointY > 0 && pointEdit.y ==0) {

					selectLayerBtnOpen = NO;
					self.layerSelectView.hidden = YES;
					[UIView animateWithDuration:overlayDelay
									 animations:^{
										 paramSender.view.y = point2;
										 self.locateBtn.hidden = YES;
										 self.fangdaBtn.hidden =YES;
										 self.suoxiaoBtn.hidden = YES;

									 }];
					self.title = @"";
					self.overlaySave.hidden = NO;
					self.edit_icon_up_image.hidden = YES;

					[self navOverlayNorChange];



				}else

					if (editPointY < -2 && pointEdit.y == 0) {

						[UIView animateWithDuration:overlayDelay
										 animations:^{
											 paramSender.view.y = point0;
											 self.locateBtn.hidden = YES;
											 self.fangdaBtn.hidden =YES;
											 self.suoxiaoBtn.hidden = YES;


										 }];
						[self navEditState3Change];



						self.overlaySave.hidden = YES;
						self.edit_icon_up_image.hidden = YES;
					}


			}else

				if (paramSender.view.y < point4 && paramSender.view.y>=point2) {
					selectLayerBtnOpen = NO;
					self.layerSelectView.hidden = YES;
					if (editPointY > 2 && pointEdit.y ==0) {

						[UIView animateWithDuration:overlayDelay
										 animations:^{
											 paramSender.view.y = point4;

											 self.overlayEditViewBottom.constant = kHeight - point4;

											 self.locateBtn.hidden = NO;
											 self.fangdaBtn.hidden =NO;
											 self.suoxiaoBtn.hidden =NO;

											 [self pointStatus2BackMap];

										 }];

						self.edit_icon_up_image.hidden =NO;


						[self navOverlayNorChange];

					}else

						if (editPointY < 0 && pointEdit.y == 0) {

							[UIView animateWithDuration:overlayDelay
											 animations:^{
												 paramSender.view.y = point2;
												 self.overlayEditViewBottom.constant = kHeight-point2;
												 self.locateBtn.hidden = YES;
												 self.fangdaBtn.hidden =YES;
												 self.suoxiaoBtn.hidden = YES;

												 [self pointStatus2ChangeMap];


											 }];

							self.edit_icon_up_image.hidden =YES;
						}

					self.title = @"";
					self.overlaySave.hidden = NO;


					[self navOverlayNorChange];

				}
	editPointY = pointEdit.y;
}


- (void)doHandlePanAction:(UIPanGestureRecognizer *)paramSender{

	CGPoint point = [paramSender translationInView:self.overlayInfoView];

	paramSender.view.y = paramSender.view.y +point.y;
//	CDLog(@"%f", point.y);

	[paramSender setTranslation:CGPointMake(0,0) inView:self.view];

	CGFloat point0 = 64;//1

		//    CGFloat point1 = (kHeight-64)/4 +64;

	CGFloat point2 = (kHeight - overlayHeight)/2;//2

		//    CGFloat point3 = (kHeight -64)/4 *3  +64;

	CGFloat point4 = kHeight - overlayHeight;//3


	if (paramSender.view.y >=point4) {
		paramSender.view.y = point4;
		self.locateBtn.hidden = NO;
		self.fangdaBtn.hidden =NO;
		self.suoxiaoBtn.hidden = NO;
		self.title = @"";
		self.overlayNav.hidden = NO;
		self.icon_up_image.hidden = YES;

		[self navOverlayNorChange];

	}else

		if (paramSender.view.y <= 64) {
			paramSender.view.y = 64;
			self.extendShowTB.userInteractionEnabled = YES;


			self.locateBtn.hidden = YES;
			self.fangdaBtn.hidden =YES;
			self.suoxiaoBtn.hidden = YES;
			self.title = @"详情";

			[self navOverlayState3Change];



			self.overlayNav.hidden = YES;
			self.icon_up_image.hidden = YES;


		}else

			if (paramSender.view.y < point2 && paramSender.view.y>point0) {
				if (pointy > 0 && point.y ==0) {
					[UIView animateWithDuration:overlayDelay
									 animations:^{
										 paramSender.view.y = point2;
										 self.locateBtn.hidden = YES;
										 self.fangdaBtn.hidden =YES;
										 self.suoxiaoBtn.hidden = YES;
									 }];
					self.title = @"";
					self.overlayNav.hidden = NO;
					self.icon_up_image.hidden = YES;

					[self navOverlayNorChange];


				}else
					if (pointy < -2 && point.y == 0) {

						[UIView animateWithDuration:overlayDelay
										 animations:^{
											 paramSender.view.y = point0;
											 self.locateBtn.hidden = YES;
											 self.fangdaBtn.hidden =YES;
											 self.suoxiaoBtn.hidden = YES;
										 }];
						self.title = @"详情";


						[self navOverlayState3Change];

						self.overlayNav.hidden = YES;
						self.icon_up_image.hidden = YES;
					}


			}else

				if (paramSender.view.y < point4 && paramSender.view.y>point2) {

					if (pointy > 2 && point.y ==0) {

						[UIView animateWithDuration:overlayDelay
										 animations:^{
											 paramSender.view.y = point4;
											 self.locateBtn.hidden = NO;
											 self.fangdaBtn.hidden =NO;
											 self.suoxiaoBtn.hidden =NO;
											 [self pointStatus2BackMap];
										 }];

						self.icon_up_image.hidden =NO;


						[self navOverlayNorChange];

					}else

						if (pointy < 0 && point.y == 0) {
							self.icon_up_image.hidden =YES;

							[UIView animateWithDuration:overlayDelay
											 animations:^{
												 paramSender.view.y = point2;
												 self.locateBtn.hidden = YES;
												 self.fangdaBtn.hidden =YES;
												 self.suoxiaoBtn.hidden = YES;

												 [self pointInfoChangeMap];
											 }];

						}
					self.title = @"";
					self.overlayNav.hidden = NO;

					[self navOverlayNorChange];

				}else{
					CDLog(@"不在区域中");
				}

	pointy = point.y;
}

- (UIColor *) stringTOColor:(NSString *)str alpha:(NSString *)alpha
{
	if (!str || [str isEqualToString:@""]) {
		return nil;
	}
	unsigned red,green,blue;
	NSRange range;
	range.length = 2;
	range.location = 1;
	[[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
	range.location = 3;
	[[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
	range.location = 5;
	[[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
	UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha.floatValue];
	return color;
}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{

	if ([overlay isKindOfClass:[BMKCircle class]]){

		BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];

		for (CDZoneInfo *zoneInfo in zoneDataArr) {

			CDLog(@"%@",circleView.overlay.subtitle);

			if (zoneInfo.zone_id == circleView.overlay.subtitle) {

				circleView.fillColor = [self stringTOColor:zoneInfo.style.fill_color alpha:zoneInfo.style.fill_opacity];
				circleView.strokeColor = [self stringTOColor:zoneInfo.style.stroke_color alpha:zoneInfo.style.stroke_opacity];

				circleView.lineWidth = zoneInfo.style.stroke_weight.floatValue;
			}

		}
		return circleView;
	}


	if ([overlay isKindOfClass:[BMKPolygon class]]){

		BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];

		if (isMakeZone) {
//			polygonView.fillColor = [self stringTOColor:@"#ede8e4" alpha:@"0.5"];

			polygonView.fillColor = [UIColor redColor];

			polygonView.strokeColor = [self stringTOColor:@"#3ca0d3" alpha:@"1"];
			polygonView.lineWidth = 3.0f;
		}

		for (CDZoneInfo *zoneInfo in zoneDataArr) {
			if ([zoneInfo.zone_id isEqual: polygonView.overlay.subtitle]) {
				polygonView.fillColor = [self stringTOColor:zoneInfo.style.fill_color alpha:zoneInfo.style.fill_opacity];

				polygonView.strokeColor = [self stringTOColor:zoneInfo.style.stroke_color alpha:zoneInfo.style.stroke_opacity];
				polygonView.lineWidth = zoneInfo.style.stroke_weight.floatValue;
			}
		}
		return polygonView;
	}

	if ([overlay isKindOfClass:[BMKPolyline class]]){
		BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];


		if (isMakeLine && lineMakeAnno) {
			polylineView.strokeColor = [UIColor redColor];
			polylineView.lineWidth = 2.0f;
		}

		if (isMakeZone) {
			polylineView.strokeColor = [UIColor redColor];
			polylineView.lineWidth = 2.0f;
		}

		if (isMeasureOpen && mesureAnno) {

			polylineView.strokeColor = [UIColor redColor];
			polylineView.lineWidth = 2.0f;

		}else{

		for (CDLineInfo *lineInfo in lineDataArr) {

			if ([lineInfo.line_id isEqual: polylineView.overlay.subtitle]) {

		polylineView.strokeColor = [self stringTOColor:lineInfo.style.color alpha:lineInfo.style.opacity];
		polylineView.lineWidth = lineInfo.style.weight.floatValue;
				polylineView.lineDash =	YES;

				if ([lineInfo.style.line_type isEqual:@"1"]) {
					polylineView.lineDash = YES;
				}else{
					polylineView.lineDash = NO;
				}

			}
		}

		}
		return polylineView;

	}
	return nil;
}


//-(void)mapViewDidFinishLoading:(BMKMapView *)mapView {
//	[self updateClusters];
//}


//- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
//	if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel) {
//		[self updateClusters];
//	}
//}


-(void)closeMap{

	[req cancel];
//	req = nil;
	self.mapView.delegate = nil;

//	[manager1.operationQueue cancelAllOperations];

//	manager1 = nil;
//	__weak mapViewController *this
// = self;


//		[SVProgressHUD dismiss];

	if (self.isNewMap) {
		[self dismissViewControllerAnimated:YES completion:nil];

	}else{

//		__weak typeof(self)mySelf = self;
		self.changedMapTitle(self.mapTitle.text);

		[self dismissViewControllerAnimated:YES completion:nil];
	}
//	this = nil;
	[[NSNotificationCenter defaultCenter]postNotificationName:CDLoadedNewMap object:nil];





}

-(void)mapInfoViewClick{
	mapDetailViewController *mapDetailVC = [[UIStoryboard storyboardWithName:@"mapDetailViewController" bundle:nil]instantiateInitialViewController];
	mapDetailVC.mapInfo = self.mapInfo;

	mapDetailVC.pass_title = ^(NSString *pass_title){
		self.mapTitle.text = pass_title;
		self.mapInfo.title = pass_title;
	};
	[self.navigationController pushViewController:mapDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
		// Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
	[_mapView viewWillAppear];
	_mapView.delegate = self;
	_locService.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
	[_mapView viewWillDisappear];
	_mapView.delegate = nil;

}


- (IBAction)overlayNavClick:(UIButton *)sender {
	isClickNav = YES;
	_locService = [[BMKLocationService alloc]init];
	_locService.delegate = self;
	[_locService startUserLocationService];

}


- (IBAction)copyMapLink:(id)sender {

	self.moreView.hidden = YES;
	isMoreOpen = NO;

	if ([self.mapInfo.rating isEqual:@"0"]) {
		[SVProgressHUD showErrorWithStatus:@"地图分享关闭，请在地图信息设置中打开"];
	}else{

		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

		CDAcount *account = [CDAcount accountFromSandbox];

		[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
		[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

		NSMutableDictionary *dic = [NSMutableDictionary dictionary];

		dic[@"map_id"] = self.mapInfo.map_id;

		[manager GET:[NSString stringWithFormat:@"%@phone/map/shareurl",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

			if ([responseObject[@"status"] isEqual:@1]) {
				[SVProgressHUD showSuccessWithStatus:@"已成功复制到剪切板"];
				UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
				pasteboard.string = responseObject[@"result"];
			}else{
				[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
			}


		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			CDLog(@"%@",error);
			[SVProgressHUD showErrorWithStatus:@"网络错误"];
		}];



	}

	
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

	[_mapView updateLocationData:userLocation];

	if (isClickNav) {
		BMKOpenDrivingRouteOption *option = [[BMKOpenDrivingRouteOption alloc]init];

		BMKPlanNode* start = [[BMKPlanNode alloc]init];


		start.pt = userLocation.location.coordinate;

		start.name = userLocation.title;

		option.startPoint = start;

		BMKPlanNode* end = [[BMKPlanNode alloc]init];

		CLLocationCoordinate2D coor2;
		coor2.latitude = [selectedAnno.markerInfo.bd_y doubleValue];
		coor2.longitude = [selectedAnno.markerInfo.bd_x doubleValue];
		end.pt = coor2;

		end.name = selectedAnno.markerInfo.title;


		option.endPoint = end;

		[BMKOpenRoute openBaiduMapDrivingRoute:option];
		_locService.delegate = nil;
		isClickNav = NO;
	}

}


- (void)didStopLocatingUser
{
	NSLog(@"stop locate");
}


- (void)didFailToLocateUserWithError:(NSError *)error
{
	NSLog(@"location error");
}
- (IBAction)map_locate:(UIButton *)sender {

	BOOL enable=[CLLocationManager locationServicesEnabled];

	int status=[CLLocationManager authorizationStatus];
	if(enable && status>=3)  {
		_locService = [[BMKLocationService alloc]init];
		_locService.delegate = self;

			//    static dispatch_once_t onceToken;
			//    dispatch_once(&onceToken, ^{
		[_locService startUserLocationService];
		_mapView.showsUserLocation = NO;
		_mapView.userTrackingMode = BMKUserTrackingModeFollow;
		_mapView.showsUserLocation = YES;
	}else
		{
		if (_locService ==nil) {
			_locService = [[BMKLocationService alloc]init];
			_locService.delegate = self;
		}else{
			UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"打开定位开关" message:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】"preferredStyle:UIAlertControllerStyleAlert];

			[alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
				[alertVC dismissViewControllerAnimated:YES completion:nil];
			}]];

			[alertVC addAction:[UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
			}]];
			[self presentViewController:alertVC animated:YES completion:nil];
		}
		}
}

- (IBAction)map_fangda:(UIButton *)sender {
	float level =  self.mapView.zoomLevel;
	if (3.0 < level <19.0) {
		self.mapView.zoomLevel = self.mapView.zoomLevel + 1.0;
	}

}

- (IBAction)map_suoxiao:(UIButton *)sender {

	float level =  self.mapView.zoomLevel;
	if (3.0 < level <19.0) {
		self.mapView.zoomLevel = self.mapView.zoomLevel - 1.0;
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



- (IBAction)overlayInfoEditClick:(UIButton *)sender {

	isEditting = YES;
	isAddAnno = NO;

	self.deleteAnnoBtn.hidden = NO;

	[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_pressed"] forState:UIControlStateNormal];

	self.overlayNav.hidden = YES;
	self.edti_tool_bar.hidden = YES;
	self.overlaySave.hidden = NO;



	self.overlayEditTitle.text = self.overlayTitle.text;
	self.overlayEditDes.text = self.overlayDes.text;

	if (selectedAnno) {

		[self.styleShowImageView setImage: nil];
		self.styleShowImageView.layer.borderWidth = 0;

		[_mapView setCenterCoordinate:CLLocationCoordinate2DMake([selectedAnno.markerInfo.bd_y doubleValue], [selectedAnno.markerInfo.bd_x doubleValue]) animated:YES];

		editRemoveAnno = selectedAnno;

		[_mapView removeAnnotation:selectedAnno];



		self.addAnnoCenter.hidden = NO;

		if (selectedAnno.markerInfo.images.count) {
			[self.upLoadPicBtn sd_setImageWithURL:[NSURL URLWithString:selectedAnno.markerInfo.images[0]] forState:UIControlStateNormal];
			[self.uploadCount setTitle:[NSString stringWithFormat:@"%tu",selectedAnno.markerInfo.images.count] forState:UIControlStateNormal];
		}

	}else if(selectedLineInfo)
		{

		UIImage *image = [[UIImage imageNamed:@"icon_face_line"] rt_tintedImageWithColor:[self getColor:selectedLineInfo.style.color alpha:selectedLineInfo.style.opacity]  level:1.0f];
		[self.styleShowImageView setImage:image];

		self.styleShowImageView.layer.borderWidth = 0;

		if (selectedLineInfo.images.count) {
			[self.upLoadPicBtn sd_setImageWithURL:[NSURL URLWithString:selectedLineInfo.images[0]] forState:UIControlStateNormal];

			[self.uploadCount setTitle:[NSString stringWithFormat:@"%tu",selectedLineInfo.images.count] forState:UIControlStateNormal];
		}

		}else if(selectedZoneInfo)
			{

			UIImage *image = [[UIImage imageNamed:@"icon_face"] rt_tintedImageWithColor:[self getColor:selectedZoneInfo.style.fill_color alpha:selectedZoneInfo.style.fill_opacity]  level:1.0f];
			[self.styleShowImageView setImage:image];
			self.styleShowImageView.layer.borderWidth = 2.0f;
			self.styleShowImageView.layer.borderColor = [self stringTOColor:selectedZoneInfo.style.stroke_color alpha:selectedZoneInfo.style.stroke_opacity].CGColor;



			if (selectedZoneInfo.images.count) {
				[self.upLoadPicBtn sd_setImageWithURL:[NSURL URLWithString:selectedZoneInfo.images[0]] forState:UIControlStateNormal];

				[self.uploadCount setTitle:[NSString stringWithFormat:@"%tu",selectedZoneInfo.images.count] forState:UIControlStateNormal];


			}
			}


	for (CDLayerInfo *layerinfo in layersArr) {

		if ([layerinfo.layer_type isEqual:@"0"]) {
			if ([selectedAnno.markerInfo.data_id isEqual:layerinfo.data_id]) {

				[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerinfo.layer_name ]forState:UIControlStateNormal];
				selectedInfoLyaerInfo = layerinfo;
			}
		}

		if ([layerinfo.layer_type isEqual:@"1"]) {
			if ([selectedLineInfo.data_id isEqual:layerinfo.data_id]) {
				[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerinfo.layer_name] forState:UIControlStateNormal];
				selectedInfoLyaerInfo = layerinfo;
			}
		}

		if ([layerinfo.layer_type isEqual:@"2"]) {
			if ([selectedZoneInfo.data_id isEqual:layerinfo.data_id]) {
				[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerinfo.layer_name ]forState:UIControlStateNormal];
				selectedInfoLyaerInfo = layerinfo;
			}
		}
	}

	[self.extendEditTB reloadData];
	[self overlayEditUp];
}


- (IBAction)addAnnoClick:(UIButton *)sender {
	if (isEditting) {


		if (editRemoveAnno) {
			[_mapView addAnnotation:editRemoveAnno];
			editRemoveAnno = nil;
		}


		self.layerSelectView.hidden = YES;
		self.addAnnoCenter.hidden = YES;
		[sender setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];

		[[UIApplication sharedApplication].keyWindow endEditing:YES];

		if ([self.overlayTitle.text  isEqual: @"Label"] || self.overlayTitle.text == nil || selectedAnno == nil) {

			self.edti_tool_bar.hidden = YES;
			[self mapInfoUp];
		}else
			{
			self.edti_tool_bar.hidden =NO;
			[self overlayUp];
			}
	}

	if (!isEditting) {

		isAddAnno = YES;


		[self.mapView deselectAnnotation:selectedAnno animated:YES];
		selectedAnno = nil;
		selectedLineInfo = nil;
		selectedZoneInfo = nil;

		_selectedPhotos = nil;


		[self.changeAnnoStyle setTitle:@"点样式" forState:UIControlStateNormal];

		if (selectedAddLyaerInfo) {

			[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",selectedAddLyaerInfo.layer_name ]forState:UIControlStateNormal];
		}else
			{
			if (markerLayers.count) {
				CDLayerInfo *layerInfo = markerLayers[0];

				[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerInfo.layer_name] forState:UIControlStateNormal];
				selectedAddLyaerInfo = layerInfo;
			}

			}

		[self.upLoadPicBtn setImage:[UIImage imageNamed:@"btn_image"] forState:UIControlStateNormal];
		[self.uploadCount setTitle:nil forState:UIControlStateNormal];


		self.overlayEditTitle.text = @"";
		self.overlayEditDes.text = @"";
		[self.extendEditTB reloadData];

		self.deleteAnnoBtn.hidden = YES;
		self.addAnnoCenter.hidden = NO;
		[sender setImage:[UIImage imageNamed:@"btn_coordinate_pressed"] forState:UIControlStateNormal];


		[self overlayEditUp];
	}
	isEditting = !isEditting;
}


-(void)poiAddAnno{
	if (self.overlayEditTitle.text.length == 0) {
		[SVProgressHUD showErrorWithStatus:@"请输入标题……"];
	}else{
		[SVProgressHUD showWithStatus:@"正在添加点标注……"];
		NSMutableDictionary *dic =[NSMutableDictionary dictionary];
		CDAcount *account = [CDAcount accountFromSandbox];

		dic[@"data_id"] = selectedAddLyaerInfo.data_id;
		dic[@"user_id"] = account.user_id;
		dic[@"team_id"] = self.mapInfo.team_id;
		dic[@"title"] = poi.name;
		dic[@"bd_x"] = [NSString stringWithFormat:@"%f",self.mapView.centerCoordinate.longitude];
		dic[@"bd_y"] = [NSString stringWithFormat:@"%f",self.mapView.centerCoordinate.latitude];
		dic[@"description"] = self.overlayEditDes.text;


		dic[@"icon_url"] = self.finalStr;

		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
		[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
		[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
		[manager POST:[NSString stringWithFormat:@"%@phone/marker/add",baseUrl] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
			if (imagespost.count) {
				for (UIImage *image in imagespost) {
					NSData *iamgeData = UIImageJPEGRepresentation(image, 0.5);

					[formData appendPartWithFileData:iamgeData name:@"file" fileName:@"a.jpg" mimeType:@"image/jpeg"];
				}

			}

		} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

			self.finalStr = nil;

			self.layerSelectView.hidden = YES;
			[SVProgressHUD dismiss];
			CDMarkerInfo *markerInfo = [CDMarkerInfo mj_objectWithKeyValues:responseObject[@"result"]];

			editRemoveAnno = nil;

			CDAnno* annotation = [[CDAnno alloc]init];
			CLLocationCoordinate2D coor;
			coor.latitude = markerInfo.bd_y.floatValue;
			coor.longitude = markerInfo.bd_x.floatValue;
			annotation.coordinate = coor;
			annotation.title = markerInfo.title;

			annotation.markerInfo = markerInfo;
			[self.mapView addAnnotation:annotation];


			[AnnoOverlayArr addObject:annotation];


			BMKMapStatus *status = [[BMKMapStatus alloc]init];

			status.targetGeoPt = CLLocationCoordinate2DMake(markerInfo.bd_y.doubleValue, markerInfo.bd_x.doubleValue);

			[self.mapView setMapStatus:status withAnimation:YES];
			[self.mapView selectAnnotation:annotation animated:YES];


			selectedAnno = annotation;

			self.overlayTitle.text = markerInfo.title;
			self.overlayDes.text = markerInfo.markerDescription;

			self.overlayNav.hidden =NO;
			self.overlaySave.hidden = YES;
			self.edti_tool_bar.hidden = NO;

			if (markerInfo.images.count) {
				[self editToShowImage:markerInfo.images];
			}

			[self overlayUp];
			poi = nil;

		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			CDLog(@"%@",error);
			poi = nil;
			[SVProgressHUD showErrorWithStatus:@"网络错误"];
		}];
	}
}

-(void)addAnnoMethod
{
	[SVProgressHUD showWithStatus:@"正在添加点标注……"];
	NSMutableDictionary *dic =[NSMutableDictionary dictionary];
	CDAcount *account = [CDAcount accountFromSandbox];

	dic[@"data_id"] = selectedAddLyaerInfo.data_id;
	dic[@"user_id"] = account.user_id;
	dic[@"team_id"] = self.mapInfo.team_id;
	dic[@"title"] = self.overlayEditTitle.text;
	dic[@"bd_x"] = [NSString stringWithFormat:@"%f",self.mapView.centerCoordinate.longitude];
	dic[@"bd_y"] = [NSString stringWithFormat:@"%f",self.mapView.centerCoordinate.latitude];
	dic[@"description"] = self.overlayEditDes.text;
	dic[@"icon_url"] = self.finalStr;


	if (extendAttr.allKeys.count) {
		for (int i = 0; i<extendAttr.allKeys.count; i++) {
			dic[extendAttr.allKeys[i]] = extendAttr.allValues[i];
		}
	}

	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];

	[manager POST:[NSString stringWithFormat:@"%@marker/add",baseUrl] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		if (imagespost.count) {
			for (UIImage *image in imagespost) {
				NSData *iamgeData = UIImageJPEGRepresentation(image, 0.5);

				[formData appendPartWithFileData:iamgeData name:@"file" fileName:@"a.jpg" mimeType:@"image/jpeg"];
			}

		}

	} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {


		self.finalStr = nil;

		self.layerSelectView.hidden = YES;
		[SVProgressHUD dismiss];
		CDMarkerInfo *markerInfo = [CDMarkerInfo mj_objectWithKeyValues:responseObject[@"result"]];

		for (CDLayerInfo *layerInfo in layersArr) {
			if ([layerInfo.layer_type isEqualToString:@"0"]) {
				if ([markerInfo.data_id isEqual: layerInfo.data_id]) {
					NSMutableArray *array = [NSMutableArray array];
					[array addObjectsFromArray:layerInfo.datas];
					[array addObject:markerInfo];
					layerInfo.datas = array;
				}
			}
		}

		if (markerInfo.images.count) {
			[self editToShowImage:markerInfo.images];
		}

		CDAnno* annotation = [[CDAnno alloc]init];
		CLLocationCoordinate2D coor;
		coor.latitude = markerInfo.bd_y.floatValue;
		coor.longitude = markerInfo.bd_x.floatValue;
		annotation.coordinate = coor;
		annotation.title = markerInfo.title;

		annotation.markerInfo = markerInfo;

		[AnnoOverlayArr addObject:annotation];
		[self.mapView addAnnotation:annotation];

		selectedAnno.markerInfo = markerInfo;
		selectedAnno.title = markerInfo.title;


		BMKMapStatus *status = [[BMKMapStatus alloc]init];

		status.targetGeoPt = CLLocationCoordinate2DMake(markerInfo.bd_y.doubleValue, markerInfo.bd_x.doubleValue);

		[self.mapView setMapStatus:status withAnimation:YES];
		[self.mapView selectAnnotation:annotation animated:YES];

		self.overlayTitle.text = markerInfo.title;
		self.overlayDes.text = markerInfo.markerDescription;

		self.overlayNav.hidden =NO;
		self.overlaySave.hidden = YES;
		self.edti_tool_bar.hidden = NO;

		[self overlayUp];

	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];

}



-(void)annoValueChange
{
	if (self.overlayEditTitle.text.length ==0) {
		[SVProgressHUD showErrorWithStatus:@"请输入标题"];
	}else{
		[SVProgressHUD showWithStatus:@"正在修改……"];
		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

		CDAcount *account = [CDAcount accountFromSandbox];

		[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
		[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
		NSMutableDictionary *dic = [NSMutableDictionary dictionary];
		dic[@"marker_id"] = selectedAnno.markerInfo.marker_id;
		dic[@"title"] = self.overlayEditTitle.text;
		dic[@"description"] = self.overlayEditDes.text;
		dic[@"data_id"] = selectedInfoLyaerInfo.data_id;
		dic[@"icon_url"] = self.finalStr;
		dic[@"bd_x"] = [NSString stringWithFormat:@"%f",self.mapView.centerCoordinate.longitude];
		dic[@"bd_y"] = [NSString stringWithFormat:@"%f",self.mapView.centerCoordinate.latitude];


		if (extendAttr.allKeys.count) {
			for (int i = 0; i<extendAttr.allKeys.count; i++) {
				dic[extendAttr.allKeys[i]] = extendAttr.allValues[i];
			}
		}


		[manager POST:[NSString stringWithFormat:@"%@marker/fields/edit",baseUrl]parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

			CDMarkerInfo *newInfo = [CDMarkerInfo mj_objectWithKeyValues:responseObject[@"result"]];

			self.finalStr = nil;
			[SVProgressHUD dismiss];
			self.layerSelectView.hidden = YES;

			editRemoveAnno = nil;

			for (CDAnno *anno in AnnoOverlayArr) {
				if ([anno.markerInfo.marker_id isEqual:newInfo.marker_id]) {
					[self.mapView removeAnnotation:anno];
				}
			}



			CDAnno* annotation = [[CDAnno alloc]init];
			CLLocationCoordinate2D coor;
			coor.latitude = newInfo.bd_y.floatValue;
			coor.longitude = newInfo.bd_x.floatValue;
			annotation.coordinate = coor;
			annotation.title = newInfo.title;

			annotation.markerInfo = newInfo;

			[AnnoOverlayArr addObject:annotation];
			[self.mapView addAnnotation:annotation];

			[self.mapView selectAnnotation:annotation animated:YES];




			selectedAnno = annotation;

			[self.extendShowTB reloadData];

			selectedAnno.markerInfo = newInfo;
			selectedAnno.title = newInfo.title;

			for (CDLayerInfo *layerinfo in markerLayers) {
				if ([layerinfo.data_id isEqual:layerinfo.data_id]){
					[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerinfo.layer_name ]forState:UIControlStateNormal];
				}
			}
			if (newInfo.images.count) {
				[self editToShowImage:newInfo.images];
			}
			self.overlayTitle.text = newInfo.title;
			self.overlayDes.text = newInfo.markerDescription;

			self.overlayNav.hidden =NO;
			self.overlaySave.hidden = YES;
			self.edti_tool_bar.hidden = NO;

			[self overlayUp];

		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			CDLog(@"%@",error);
			[SVProgressHUD showErrorWithStatus:@"网络错误"];
		}];
	}

}


-(void)editToShowImage:(NSArray *)images
{

	self.overlayPicCount.hidden = NO;
	self.overlayPic.hidden = NO;
	self.overlayTitlePosition.constant = 20;

	[self.overlayPic sd_setImageWithURL:[NSURL URLWithString:images[0]] forState:UIControlStateNormal];
	[self.overlayPicCount setTitle:[NSString stringWithFormat:@"%tu",images.count] forState:UIControlStateNormal];
}

-(void)lineMakeMethod{

	[SVProgressHUD showWithStatus:@"正在添加线……"];

	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];

	dic[@"data_id"] = selectedAddLyaerInfo.data_id;
	dic[@"user_id"] = account.user_id;
	dic[@"team_id"] = self.mapInfo.team_id;
	dic[@"title"] = self.overlayEditTitle.text;
	dic[@"description"] = self.overlayEditDes.text;

	dic[@"color"] = self.lineChangeCorlor;
	dic[@"weight"] = self.lineWidth;
	dic[@"opacity"] = self.lineAlpha;

	dic[@"line_type"] = @"0";

	NSMutableArray *array = [NSMutableArray array];
	for (CDAnno *anno in makeLineAnnoArr) {
		NSString *str = [NSString stringWithFormat:@"{lng=%f,lat=%f}",anno.coordinate.longitude,anno.coordinate.latitude];
		[array addObject:str];
	}

	NSString *string = [array componentsJoinedByString:@","];
	NSString *finlStr = [NSString stringWithFormat:@"{apex=[%@],type=line}",string];

	dic[@"line_geometry"] = finlStr;

	if (extendAttr.allKeys.count) {
		for (int i = 0; i<extendAttr.allKeys.count; i++) {
			dic[extendAttr.allKeys[i]] = extendAttr.allValues[i];
		}
	}


	[manager POST:[NSString stringWithFormat:@"%@phone/line/add",baseUrl] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		if (imagespost.count) {
			for (UIImage *image in imagespost) {
				NSData *iamgeData = UIImageJPEGRepresentation(image, 0.5);

				[formData appendPartWithFileData:iamgeData name:@"file" fileName:@"a.jpg" mimeType:@"image/jpeg"];
			}
			
		}
	} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

		CDLog(@"%@",responseObject[@"result"]);

		if ([responseObject[@"status"] isEqual:@1]) {
			self.closeMakeBtn.hidden =YES;
			self.returnMakeBtn.hidden = YES;
			self.addLinePoint.hidden = YES;
			self.addAnnoCenter.hidden = YES;
			[self addBtnAllShow];

			[self.mapView removeAnnotations:makeLineAnnoArr];
			[makeLineAnnoArr removeAllObjects];
			[self.mapView removeOverlays:makeLineArr];
			[makeLineArr removeAllObjects];

			lineMakeAnno = nil;

			isMakeLine = NO;
			lineTotolDistance = 0;

			[imagespost removeAllObjects];
			[_selectedPhotos removeAllObjects];

			[SVProgressHUD dismiss];

			self.lineChangeCorlor = nil;
			self.lineAlpha = nil;
			self.lineWidth = nil;

			self.layerSelectView.hidden = YES;

			CDLineInfo *newInfo = [CDLineInfo mj_objectWithKeyValues:responseObject[@"result"]];
			selectedLineInfo = newInfo;

			for (CDLayerInfo *layerinfo in lineLayers) {
				if ([newInfo.data_id isEqual:layerinfo.data_id]){

					[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerinfo.layer_name] forState:UIControlStateNormal];
				}
			}

			if (newInfo.images.count) {
				[self editToShowImage:newInfo.images];
			}else{
				self.overlayTitlePosition.constant = -40;
				self.overlayPicCount.hidden = YES;
				self.overlayPic.hidden = YES;
			}

			self.overlayTitle.text = newInfo.title;
			self.overlayDes.text = newInfo.lineDescription;

			self.overlayNav.hidden =NO;
			self.overlaySave.hidden = YES;
			self.edti_tool_bar.hidden = NO;

			[self overlayUp];

					CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * newInfo.line_geometry.apex.count);

					for (int i=0; i<newInfo.line_geometry.apex.count; i++) {
						CDPoint *point = newInfo.line_geometry.apex[i];
						coords[i].longitude = [point.lng floatValue];
						coords[i].latitude= [point.lat floatValue];
					}

					BMKPolyline *pline = [BMKPolyline polylineWithCoordinates:coords count:newInfo.line_geometry.apex.count];


					pline.subtitle = newInfo.line_id;

			[lineOverlayArr addObject:pline];
					[lineDataArr addObject:newInfo];
					
					[_mapView addOverlay:pline];

			BMKOverlayView *view = [[BMKOverlayView alloc]initWithOverlay:pline];
			[self mapView:_mapView onClickedBMKOverlayView:view];

		}else
			{
			[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
			}


	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];


}


-(void)lineValueChange
{
	if (self.overlayEditTitle.text.length ==0) {
		[SVProgressHUD showErrorWithStatus:@"请输入标题"];
	}else{


		[SVProgressHUD showWithStatus:@"正在修改……"];
		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

		CDAcount *account = [CDAcount accountFromSandbox];

		[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
		[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
		NSMutableDictionary *dic = [NSMutableDictionary dictionary];

		dic[@"line_id"] = selectedLineInfo.line_id;
		dic[@"title"] = self.overlayEditTitle.text;
		dic[@"description"] = self.overlayEditDes.text;

		dic[@"data_id"] = selectedInfoLyaerInfo.data_id;

		dic[@"color"] = self.lineChangeCorlor;

		dic[@"weight"] = self.lineWidth;
		dic[@"opacity"] = self.lineAlpha;


		[manager POST:[NSString stringWithFormat:@"%@line/fields/edit",baseUrl] parameters:dic  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			[SVProgressHUD dismiss];

			CDLog(@"%@",responseObject[@"result"]);
			self.lineChangeCorlor = nil;
			self.lineAlpha = nil;
			self.lineWidth = nil;

			self.layerSelectView.hidden = YES;

			CDLineInfo *newInfo = [CDLineInfo mj_objectWithKeyValues:responseObject[@"result"]];
			selectedLineInfo = newInfo;

			for (CDLayerInfo *layerinfo in lineLayers) {
				if ([newInfo.data_id isEqual:layerinfo.data_id]){

					[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerinfo.layer_name] forState:UIControlStateNormal];
				}
			}

			if (newInfo.images.count) {
				[self editToShowImage:newInfo.images];
			}



			self.overlayNav.hidden =NO;
			self.overlaySave.hidden = YES;
			self.edti_tool_bar.hidden = NO;

			[self overlayUp];

			self.overlayTitle.text = newInfo.title;
			self.overlayDes.text = newInfo.lineDescription;

			BMKPolyline *deleteLine = [[BMKPolyline alloc]init];
			BMKPolyline *addLine = [[BMKPolyline alloc]init];
			for (BMKPolyline *line in lineOverlayArr) {

				if ([line.subtitle isEqual:newInfo.line_id]) {

					deleteLine = line;

					[self.mapView removeOverlay:line];

					CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * newInfo.line_geometry.apex.count);

					for (int i=0; i<newInfo.line_geometry.apex.count; i++) {
						CDPoint *point = newInfo.line_geometry.apex[i];
						coords[i].longitude = [point.lng floatValue];
						coords[i].latitude= [point.lat floatValue];
					}

					BMKPolyline *pline = [BMKPolyline polylineWithCoordinates:coords count:newInfo.line_geometry.apex.count];


					pline.subtitle = newInfo.line_id;

					addLine = pline;

					[lineDataArr addObject:newInfo];

					[_mapView addOverlay:pline];
				}

			}
			[lineOverlayArr removeObject:deleteLine];
			[lineOverlayArr addObject:addLine];

		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			CDLog(@"%@",error);
			[SVProgressHUD showErrorWithStatus:@"网络错误"];
		}];
	}

}

-(void)zoneChangeMethod{
	[SVProgressHUD showWithStatus:@"正在修改……"];
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"zone_id"] = selectedZoneInfo.zone_id;
	dic[@"title"] = self.overlayEditTitle.text;
	dic[@"description"] = self.overlayEditDes.text;

	dic[@"data_id"] = selectedInfoLyaerInfo.data_id;
	dic[@"fill_color"] = self.zoneChangeCorlor;

	dic[@"fill_opacity"] = self.zoneAlpha;

	dic[@"stroke_opacity"] = self.zoneLineAlpha;
	dic[@"stroke_color"] = self.zoneLineCorlor;
	dic[@"stroke_weight"] = self.zoneWidth;


	[manager POST:[NSString stringWithFormat:@"%@zone/fields/edit",baseUrl]  parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		[SVProgressHUD dismiss];

		self.zoneChangeCorlor = nil;
		self.zoneWidth = nil;
		self.zoneAlpha = nil;
		self.zoneLineCorlor = nil;
		self.zoneLineAlpha = nil;

		self.layerSelectView.hidden = YES;

		CDZoneInfo *newInfo = [CDZoneInfo mj_objectWithKeyValues:responseObject[@"result"]];

		[zoneDataArr addObject:newInfo];


		for (BMKCircle *circle in circleOverlayArr) {
			if ([newInfo.zone_id isEqual:circle.subtitle]) {
				[self.mapView removeOverlay:circle];
			}
		}
		for (BMKPolygon *polygon in polygonOverlayArr) {
			if ([polygon.subtitle isEqual:newInfo.zone_id]) {
				[self.mapView removeOverlay:polygon];
			}
		}


		if (newInfo.zone_geometry.apex ==nil) {
			newInfo.zone_geometry = nil;
		}

		if (newInfo.circle_geometry.radius ==nil) {
			newInfo.circle_geometry = nil;
		}

		if (newInfo.circle_geometry) {
			CLLocationCoordinate2D coor ;
			coor.latitude = [newInfo.circle_geometry.center.lat floatValue];
			coor.longitude = [newInfo.circle_geometry.center.lng floatValue];

			BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:newInfo.circle_geometry.radius.floatValue];

			circle.subtitle = newInfo.zone_id;
			circle.title = newInfo.data_id;

			[circleOverlayArr addObject:circle];

			[_mapView addOverlay:circle];
		}

		if (newInfo.zone_geometry) {

			CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * newInfo.zone_geometry.apex.count);

			for (int i=0; i<newInfo.zone_geometry.apex.count; i++) {
				CDPoint *point = newInfo.zone_geometry.apex[i];
				coords[i].latitude = point.lat.doubleValue;
				coords[i].longitude = point.lng.doubleValue;
			}

			BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:newInfo.zone_geometry.apex.count];
			polygon.subtitle = newInfo.zone_id;
			polygon.title = newInfo.data_id;


			[polygonOverlayArr addObject:polygon];
			[_mapView addOverlay:polygon];
		}

		selectedZoneInfo = newInfo;
		selectedZoneInfo.title = newInfo.title;

		for (CDLayerInfo *layerinfo in zoneLayers) {
			if ([layerinfo.data_id isEqual:newInfo.data_id]){
				[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerinfo.layer_name]  forState:UIControlStateNormal];
			}
		}

		if (newInfo.images.count) {
			[self editToShowImage:newInfo.images];
		}

		self.overlayTitle.text = newInfo.title;
		self.overlayDes.text = newInfo.zoneDescription;

		self.overlayNav.hidden =NO;
		self.overlaySave.hidden = YES;
		self.edti_tool_bar.hidden = NO;

		[self overlayUp];

	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];


}




-(void)zoneValueChange
{
	if (self.overlayEditTitle.text.length ==0) {
		[SVProgressHUD showErrorWithStatus:@"请输入标题"];
	}else{
		[self zoneChangeMethod];
	}

}


- (IBAction)overlaySaveClick:(UIButton *)sender {

	[[UIApplication sharedApplication].keyWindow endEditing:YES];

	[self pointStatus2BackMap];

	if (poi) {
		[self poiAddAnno];
	}else
		if (selectedZoneInfo) {
			[self zoneValueChange];
		}else
			if (selectedLineInfo) {
				[self lineValueChange];
			}else
				if (selectedAnno) {
					[self annoValueChange];
				}else
					{

					if (isMakeLine) {
						[self lineMakeMethod];
					}else
						if (isMakeZone) {
							[self zoneMakeMethod];
						}

					else{
						[self addAnnoMethod];
					}

					}

	[self.addAnnoBtn setImage:[UIImage imageNamed:@"btn_coordinate_default"] forState:UIControlStateNormal];

	[self navOverlayNorChange];


}

-(void)zoneMakeMethod
{
	[SVProgressHUD showWithStatus:@"正在添加面..."];
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];

	dic[@"user_id"] = account.user_id;
	dic[@"team_id"] = self.mapInfo.team_id;
	dic[@"data_id"] = selectedAddLyaerInfo.data_id;
	dic[@"title"] = self.overlayEditTitle.text;
	dic[@"description"] = self.overlayEditDes.text;

	dic[@"fill_color"] = self.zoneChangeCorlor;

	dic[@"fill_opacity"] = self.zoneAlpha;

	dic[@"stroke_opacity"] = self.zoneLineAlpha;
	dic[@"stroke_color"] = self.zoneLineCorlor;
	dic[@"stroke_weight"] = self.zoneWidth;

	dic[@"troke_style"] = @"0";
	NSMutableArray *array = [NSMutableArray array];
	for (CDAnno *anno in makeZoneAnnoArr) {
		NSString *str = [NSString stringWithFormat:@"{lng=%f,lat=%f}",anno.coordinate.longitude,anno.coordinate.latitude];
		[array addObject:str];
	}

	NSString *string = [array componentsJoinedByString:@","];

	BMKPolygon *polygon = makeZoneArr[0];
	NSString *center = [NSString stringWithFormat:@"{lng=%f,lat=%f}",polygon.coordinate.longitude,polygon.coordinate.latitude];
	NSString *finlStr = [NSString stringWithFormat:@"{type=polygon,center=%@,apex=[%@]}",center,string];

	dic[@"zone_geometry"] = finlStr;

	if (extendAttr.allKeys.count) {
		for (int i = 0; i<extendAttr.allKeys.count; i++) {
			dic[extendAttr.allKeys[i]] = extendAttr.allValues[i];
		}
	}

	[manager POST:[NSString stringWithFormat:@"%@phone/zone/add",baseUrl] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		if (imagespost.count) {
			for (UIImage *image in imagespost) {
				NSData *iamgeData = UIImageJPEGRepresentation(image, 0.5);

				[formData appendPartWithFileData:iamgeData name:@"file" fileName:@"a.jpg" mimeType:@"image/jpeg"];
			}

		}
	} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

		if ([responseObject[@"status"] isEqual:@1]) {
			self.closeMakeBtn.hidden =YES;
			self.returnMakeBtn.hidden = YES;
			self.addZonePoint.hidden = YES;
			self.addAnnoCenter.hidden = YES;
			[self addBtnAllShow];

			[self.mapView removeAnnotations:makeZoneAnnoArr];
			[makeZoneAnnoArr removeAllObjects];
			[self.mapView removeOverlays:makeZoneArr];
			[makeZoneArr removeAllObjects];
			[self.mapView removeOverlays:makeLineArr];
			[makeLineArr removeAllObjects];

			isMakeZone = NO;

			[imagespost removeAllObjects];
			[_selectedPhotos removeAllObjects];
			[SVProgressHUD dismiss];

			self.zoneChangeCorlor = nil;
			self.zoneWidth = nil;
			self.zoneAlpha = nil;
			self.zoneLineCorlor = nil;
			self.zoneLineAlpha = nil;

			self.layerSelectView.hidden = YES;

			CDZoneInfo *newInfo = [CDZoneInfo mj_objectWithKeyValues:responseObject[@"result"]];

			[zoneDataArr addObject:newInfo];

			if (newInfo.zone_geometry.apex ==nil) {
				newInfo.zone_geometry = nil;
			}

			if (newInfo.circle_geometry.radius ==nil) {
				newInfo.circle_geometry = nil;
			}



			if (newInfo.zone_geometry) {

				CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * newInfo.zone_geometry.apex.count);

				for (int i=0; i<newInfo.zone_geometry.apex.count; i++) {
					CDPoint *point = newInfo.zone_geometry.apex[i];
					coords[i].latitude = point.lat.doubleValue;
					coords[i].longitude = point.lng.doubleValue;
				}

				BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:newInfo.zone_geometry.apex.count];
				polygon.subtitle = newInfo.zone_id;
				polygon.title = newInfo.data_id;


				[polygonOverlayArr addObject:polygon];
				[_mapView addOverlay:polygon];

				[self mapView:_mapView onClickedMapBlank:polygon.coordinate];

			}

			selectedZoneInfo = newInfo;
			selectedZoneInfo.title = newInfo.title;

			for (CDLayerInfo *layerinfo in zoneLayers) {
				if ([layerinfo.data_id isEqual:newInfo.data_id]){
					[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerinfo.layer_name]  forState:UIControlStateNormal];
				}
			}

			if (newInfo.images.count) {
				[self editToShowImage:newInfo.images];
			}else{
				self.overlayTitlePosition.constant = -40;
				self.overlayPicCount.hidden = YES;
				self.overlayPic.hidden = YES;
			}

			self.overlayTitle.text = newInfo.title;
			self.overlayDes.text = newInfo.zoneDescription;
			
			self.overlayNav.hidden =NO;
			self.overlaySave.hidden = YES;
			self.edti_tool_bar.hidden = NO;
			
			[self overlayUp];

		}else{
			[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
		}

	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];
}


- (IBAction)changeAnnoStyle:(UIButton *)sender {

	if (selectedAnno || isAddAnno) {
		SMAnnoImageViewController *vc= [[UIStoryboard storyboardWithName:@"SMAnnoImage" bundle:nil]instantiateInitialViewController];
		vc.delegate =self;

		vc.indexItem1 = indexPath1;
		vc.indexItem2 = indexPath2;
		vc.indexItem3 = indexPath3;
		vc.selectindex = selectiindex;
		vc.finalStr = self.finalStr;
		[self.navigationController pushViewController:vc animated:YES];

	}

	if (isMakeLine) {
		CDLineSytleView *vc = [[UIStoryboard storyboardWithName:@"CDLineSytle" bundle:nil]instantiateInitialViewController];

		vc.indexItem1 = _lineIndex1;
		[self.navigationController pushViewController:vc animated:YES];
	}


	if (isMakeZone) {
		CDZoneStyleView *vc = [[UIStoryboard storyboardWithName:@"CDZoneStyleView" bundle:nil]instantiateInitialViewController];

		vc.indexItem1 = _zoneIndex1;
		vc.indexItem2 = _zoneIndex2;
		[self.navigationController pushViewController:vc animated:YES];
	}

	if (selectedLineInfo) {
		CDLineSytleView *vc = [[UIStoryboard storyboardWithName:@"CDLineSytle" bundle:nil]instantiateInitialViewController];

		vc.lineInfo = selectedLineInfo;

		vc.indexItem1 = _lineIndex1;
		[self.navigationController pushViewController:vc animated:YES];
	}

	if (selectedZoneInfo) {
		CDZoneStyleView *vc = [[UIStoryboard storyboardWithName:@"CDZoneStyleView" bundle:nil]instantiateInitialViewController];

		vc.zoneInfo = selectedZoneInfo;

		vc.indexItem1 = _zoneIndex1;
		vc.indexItem2 = _zoneIndex2;
		[self.navigationController pushViewController:vc animated:YES];
	}
}

-(void)finalUrlPass:(NSString *)finalUrl :(NSInteger)indexItem1 :(NSInteger)indexItem2 :(NSInteger)indexItem3 :(NSInteger)selectindex
{
	if (finalUrl) {
		[self.changeAnnoStyle sd_setImageWithURL:[NSURL URLWithString:finalUrl]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"create_synchronisms"] ];
		self.finalStr  = finalUrl;
	}else
		{
		[self.changeAnnoStyle sd_setImageWithURL:[NSURL URLWithString:@"http://a.dituhui.com/images/marker/icon/default/761458fbc7b4142e1ae92be936f822a3.png"] forState:UIControlStateNormal];
		}

	indexPath1 = indexItem1;
	indexPath2 = indexItem2;
	indexPath3 = indexItem3;
	selectiindex = selectindex;
}

- (UIImagePickerController *)imagePickerVc {
	if (_imagePickerVc == nil) {
		_imagePickerVc = [[UIImagePickerController alloc] init];
		_imagePickerVc.delegate = self;

		_imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
		_imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
		UIBarButtonItem *tzBarItem, *BarItem;
		if (iOS9Later) {
			tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
			BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
		} else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
			tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
			BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
		}
		NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
		[BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
	}
	return _imagePickerVc;
}


- (IBAction)upLoadPic:(UIButton *)sender {

	if (_selectedPhotos.count >0) {

		if (isAddAnno ) {
			CDImageShowVC *imageShowVC = [[UIStoryboard storyboardWithName:@"CDImageShow" bundle:nil]instantiateInitialViewController];

			imageShowVC.images = _selectedPhotos;
			[self.navigationController pushViewController:imageShowVC animated:YES];
		}else{
			CDImageShowVC *imageShowVC = [[UIStoryboard storyboardWithName:@"CDImageShow" bundle:nil]instantiateInitialViewController];


			imageShowVC.iamgeUrls = _selectedPhotos;
			[self.navigationController pushViewController:imageShowVC animated:YES];
		}
	}else

		{

		if (isAddAnno || isMakeLine || isMakeZone) {

			TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];

			[imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

				_selectedPhotos = [NSMutableArray arrayWithArray:photos];

				[imagespost removeAllObjects];
				[imagespost addObjectsFromArray:photos];

				_isSelectOriginalPhoto = isSelectOriginalPhoto;

				UIImage *image = _selectedPhotos[0];
				[self.upLoadPicBtn setImage:image forState:UIControlStateNormal];
				[self.uploadCount setTitle:[NSString stringWithFormat:@"%tu",_selectedPhotos.count] forState:UIControlStateNormal];
			}];
			[self presentViewController:imagePickerVc animated:YES completion:nil];
		}else{

			TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];

			[imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

				_selectedPhotos = [NSMutableArray arrayWithArray:photos];

				_isSelectOriginalPhoto = isSelectOriginalPhoto;

				UIImage *image = _selectedPhotos[0];
				[self.upLoadPicBtn setImage:image forState:UIControlStateNormal];
				[self.uploadCount setTitle:[NSString stringWithFormat:@"%tu",_selectedPhotos.count] forState:UIControlStateNormal];

				if (selectedAnno) {
					[self addElePic:@"0" images:_selectedPhotos];
				}else
					if (selectedLineInfo) {
						[self addElePic:@"1" images:_selectedPhotos];
					}else
						if (selectedZoneInfo) {
							[self addElePic:@"2" images:_selectedPhotos];
						}
			}];
			[self presentViewController:imagePickerVc animated:YES completion:nil];
		}

		}
}


-(void)addElePic:(NSString *)eleType images:(NSArray *)images{


	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	CDAcount *account = [CDAcount accountFromSandbox];

	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];


	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	if ([eleType  isEqual: @"2"]) {
		dic[@"ele_id"] = selectedZoneInfo.zone_id;
	}else
		if ([eleType isEqual:@"1"]) {
			dic[@"ele_id"] = selectedLineInfo.line_id;
		}else
			if ([eleType isEqual:@"0"]) {
				dic[@"ele_id"] = selectedAnno.markerInfo.marker_id;
			}

	dic[@"ele_type"] = eleType;
	dic[@"user_id"] = account.user_id;

	[SVProgressHUD showWithStatus:@"正在上传图片..."];
	[manager POST:[NSString stringWithFormat:@"%@phone/element/uploadimgs",baseUrl] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

		for (UIImage *image in images) {
			NSData *iamgeData = UIImageJPEGRepresentation(image, 0.5);

			[formData appendPartWithFileData:iamgeData name:@"file" fileName:@"a.jpg" mimeType:@"image/jpeg"];
		}
	} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		CDLog(@"%@",responseObject);

		CDImagesUrls *CDurls = [CDImagesUrls mj_objectWithKeyValues:responseObject[@"result"]];
		NSArray *urls = CDurls.path;


		if (urls.count) {
			[self.upLoadPicBtn sd_setImageWithURL:[NSURL URLWithString:urls[0]] forState:UIControlStateNormal];
			[self.uploadCount setTitle:[NSString stringWithFormat:@"%tu",urls.count] forState:UIControlStateNormal];
		}else
			{
			[self.upLoadPicBtn setImage:[UIImage imageNamed:@"btn_image"] forState:UIControlStateNormal];
			[self.uploadCount setTitle:nil forState:UIControlStateNormal];
			}


		[_selectedPhotos removeAllObjects];
		[_selectedPhotos addObjectsFromArray:urls];

		if (selectedAnno) {
			for (CDAnno *anno in AnnoOverlayArr) {
				if (anno  == selectedAnno) {
					anno.markerInfo.images = urls;
				}
			}
		}else
			if (selectedLineInfo){
				for (CDLineInfo *lineInfo in lineDataArr) {
					if (selectedLineInfo == lineInfo) {
						lineInfo.images = urls;
					}
				}
			}else
				if (selectedZoneInfo) {
					for (CDZoneInfo *zoneInfo in zoneDataArr) {
						if (selectedZoneInfo == zoneInfo) {
							zoneInfo.images = urls;
						}
					}
				}
		[SVProgressHUD dismiss];
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];
}

- (void)takePhoto {
	AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
		[alert show];
#define push @#clang diagnostic pop
	} else {
		UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
		if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
			self.imagePickerVc.sourceType = sourceType;
			if(iOS8Later) {
				_imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
			}
			[self presentViewController:_imagePickerVc animated:YES completion:nil];
		} else {
			NSLog(@"模拟器中无法打开照相机,请在真机中使用");
		}
	}
}


#pragma mark - UIImagePickerDelegate
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
	[picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

	UIImage *image = info[UIImagePickerControllerOriginalImage];

	[_selectedPhotos removeAllObjects];
	[_selectedPhotos addObject:image];

	if (selectedAnno) {
		[self addElePic:@"0" images:_selectedPhotos];
	}else
		if (selectedZoneInfo) {
			[self addElePic:@"2" images:_selectedPhotos];
		}else
			if (selectedLineInfo) {
				[self addElePic:@"1" images:_selectedPhotos];
			}

	[picker dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)deleteAnno:(UIButton *)sender {

	if (selectedAnno) {
		[SVProgressHUD showWithStatus:@"正在删除点标记"];

		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

		CDAcount *account = [CDAcount accountFromSandbox];

		[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
		[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];


		NSMutableDictionary *dic = [NSMutableDictionary dictionary];
		dic[@"marker_id"] = selectedAnno.markerInfo.marker_id;

		dic[@"data_id"] = selectedAnno.markerInfo.data_id;


		[manager POST:[NSString stringWithFormat:@"%@deleteMarker",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			if ([responseObject[@"status"] isEqual:@1]) {

				[self mapInfoUp];
				[self navOverlayNorChange];

				[SVProgressHUD showSuccessWithStatus:@"删除成功"];

				[_mapView removeAnnotation:selectedAnno];


			}else
				{
				[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
				}


		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			CDLog(@"%@",error);
			[SVProgressHUD showErrorWithStatus:@"网络错误"];
		}];
	}else
		if (selectedLineInfo) {
			[SVProgressHUD showWithStatus:@"正在删除线标记"];

			AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

			CDAcount *account = [CDAcount accountFromSandbox];

			[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
			[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];


			NSMutableDictionary *dic = [NSMutableDictionary dictionary];
			dic[@"line_id"] = selectedLineInfo.line_id;

			[manager POST:[NSString stringWithFormat:@"%@deleteLine",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {


				if ([responseObject[@"status"] isEqual:@1]) {

					for (BMKPolyline *line in lineOverlayArr) {
						if ([line.subtitle isEqual:selectedLineInfo.line_id]) {
							[_mapView removeOverlay:line];
						}
					}

					[SVProgressHUD showSuccessWithStatus:@"删除成功"];
					[self navOverlayNorChange];
					[self mapInfoUp];

				}else
					{
					[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
					}


			} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
				CDLog(@"%@",error);
				[SVProgressHUD showErrorWithStatus:@"网络错误"];
			}];
		}else
			if (selectedZoneInfo) {
				[SVProgressHUD showWithStatus:@"正在删除面标记"];

				AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

				CDAcount *account = [CDAcount accountFromSandbox];

				[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
				[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];


				NSMutableDictionary *dic = [NSMutableDictionary dictionary];
				dic[@"zone_id"] = selectedZoneInfo.zone_id;

				[manager POST:[NSString stringWithFormat:@"%@deleteZone",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {


					if ([responseObject[@"status"] isEqual:@1]) {

						[SVProgressHUD showSuccessWithStatus:@"删除成功"];


						for (BMKPolygon *zone in polygonOverlayArr) {
							if ([zone.subtitle isEqual:selectedZoneInfo.zone_id]) {
								[_mapView removeOverlay:zone];
							}
						}

						[self navOverlayNorChange];
						[self mapInfoUp];

						

					}else
						{
						[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
						}


				} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
					CDLog(@"%@",error);
					[SVProgressHUD showErrorWithStatus:@"网络错误"];
				}];
			}

}


-(void)layerCoverClick
{
	selectLayerBtnOpen = !selectLayerBtnOpen;
	[layerCover removeFromSuperview];
	self.layerSelectView.hidden = YES;
}

- (IBAction)selectLayerClick:(UIButton *)sender {

	selectLayerBtnOpen = !selectLayerBtnOpen;
	if (selectLayerBtnOpen == YES) {

		layerCover = [[UIButton alloc]initWithFrame:self.view.frame];
		layerCover.backgroundColor = [UIColor blackColor];
		layerCover.alpha = 0.7;
		[self.view addSubview:layerCover];

		[self.view bringSubviewToFront:self.layerSelectView];

		[layerCover addTarget:self action:@selector(layerCoverClick) forControlEvents:UIControlEventTouchUpInside];

		self.layerSelectView.hidden = NO;

		[self.layerSelectView reloadAllComponents];
	}else
		{
		self.layerSelectView.hidden = YES;
		}
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

	if (selectedAnno) {
		return markerLayers.count;
	}else
		if (selectedLineInfo) {
			return lineLayers.count;
		}else
			if (selectedZoneInfo) {
				return zoneLayers.count;
			}else
				{

				if (isMakeLine) {
					return lineLayers.count;
				}else
					if (isMakeZone) {
						return zoneLayers.count;
					}

				else{
					return markerLayers.count;
				}


		}

}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

	CDLayerInfo *layerInfo;

	if (selectedZoneInfo) {
		layerInfo = zoneLayers[row];
	}else
		if (selectedLineInfo) {
			layerInfo =lineLayers[row];
		}else
			{
			if (isMakeLine) {
				layerInfo = lineLayers[row];
			}else
				if (isMakeZone) {
					layerInfo = zoneLayers[row];
				}
			else{
			layerInfo = markerLayers[row];
			}
		}


	return layerInfo.layer_name;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel* pickerLabel = (UILabel*)view;
	if (!pickerLabel){
		pickerLabel = [[UILabel alloc] init];
			// Setup label properties - frame, font, colors etc
			//adjustsFontSizeToFitWidth property to YES
		pickerLabel.minimumFontSize = 8.;
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
	
	CDLayerInfo *layerinfo;
	
	if (selectedZoneInfo) {
		layerinfo = zoneLayers[row];
		selectedInfoLyaerInfo = layerinfo;
	}else
		if (selectedLineInfo) {
			layerinfo = lineLayers[row];
			selectedInfoLyaerInfo = layerinfo;
		}else
			if (selectedAnno) {
				layerinfo = markerLayers[row];
				selectedInfoLyaerInfo = layerinfo;

					[self.extendEditTB reloadData];
			}else
				{
				if (markerLayers.count) {
					layerinfo = markerLayers[row];
					selectedAddLyaerInfo = layerinfo;
				}

				if (isMakeLine) {
					layerinfo = lineLayers[row];
					selectedAddLyaerInfo = layerinfo;
				}
				if (isMakeZone) {
					layerinfo =zoneLayers[row];
					selectedAddLyaerInfo = layerinfo;
				}

				if (isAddAnno) {
					[self.extendEditTB reloadData];
				}
				}
	
	[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",layerinfo.layer_name]  forState:UIControlStateNormal];

	[self layerCoverClick];
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40;
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[self.coordinateQuadTree clean];


}

- (IBAction)normalDiffClick:(UIButton *)sender {
	isSelectSateliteMap = NO;
	[self.normalDiffButton setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"] forState:UIControlStateNormal];
	[self.sateliteDiffButton setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"] forState:UIControlStateNormal];
	
	_mapView.mapType = BMKMapTypeStandard;
	
}
- (IBAction)sateliteDiffClick:(UIButton *)sender {
	isSelectSateliteMap = YES;
	
	[self.sateliteDiffButton setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"] forState:UIControlStateNormal];
	[self.normalDiffButton setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"] forState:UIControlStateNormal];
	
	_mapView.mapType = BMKMapTypeSatellite;
}

- (IBAction)overlayPicClick:(id)sender {
	
	
	CDImageShowVC *showVc = [[UIStoryboard storyboardWithName:@"CDImageShow" bundle:nil]instantiateInitialViewController];
	showVc.isNOEdit = YES;
	
	if (selectedAnno) {
		[showVc.iamgeUrls addObjectsFromArray:selectedAnno.markerInfo.images];
	}else if(selectedLineInfo){
		[showVc.iamgeUrls addObjectsFromArray:selectedLineInfo.images];
	}else if(selectedZoneInfo){
		[showVc.iamgeUrls addObjectsFromArray:selectedZoneInfo.images];
	}
	
	[self.navigationController pushViewController:showVc animated:YES];
	
}

- (IBAction)saveMapStatus:(id)sender {
	self.moreView.hidden = YES;
	isMoreOpen = NO;
	
	[SVProgressHUD showWithStatus:@"正在保存地图状态"];
	
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	
	
	CDAcount *account = [CDAcount accountFromSandbox];
	
	[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
	[manager.requestSerializer setValue:account.user_id forHTTPHeaderField:@"user_id"];
	
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"map_id"] = self.mapInfo.map_id;
	dic[@"center"] = [NSString stringWithFormat:@"%f,%f",_mapView.centerCoordinate.longitude,_mapView.centerCoordinate.latitude];
	dic[@"level"] = [NSString stringWithFormat:@"%d",(int)_mapView.zoomLevel];
	dic[@"user_id"]= account.user_id;
	
	[manager POST:[NSString stringWithFormat:@"%@saveMap",baseUrl] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		[SVProgressHUD setMinimumDismissTimeInterval:1.0f];

		if ([responseObject[@"status"] isEqual:@1]) {
				[SVProgressHUD showSuccessWithStatus:@"保存地图状态成功"];
		}else{
			[SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
		}

		CDLog(@"%@",responseObject);
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		CDLog(@"%@",error);
		[SVProgressHUD showErrorWithStatus:@"网络错误"];
	}];
}


- (IBAction)reloadMapClick:(id)sender {

	self.moreView.hidden = YES;
	isMoreOpen = NO;

	[_mapView removeAnnotations:_mapView.annotations];
	[_mapView removeOverlays:lineOverlayArr];
	[_mapView removeOverlays:circleOverlayArr];
	[_mapView removeOverlays:polygonOverlayArr];

	[_mapView removeHeatMap];

	[self loadAllLayers:self.mapInfo.map_id];
}



- (IBAction)meaSureDistance:(UIButton *)sender {
	self.moreView.hidden = YES;
	isMoreOpen = NO;

	selectedAnno = nil;
	selectedLineInfo = nil;
	selectedZoneInfo = nil;
	[self mapInfoUp];
	self.topMeasureView.hidden = NO;
	self.measureLabel.text = @"点击地图选择起点";
	isMeasureOpen = YES;

}
- (IBAction)clearMeasureResult:(UIButton *)sender {
	[self.mapView removeAnnotations:measureAnnoArr];
	[measureAnnoArr removeAllObjects];

	[self.mapView removeOverlays:measureLineArr];
	[measureLineArr removeAllObjects];

	mesureAnno = nil;
	totolDistance = 0;
}

- (IBAction)closeMeasureView:(UIButton *)sender {
	self.topMeasureView.hidden = YES;
	isMeasureOpen = NO;

	[self.mapView removeAnnotations:measureAnnoArr];
	[measureAnnoArr removeAllObjects];

	[self.mapView removeOverlays:measureLineArr];
	[measureLineArr removeAllObjects];

	mesureAnno = nil;

	totolDistance = 0;
}

-(void)clearAddBtnAll{
	self.addAnnoBtn.hidden = YES;
	self.makeLineBtn.hidden = YES;
	self.makeZone.hidden = YES;
}
-(void)addBtnAllShow
{
	self.addAnnoBtn.hidden = NO;
	self.makeLineBtn.hidden = NO;
	self.makeZone.hidden = NO;
}

- (IBAction)makeZoneClick:(id)sender {
	[self pointStatus2BackMap];
	selectedAnno = nil;
	selectedLineInfo = nil;
	selectedZoneInfo = nil;

	[self clearAddBtnAll];
	self.closeMakeBtn.hidden = NO;
	self.returnMakeBtn.hidden = NO;
	self.addZonePoint.hidden = NO;
	self.addAnnoCenter.hidden = NO;

	isMakeZone = YES;
	[imagespost removeAllObjects];
	[_selectedPhotos removeAllObjects];
	[self.upLoadPicBtn setImage:[UIImage imageNamed:@"btn_image"] forState:UIControlStateNormal];
	[self.uploadCount setTitle:nil forState:UIControlStateNormal];
	self.overlayEditTitle.text = @"";
	self.overlayEditDes.text = @"";
	[self.extendEditTB reloadData];

	self.deleteAnnoBtn.hidden = YES;
	self.styleShowImageView.image= nil;

}


- (IBAction)makeLineClick:(id)sender {
	[self pointStatus2BackMap];
	selectedAnno = nil;
	selectedLineInfo = nil;
	selectedZoneInfo = nil;

	[self clearAddBtnAll];
	self.closeMakeBtn.hidden = NO;
	self.returnMakeBtn.hidden = NO;
	self.addLinePoint.hidden = NO;
	self.addAnnoCenter.hidden = NO;

	lineTotolDistance = 0;
	isMakeLine = YES;

	[imagespost removeAllObjects];
	[_selectedPhotos removeAllObjects];
	[self.upLoadPicBtn setImage:[UIImage imageNamed:@"btn_image"] forState:UIControlStateNormal];
	[self.uploadCount setTitle:nil forState:UIControlStateNormal];


	self.overlayEditTitle.text = @"";
	self.overlayEditDes.text = @"";
	[self.extendEditTB reloadData];

	self.deleteAnnoBtn.hidden = YES;
	self.styleShowImageView.image = nil;
}


- (IBAction)addLinePoint:(id)sender {

	CDAnno *anno = [[CDAnno alloc] init];
	anno.coordinate = self.mapView.centerCoordinate;
	CDMarkerInfo *markerInfo = [[CDMarkerInfo alloc]init];

	markerInfo.bd_x = [NSString stringWithFormat:@"%f",anno.coordinate.longitude];
	markerInfo.bd_y = [NSString stringWithFormat:@"%f",anno.coordinate.latitude];

	CDMarkerStyle *markerStyle = [[CDMarkerStyle alloc]init];
	markerStyle.icon_url =@"http://a.dituhui.com/images/marker/icon/default/25d748ed9abe1c6b27a1d33b84a851c9.png";
	markerInfo.style = markerStyle;

	anno.markerInfo = markerInfo;

	if (!lineMakeAnno) {

	}else{

		if (lineTotolDistance == 0) {

			[self overlayEditUp];

			self.styleShowImageView.image = nil;
	self.styleShowImageView.layer.borderColor = [UIColor clearColor].CGColor;
			CDLayerInfo *lineLayer = lineLayers[0];
			[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",lineLayer.layer_name] forState:UIControlStateNormal];
			selectedAddLyaerInfo = lineLayer;
			[self.changeAnnoStyle setTitle:@"线样式" forState:UIControlStateNormal];
		}


		CLLocationCoordinate2D *coords =
		malloc(sizeof(CLLocationCoordinate2D) * 2);

		coords[0] =lineMakeAnno.coordinate;
		coords[1] =self.mapView.centerCoordinate;

		BMKPolyline *pline = [BMKPolyline polylineWithCoordinates:coords count:2];

		[_mapView addOverlay:pline];

		[makeLineArr addObject:pline];

		BMKMapPoint point1 = BMKMapPointForCoordinate(lineMakeAnno.coordinate);
		BMKMapPoint point2 = BMKMapPointForCoordinate(self.mapView.centerCoordinate);

		CLLocationDistance distance =
		BMKMetersBetweenMapPoints(point1,point2);


		lineTotolDistance +=distance;

		[lineDisTanceArr addObject:[NSNumber numberWithFloat:distance]];

		self.overlayEditTitle.text = [NSString stringWithFormat:@"%0.2f 千米",lineTotolDistance/1000];
	}

	lineMakeAnno = anno;
	[makeLineAnnoArr addObject:anno];
	[self.mapView addAnnotation:anno];

}

- (IBAction)addZonePoint:(id)sender {

	CDAnno *anno = [[CDAnno alloc] init];
	anno.coordinate = self.mapView.centerCoordinate;
	CDMarkerInfo *markerInfo = [[CDMarkerInfo alloc]init];

	markerInfo.bd_x = [NSString stringWithFormat:@"%f",anno.coordinate.longitude];
	markerInfo.bd_y = [NSString stringWithFormat:@"%f",anno.coordinate.latitude];

	CDMarkerStyle *markerStyle = [[CDMarkerStyle alloc]init];
	markerStyle.icon_url =@"http://a.dituhui.com/images/marker/icon/default/25d748ed9abe1c6b27a1d33b84a851c9.png";
	markerInfo.style = markerStyle;

	anno.markerInfo = markerInfo;

	[makeZoneAnnoArr addObject:anno];

	if (makeZoneAnnoArr.count == 3) {

			[self overlayEditUp];
		self.styleShowImageView.image = nil;
		self.styleShowImageView.layer.borderColor = [UIColor clearColor].CGColor;

			CDLayerInfo *zoneLayer = zoneLayers[0];
			[self.selectLayerBtn setTitle:[NSString stringWithFormat:@"所属图层:%@",zoneLayer.layer_name] forState:UIControlStateNormal];
			selectedAddLyaerInfo = zoneLayer;
			[self.changeAnnoStyle setTitle:@"面样式" forState:UIControlStateNormal];

		}

	if (makeZoneAnnoArr.count == 2) {

		CLLocationCoordinate2D *coords =
		malloc(sizeof(CLLocationCoordinate2D) * 2);

		CDAnno *anno1 =makeZoneAnnoArr[(makeZoneAnnoArr.count -1)];
		CDAnno *anno2 =makeZoneAnnoArr[(makeZoneAnnoArr.count -2)];
		coords[0] =anno1.coordinate;
		coords[1] =anno2.coordinate;

		BMKPolyline *pline = [BMKPolyline polylineWithCoordinates:coords count:2];

		[_mapView addOverlay:pline];
		[makeLineArr addObject:pline];
	}

	if (makeZoneAnnoArr.count >= 3) {

		[self.mapView removeOverlays:makeZoneArr];
		[makeZoneArr removeAllObjects];

		CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * makeZoneAnnoArr.count);

		for (int i=0; i<makeZoneAnnoArr.count; i++) {
			CDAnno *anno = makeZoneAnnoArr[i];
			coords[i].latitude = anno.coordinate.latitude;
			coords[i].longitude  = anno.coordinate.longitude;
		}

		BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:makeZoneAnnoArr.count];

		[makeZoneArr addObject:polygon];
		[_mapView addOverlay:polygon];


	}
	[self.mapView addAnnotation:anno];
}
- (IBAction)returnMakeClick:(id)sender {

	if (isMakeLine) {

		if (lineMakeAnno) {
			
			BMKPolyline *line = makeLineArr.lastObject;
			[self.mapView removeOverlay:line];
			[makeLineArr removeLastObject];

			CDAnno *anno = makeLineAnnoArr.lastObject;
			[self.mapView removeAnnotation:anno];

			[makeLineAnnoArr removeLastObject];

			lineMakeAnno = makeLineAnnoArr.lastObject;

			NSNumber *number = lineDisTanceArr.lastObject;

			lineTotolDistance = lineTotolDistance - number.floatValue;

			[lineDisTanceArr removeLastObject];

			float total = 0;
			for (NSNumber *num in lineDisTanceArr) {
				total = total+num.floatValue;
			}



			self.overlayEditTitle.text = [NSString stringWithFormat:@"%0.2f 千米",total/1000];

		}

	}

	if (isMakeZone) {

		if (makeZoneAnnoArr.count == 1) {
			CDAnno *anno = makeZoneAnnoArr[0];
			[self.mapView removeAnnotation:anno];
			[makeZoneAnnoArr removeLastObject];
		}


		if (makeZoneAnnoArr.count == 2) {


			BMKPolyline *polyLine = makeLineArr.lastObject;
			[self.mapView removeOverlay:polyLine];
			[makeLineArr removeLastObject];

			CDAnno *anno  = makeZoneAnnoArr.lastObject;
			[self.mapView removeAnnotation:anno];
			[makeZoneAnnoArr removeLastObject];

		}

		if (makeZoneAnnoArr.count == 3) {

			CDAnno *anno  = makeZoneAnnoArr.lastObject;
			[self.mapView removeAnnotation:anno];


			[self.mapView removeOverlays:makeZoneArr];
			[makeZoneArr removeAllObjects];

			[makeZoneAnnoArr removeLastObject];

			[self mapInfoUp];

			self.addAnnoCenter.hidden = NO;
		}

		if (makeZoneAnnoArr.count > 3) {

			[self.mapView removeOverlays:makeZoneArr];
			[makeZoneArr removeAllObjects];


			CDAnno *anno  = makeZoneAnnoArr.lastObject;
			[self.mapView removeAnnotation:anno];

			[makeZoneAnnoArr removeLastObject];

			CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * makeZoneAnnoArr.count);

			for (int i=0; i<makeZoneAnnoArr.count; i++) {
				CDAnno *anno = makeZoneAnnoArr[i];
				coords[i].latitude = anno.coordinate.latitude;
				coords[i].longitude  = anno.coordinate.longitude;
			}

			BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:makeZoneAnnoArr.count];

			[makeZoneArr addObject:polygon];
			[_mapView addOverlay:polygon];

		}


	}


}

- (IBAction)closeMakeClick:(id)sender {

	[imagespost removeAllObjects];
	[_selectedPhotos removeAllObjects];
	[self.upLoadPicBtn setImage:[UIImage imageNamed:@"btn_image"] forState:UIControlStateNormal];
	[self.uploadCount setTitle:nil forState:UIControlStateNormal];

	self.styleShowImageView.image = nil;

	if (isMakeLine) {
		self.closeMakeBtn.hidden =YES;
		self.returnMakeBtn.hidden =YES;
		self.addLinePoint.hidden = YES;
		self.addAnnoCenter.hidden = YES;
		[self addBtnAllShow];

		[self.mapView removeAnnotations:makeLineAnnoArr];
		[makeLineAnnoArr removeAllObjects];
		[self.mapView removeOverlays:makeLineArr];
		[makeLineArr removeAllObjects];

		lineMakeAnno = nil;

		isMakeLine = NO;
		lineTotolDistance = 0;

		[self mapInfoUp];
	}else
		if (isMakeZone) {
			self.closeMakeBtn.hidden =YES;
			self.returnMakeBtn.hidden =YES;
			self.addZonePoint.hidden = YES;
			self.addAnnoCenter.hidden = YES;
			[self addBtnAllShow];

			[self.mapView removeAnnotations:makeZoneAnnoArr];
			[makeZoneAnnoArr removeAllObjects];
			[self.mapView removeOverlays:makeZoneArr];
			[makeZoneArr removeAllObjects];
			[self.mapView removeOverlays:makeLineArr];
			[makeLineArr removeAllObjects];

			[self mapInfoUp];
			isMakeZone = NO;
		}
}

@end
