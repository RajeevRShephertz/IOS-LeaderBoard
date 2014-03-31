//
//  LDViewController.m
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 14/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "LDViewController.h"
#import "AppWarpHelper.h"
#import "LDLeaderBoard.h"
#import "LDGameScene.h"

@interface LDViewController ()

@end

@implementation LDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *anID = [[PWFacebookHelper sharedInstance] userId];
    if ([anID length]) {
        [[AppWarpHelper sharedAppWarpHelper] setUserName:[[PWFacebookHelper sharedInstance] userId]];
        [_fbView setHidden:YES];
    } else {
        [_fbView setHidden:NO];
    }

    [_leaderBoardButton setHidden:YES];
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

-(void)logInWithFacebook {
    [[PWFacebookHelper sharedInstance] setDelegate:self];
    BOOL isOpen = [[PWFacebookHelper sharedInstance] openSessionWithAllowLoginUI:YES];
    NSLog(@"isSessionOpen=%d",isOpen);
}

#pragma mark - IBActions Methods
- (IBAction)playAction:(id)sender {
    CGRect _frame  =CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    SKView * skView = [[SKView alloc] initWithFrame:_frame];

    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [LDGameScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
    [[self view] addSubview:skView];
    [_leaderBoardButton setHidden:NO];
}

-(IBAction)facebookLogInButtonAction:(id)sender {
    [self logInWithFacebook];
}

- (IBAction)LeaderBoardButtonAction:(id)sender {
    LDLeaderBoard *aLDView = [[LDLeaderBoard alloc] initWithNibName:@"LDLeaderBoard" bundle:nil];
    [[self view] addSubview:[aLDView view]];
}


#pragma mark - PWFacebookHelper Delegate
-(void)fbDidNotLogin:(BOOL)cancelled {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error:" message: @"Login Failed!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)userDidLoggedIn {
    NSLog(@"%@",[[PWFacebookHelper sharedInstance] userId]);
    NSString *anID = [[PWFacebookHelper sharedInstance] userId];
    if ([anID length]) {
        [[AppWarpHelper sharedAppWarpHelper] setUserName:[[PWFacebookHelper sharedInstance] userId]];
        [_fbView setHidden:YES];
    }
}

@end
