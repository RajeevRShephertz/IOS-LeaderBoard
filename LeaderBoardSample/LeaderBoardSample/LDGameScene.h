//
//  LDGameScene.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 27/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface LDGameScene : SKScene <SKPhysicsContactDelegate> {
    int passedObstacleCount;
    int lifes;
}

@end
