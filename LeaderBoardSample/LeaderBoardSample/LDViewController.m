//
//  LDViewController.m
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 14/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "LDViewController.h"
#import "App42Helper.h"
#import "LDLeaderBoard.h"
#import "LDGameScene.h"

@interface LDViewController ()

@end

@implementation LDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_leaderBoardButton setHidden:YES];
    
    [[App42Helper sharedApp42Helper] initializeApp42];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - IBActions Methods
- (IBAction)playAction:(id)sender {
    CGRect _frame  =CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    SKView * skView = [[SKView alloc] initWithFrame:_frame];

    if (!skView.scene) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        // Create and configure the scene.
        SKScene * scene = [LDGameScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
    [[self view] addSubview:skView];
    [_leaderBoardButton setHidden:NO];
}

- (IBAction)LeaderBoardButtonAction:(id)sender {
    NSString *anID = [[PWFacebookHelper sharedInstance] userId];
    if ([anID length]) {
        [[App42Helper sharedApp42Helper] setUserID:[[PWFacebookHelper sharedInstance] userId]];
        LDLeaderBoard *aLDView = [[LDLeaderBoard alloc] initWithNibName:@"LDLeaderBoard" bundle:nil];
        [[self view] addSubview:[aLDView view]];
    }
}


@end
