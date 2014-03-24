//
//  LDLeaderBoard.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 18/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWFacebookHelper.h"
#import "LDConstants.h"

@interface LDLeaderBoard : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *leaderboardTableView;
    IBOutlet UIButton *backButton;
    NSMutableArray *scoreList;
    IBOutlet UIView *indicatorView;
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
    IBOutlet UIButton *globalButton;
    IBOutlet UIButton *friendsButton;
    int colorChanger;
    IBOutlet UILabel *messageLabel;
    IBOutlet UILabel *nameTitleLabel;
    IBOutlet UILabel *rankTitleLabel;
    IBOutlet UILabel *scoreTitleLabel;
    int rowHeight;
}

-(void)showAcitvityIndicator;
-(void)removeAcitvityIndicator;
-(void)getScore;
-(void)getFriendsScores;
-(IBAction)globalButtonClicked:(id)sender;
-(IBAction)friendsButtonClicked:(id)sender;
-(IBAction)backButtonClicked:(id)sender;


@end
