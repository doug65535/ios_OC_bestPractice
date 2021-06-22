//
//  teamsListView.h
  
//
//  Created by lucifer on 16/8/1.
 
//

#import <UIKit/UIKit.h>

@interface teamsListView : UIView


@property(nonatomic,strong)NSArray *teamsArr;



+(teamsListView *)instanceTextView;



typedef void(^passTeamId)(id);


@property (nonatomic, copy) passTeamId teamIdPass;

@end
