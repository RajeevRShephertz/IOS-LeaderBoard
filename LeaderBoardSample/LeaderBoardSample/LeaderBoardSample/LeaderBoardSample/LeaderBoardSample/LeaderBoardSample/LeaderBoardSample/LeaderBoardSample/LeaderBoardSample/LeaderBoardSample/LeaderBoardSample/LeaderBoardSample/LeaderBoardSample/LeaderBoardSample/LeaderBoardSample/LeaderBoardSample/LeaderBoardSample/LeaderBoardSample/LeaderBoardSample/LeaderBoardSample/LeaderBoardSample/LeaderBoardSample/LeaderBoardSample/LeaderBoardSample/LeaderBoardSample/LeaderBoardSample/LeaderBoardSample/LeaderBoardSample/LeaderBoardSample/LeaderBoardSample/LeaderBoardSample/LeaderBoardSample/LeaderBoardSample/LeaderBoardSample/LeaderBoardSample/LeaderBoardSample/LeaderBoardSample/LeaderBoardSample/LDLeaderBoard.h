//
//  LDLeaderBoard.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 18/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDLeaderBoard : UIViewController {
    IBOutlet UITableView *userRecordsTableView;
    IBOutlet UISegmentedControl *LDTypeSegment;
    
    IBOutlet UIView *indicatorView;
    IBOutlet UIActivityIndicatorView *activityIndicatorView;

    NSMutableArray *scoreList;

}
- (IBAction)segmentValuechanged:(id)sender;

@end
