//
//  LDGameOverScene.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 27/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LDGameOverScene : SKScene {
    int _score;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *indicatorView;
}

@end
