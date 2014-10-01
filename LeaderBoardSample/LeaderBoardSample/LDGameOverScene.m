//
//  LDGameOverScene.m
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 27/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "LDGameOverScene.h"
#import "App42Helper.h"
#import "LDGameScene.h"
#import "AppHypeHelper.h"

@implementation LDGameOverScene
@synthesize obstacleCount = _obstacleCount;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

    }
    return self;
}

- (void)dealloc {
    activityIndicatorView = nil;
    indicatorView = nil;
    loadingLabel = nil;
    fbButtonView = nil;
}

-(void)initializeGameOverView {
    
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    NSString * message;
    message = @"Game Over";
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.text = message;
    label.fontSize = 40;
    label.fontColor = [SKColor blackColor];
    label.position = CGPointMake(self.size.width/2, self.size.height/2 + 50 );
    [self addChild:label];
    
    _score = _obstacleCount * 50;
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %d",_score];
    scoreLabel.fontSize = 40;
    scoreLabel.fontColor = [SKColor blackColor];
    scoreLabel.position = CGPointMake(self.size.width/2, 100+ 50);
    [self addChild:scoreLabel];
    
    SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    retryButton.text = @"Play again";
    retryButton.fontColor = [SKColor blackColor];
    retryButton.position = CGPointMake(self.size.width/2, 100);
    retryButton.name = @"Retry";
    [retryButton setFontSize:20];
    [self addChild:retryButton];
    
    NSString * submit;
    submit = @"Submit score";
    SKLabelNode *submitButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    submitButton.text = submit;
    submitButton.fontColor = [SKColor blackColor];
    submitButton.position = CGPointMake(self.size.width/2, 50 );
    submitButton.name = @"submit";
    [submitButton setFontSize:20];
    [self addChild:submitButton];
    
    AppHypeHelper *appHypeHelper = [AppHypeHelper sharedAppHypeHelper] ;
    if (([appHypeHelper adcounter]==1)&&[appHypeHelper isAdAvailable:kInterstitial])
    {
        [appHypeHelper showInterstitialAd];
    }
    else if (([appHypeHelper adcounter]==2)&&[appHypeHelper isAdAvailable:kVideo])
    {
        [appHypeHelper showVideoAd];
    }
    
}

-(void)showAcitvityIndicator
{
    if (!activityIndicatorView)
    {
        indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        [indicatorView setBackgroundColor:[UIColor blackColor]];
        [indicatorView setCenter:self.view.center];
        [indicatorView setAlpha:0.8];
        [[indicatorView layer] setCornerRadius:0.7f];
        [self.view addSubview:indicatorView];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView startAnimating];
        [self.view addSubview:activityIndicatorView];
        [activityIndicatorView setCenter:self.view.center];
        
        loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, indicatorView.frame.size.height - 30, indicatorView.frame.size.width, 30)];
        [indicatorView addSubview:loadingLabel];
        [loadingLabel setBackgroundColor:[UIColor clearColor]];
        [loadingLabel setTextColor:[UIColor whiteColor]];
        [loadingLabel setTextAlignment:NSTextAlignmentCenter];
        [loadingLabel setText:@"Loading..."];
        [loadingLabel setAdjustsFontSizeToFitWidth:YES];
    }
    else
    {
        [activityIndicatorView startAnimating];
        [indicatorView setHidden:NO];
    }
    [self.view setUserInteractionEnabled:NO];

}

-(void)removeAcitvityIndicator
{
    [self.view setUserInteractionEnabled:YES];
    [activityIndicatorView stopAnimating];
    [indicatorView setHidden:YES];
}

-(void)showFbButtonView
{
    if (fbButtonView)
    {
        if ([fbButtonView superview])
        {
            [fbButtonView removeFromSuperview];
        }
    }
    fbButtonView = nil;
    
    fbButtonView = [[UIView alloc] initWithFrame:self.frame];
    [fbButtonView setBackgroundColor:[UIColor clearColor]];

    UIView *containerView = [[UIView alloc] initWithFrame:fbButtonView.frame];
    [containerView setBackgroundColor:[UIColor clearColor]];
    [fbButtonView addSubview:containerView];
    [containerView setCenter:fbButtonView.center];

    UIView *transarentView = [[UIView alloc] initWithFrame:fbButtonView.frame];
    [transarentView setBackgroundColor:[UIColor blackColor]];
    [transarentView setAlpha:0.8];
    [containerView addSubview:transarentView];
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:fbButtonView.frame];
    [containerView addSubview:dismissButton];
    [dismissButton addTarget:self action:@selector(dismissFbView:) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setCenter:fbButtonView.center];


    UIImage *image = [UIImage imageNamed:@"Login_facebook.png"];
    UIButton *FBbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [image size].width, [image size].height)];
    [FBbutton setBackgroundImage:image forState:UIControlStateNormal];
    [containerView addSubview:FBbutton];
    [FBbutton addTarget:self action:@selector(FBbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [FBbutton setCenter:fbButtonView.center];
    [FBbutton setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:fbButtonView];
}

- (void)dismissFbView:(id)sender {
    if (fbButtonView) {
        [fbButtonView removeFromSuperview];
    }
    fbButtonView = nil;
}

- (void)FBbuttonAction:(id)sender {
    [self logInWithFacebook];
}

-(void)logInWithFacebook {
    [self showAcitvityIndicator];
    [loadingLabel setText:@"Loging in To Facebook.."];
    [[PWFacebookHelper sharedInstance] setDelegate:self];
    [[PWFacebookHelper sharedInstance] openSessionWithAllowLoginUI:YES];
}

- (void) loginDoneSubmitScore {
    [self showAcitvityIndicator];
    [loadingLabel setText:@"Submitting score.."];
    NSString *anID = [[PWFacebookHelper sharedInstance] userId];
    NSLog(@"%@",anID);
    if ([anID length]) {
        [[App42Helper sharedApp42Helper] setUserID:[[PWFacebookHelper sharedInstance] userId]];
        __block BOOL _success = false;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[App42Helper sharedApp42Helper] setScore:_score];
            _success = [[App42Helper sharedApp42Helper] saveScore];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self removeAcitvityIndicator];
                if (_success) {
                    [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Score submitted successfully" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Oooops!!" message:@"Score submission failed" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
                }
                [self.view removeFromSuperview];
            });
        });
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"submit"]) {
        if ([[PWFacebookHelper sharedInstance] userId]) {
            [self loginDoneSubmitScore];
        } else {
            [self showFbButtonView];
        }
    } else if ([node.name isEqualToString:@"Retry"]) {
        SKScene * scene = [LDGameScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [self.view presentScene:scene];
    }
}

#pragma mark - PWFacebookHelper Delegate
-(void)fbDidNotLogin:(BOOL)cancelled {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error:" message: @"Facebook Login Failed!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self removeAcitvityIndicator];
}

-(void)userDidLoggedIn {
    NSLog(@"%s",__FUNCTION__);
    [self loginDoneSubmitScore];
}


@end
