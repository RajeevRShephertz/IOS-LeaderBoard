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
    [_scoreTextField resignFirstResponder];
}

-(void)logInWithFacebook {
    [[PWFacebookHelper sharedInstance] setDelegate:self];
    BOOL isOpen = [[PWFacebookHelper sharedInstance] openSessionWithAllowLoginUI:YES];
    NSLog(@"isSessionOpen=%d",isOpen);
}

#pragma mark - IBActions Methods
- (IBAction)submitAction:(id)sender {
    [_scoreTextField resignFirstResponder];
    int score = 0;
    if ([[_scoreTextField text] length]) {
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[_scoreTextField text]];
        valid = [alphaNums isSupersetOfSet:inStringSet];
        
        if(valid) {
            NSLog(@"Match");
            score = [[_scoreTextField text] intValue];
            [[AppWarpHelper sharedAppWarpHelper] setScore:score];
            [[AppWarpHelper sharedAppWarpHelper] saveScore];
            [_scoreTextField setText:@""];
        } else {
            NSLog(@"Not matched");
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Ooops!!" message:@"Invalid Score, Please provide valid inputs" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [_alert show];
        }

    } else {
        NSLog(@"Empty Score");
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Ooops!!" message:@"Invalid Score, Please provide valid inputs" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [_alert show];

    }
}

-(IBAction)facebookLogInButtonAction:(id)sender {
    [_scoreTextField resignFirstResponder];
    [self logInWithFacebook];
}

- (IBAction)LeaderBoardButtonAction:(id)sender {
    LDLeaderBoard *aLDView = [[LDLeaderBoard alloc] initWithNibName:@"LDLeaderBoard" bundle:nil];
    [[self view] addSubview:[aLDView view]];
}

#pragma mark - Text Field Delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
