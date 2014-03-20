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
@property (weak, nonatomic) IBOutlet UITextField *scoreTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIView *fbView;

- (IBAction)submitAction:(id)sender;

@end
