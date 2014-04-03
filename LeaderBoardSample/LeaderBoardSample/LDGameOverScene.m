//
//  LDGameOverScene.m
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 27/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "LDGameOverScene.h"
#import "App42Helper.h"

@implementation LDGameOverScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // 1
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        // 2
        NSString * message;
        message = @"Game Over";
        // 3
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        _score = arc4random()%3000;
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        scoreLabel.text = [NSString stringWithFormat:@"Score: %d",_score];
        scoreLabel.fontSize = 40;
        scoreLabel.fontColor = [SKColor blackColor];
        scoreLabel.position = CGPointMake(self.size.width/2, 100);
        [self addChild:scoreLabel];
        
        NSString * submit;
        submit = @"Submit";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = submit;
        retryButton.fontColor = [SKColor blackColor];
        retryButton.position = CGPointMake(self.size.width/2, 50);
        retryButton.name = @"submit";
        [retryButton setScale:.5];
        
        [self addChild:retryButton];
        
        
    }
    return self;
}

- (void)dealloc {
    activityIndicatorView = nil;
    indicatorView = nil;
}

-(void)showAcitvityIndicator {
    if (!activityIndicatorView) {
        indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [indicatorView setBackgroundColor:[UIColor blackColor]];
        [indicatorView setCenter:self.view.center];
        [indicatorView setAlpha:0.8];
        [self.view addSubview:indicatorView];

        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView startAnimating];
        [self.view addSubview:activityIndicatorView];
        [activityIndicatorView setCenter:self.view.center];
    } else {
        [activityIndicatorView startAnimating];
        [indicatorView setHidden:NO];
    }
}

-(void)removeAcitvityIndicator {
    [activityIndicatorView stopAnimating];
    [indicatorView setHidden:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    __block BOOL _success = false;
    if ([node.name isEqualToString:@"submit"]) {
        [self showAcitvityIndicator];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[App42Helper sharedApp42Helper] setScore:_score];
             _success = [[App42Helper sharedApp42Helper] saveScore];

            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self removeAcitvityIndicator];
                if (_success) {
                    [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Your score submitted successfully" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your score submit Failed" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
                }
                [self.view removeFromSuperview];
            });
        });
    }
}

@end
