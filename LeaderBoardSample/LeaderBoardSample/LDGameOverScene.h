//
//  LDGameOverScene.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 27/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PWFacebookHelper.h"

@interface LDGameOverScene : SKScene <PWFacebookHelperDelegate>{
    int _score;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *indicatorView;
    UILabel *loadingLabel;
    
    UIView *fbButtonView;
}
@property (nonatomic, assign) int obstacleCount;

-(void)initializeGameOverView;
-(void)showAcitvityIndicator;
-(void)removeAcitvityIndicator;
-(void)logInWithFacebook;

@end
