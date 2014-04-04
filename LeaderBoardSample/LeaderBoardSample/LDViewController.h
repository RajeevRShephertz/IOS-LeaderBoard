//
//  LDViewController.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 14/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface LDViewController : UIViewController 
@property (retain, nonatomic) IBOutlet UIButton *leaderBoardButton;

- (IBAction)playAction:(id)sender;
- (IBAction)LeaderBoardButtonAction:(id)sender;

@end