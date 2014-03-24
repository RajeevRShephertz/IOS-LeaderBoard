//
//  LDViewController.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 14/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWFacebookHelper.h"

@interface LDViewController : UIViewController <PWFacebookHelperDelegate,UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *scoreTextField;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;
@property (retain, nonatomic) IBOutlet UIButton *fbButton;
@property (retain, nonatomic) IBOutlet UIView *fbView;

- (IBAction)submitAction:(id)sender;
- (IBAction)LeaderBoardButtonAction:(id)sender;

@end
