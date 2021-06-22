//
//  teamsListView.m
  
//
//  Created by lucifer on 16/8/1.
 
//

#import "teamsListView.h"
#import "teamListCell.h"


@interface teamsListView()<UITableViewDelegate,UITableViewDataSource>
{
    teamListCell *defaultTeam;
    NSIndexPath *lastIndexPath;
}
@property (weak, nonatomic) IBOutlet UITableView *teamList;

- (IBAction)creatNewTeam:(UIButton *)sender;

@end

@implementation teamsListView


+(teamsListView *)instanceTextView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"teamsListView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
  
      [self.teamList reloadData];
    }
    return self;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.teamsArr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (defaultTeam) {
        [defaultTeam.team_select setImage:nil];
    }
    
    if (lastIndexPath) {
        teamListCell *cell = [tableView cellForRowAtIndexPath:lastIndexPath];
        [cell.team_select setImage:nil];
    }

  teamListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.team_select setImage:[UIImage imageNamed:@"icon_select"]];
    lastIndexPath = indexPath;
    
    //切换地图列表
    CDTeamInfo *teamInfo =self.teamsArr[indexPath.row];

	

    self.teamIdPass(teamInfo);

		//关闭
	self.hidden =YES;
	
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *indentifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
//    if(!cell){
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
//    }
    [tableView registerNib:[UINib nibWithNibName:@"teamListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    teamListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    CDTeamInfo *teamInfo = self.teamsArr[indexPath.row];

    [cell.team_icon sd_setImageWithURL:[NSURL URLWithString:teamInfo.logo]];
    cell.team_name.text = teamInfo.team_name;
    
    CDAcount *acount = [CDAcount accountFromSandbox];
    
    if (teamInfo.team_id == acount.default_team_id) {
    [cell.team_select setImage:[UIImage imageNamed:@"icon_select"]];
            defaultTeam = cell;
    }else
    {
        [cell.team_select setImage:nil];
    }
    
    return cell;
}

- (IBAction)creatNewTeam:(UIButton *)sender {
    
}
@end
