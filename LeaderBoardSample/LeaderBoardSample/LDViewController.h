//
//  LDViewController.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 14/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWFacebookHelper.h"
#import <SpriteKit/SpriteKit.h>

@interface LDViewController : UIViewController <PWFacebookHelperDelegate>
@property (retain, nonatomic) IBOutlet UIButton *fbButton;
@property (retain, nonatomic) IBOutlet UIView *fbView;
@property (retain, nonatomic) IBOutlet UIButton *leaderBoardButton;

- (IBAction)playAction:(id)sender;
- (IBAction)LeaderBoardButtonAction:(id)sender;

@end
/*


 SKView * skView = (SKView *)self.view;
 
 if (!skView.scene) {
 skView.showsFPS = YES;
 skView.showsNodeCount = YES;
 
 // Create and configure the scene.
 SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
 scene.scaleMode = SKSceneScaleModeAspectFill;
 
 // Present the scene.
 [skView presentScene:scene];
 }

*/



/*

 */