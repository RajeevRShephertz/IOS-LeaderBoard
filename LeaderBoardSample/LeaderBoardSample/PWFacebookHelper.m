
//
//  PWFacebookHelper.m
//  PlayWithWords
//
//  Created by shephertz technologies on 09/05/13.
//  Copyright (c) 2013 shephertz technologies. All rights reserved.
//

#import "PWFacebookHelper.h"
#import "LDConstants.h"

NSString *const FBSessionStateChangedNotification =@"com.shephertz.funball.funball:FBSessionStateChangedNotification";

static PWFacebookHelper *fbHelper;

@implementation PWFacebookHelper
@synthesize userId,userName,loggedInSession,delegate;

+(PWFacebookHelper *)sharedInstance
{
    if (!fbHelper)
    {
        fbHelper = [[PWFacebookHelper alloc] init];
    }
    return fbHelper;
}

-(id)init
{
    if (self=[super init])
    {
        _imageDownloadQueue	= [[NSOperationQueue alloc] init];
    }
    return self;
}



-(void)dealloc
{
    if (self.loggedInSession)
    {
        self.loggedInSession = nil;
    }
    if (self.userName)
    {
        self.userName = nil;
    }
    
    if (self.userId)
    {
        self.userId = nil;
    }
    
    if (self.userInfoDict)
    {
        self.userInfoDict = nil;
    }
    
    if (_imageDownloadQueue)
    {
        [_imageDownloadQueue release];
        _imageDownloadQueue = nil;
    }
    [super dealloc];
}

#pragma mark-
#pragma mark-- Session Management Methods --
#pragma mark-


/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    //NSArray *permissions = [[NSArray arrayWithObjects:@"user_about_me,user_photos",
                              //nil] retain];
    return [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error)
                                        {
                                            NSLog(@"openSessionWithAllowLoginUI response");
                                            if (error)
                                            {
                                                NSLog(@"error=%@",error);
                                                if( self.delegate && [self.delegate respondsToSelector:@selector(fbDidNotLogin:)])
                                                {
                                                    [self.delegate fbDidNotLogin:YES];
                                                }
                                            }
                                            else
                                            {
                                                self.userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"facebookUserInfo"];
                                                NSLog(@"userInfoDict=%@",self.userInfoDict);
                                                //[self getUserDetails];
                                                if (self.userInfoDict)
                                                {
                                                    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
                                                    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
                                                    if( self.delegate && [self.delegate respondsToSelector:@selector(userDidLoggedIn)])
                                                    {
                                                        [self.delegate userDidLoggedIn];
                                                    }
                                                }
                                                else
                                                {
                                                    [self getUserDetails];
                                                    [self getFriends];
                                                }
                                                NSLog(@"self.userName=%@",self.userName);
                                            }
                                            
                                            [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                             NSLog(@"error=%@",[error description]);
                                         }];
}




- (void)loginToFacebook
{
    // this button's job is to flip-flop the session from open to closed
    if (loggedInSession.isOpen)
    {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [loggedInSession closeAndClearTokenInformation];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookUserInfo"];
        if( self.delegate && [self.delegate respondsToSelector:@selector(userDidLoggedOut)])
        {
            [self.delegate userDidLoggedOut];
        }
    }
    else
    {
        if (loggedInSession.state != FBSessionStateCreated)
        {
            // Create a new, logged out session.
            self.loggedInSession = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [loggedInSession openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error)
        {
            [self getUserDetails];
        }];
    }
}


-(void)getUserDetails
{
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error)
        {
             if (!error)
             {//facebookUserInfo
                 self.userId = [NSString stringWithFormat:@"%@",user.objectID];
                 [[NSUserDefaults standardUserDefaults] setObject:user.first_name forKey:@"userName"];
                 [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                 self.userName = user.first_name;
                 self.userInfoDict = [NSMutableDictionary dictionaryWithDictionary:user];
                 NSLog(@"userInfoDict=%@",self.userInfoDict);
                 [[NSUserDefaults standardUserDefaults] setObject:self.userInfoDict forKey:@"facebookUserInfo"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 if( self.delegate && [self.delegate respondsToSelector:@selector(userDidLoggedIn)])
                 {
                     [self.delegate userDidLoggedIn];
                 }
             }
            NSLog(@"error=%@",[error description]);
        }];
    }
}




-(void) postWithText: (NSString*) message
           ImageName: (NSString*) image
                 URL: (NSString*) url
             Caption: (NSString*) caption
                Name: (NSString*) name
      andDescription: (NSString*) description
{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   //url, @"link",
                                   //name, @"name",
                                   //caption, @"caption",
                                   //description, @"description",
                                   message, @"message",
                                   //UIImagePNGRepresentation([UIImage imageNamed: image]), @"picture",
                                   nil];
    
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound)
    {
        // No permissions found in session, ask for it
        [FBSession.activeSession requestNewPublishPermissions: [NSArray arrayWithObject:@"publish_actions"]
                                              defaultAudience: FBSessionDefaultAudienceFriends
                                            completionHandler: ^(FBSession *session, NSError *error)
         {
             if (!error)
             {
                 // If permissions granted and not already posting then publish the story
                 if (!m_postingInProgress)
                 {
                     [self postToWall: params];
                 }
             }
         }];
    }
    else
    {
        // If permissions present and not already posting then publish the story
        if (!m_postingInProgress)
        {
            [self postToWall: params];
        }
    }
}

-(void) postToWall: (NSMutableDictionary*) params
{
    m_postingInProgress = YES; //for not allowing multiple hits
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
         {
             //showing an alert for failure
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Post Failed"
                                       message:error.localizedDescription
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView show];
         }
         m_postingInProgress = NO;
     }];
}


-(void)inviteFacebookFreind:(NSString*)uid
{
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     // 2. Optionally provide a 'to' param to direct the request at
                                     uid, @"to", // Ali
                                     nil];
   // NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:@"Hi"
                                                    title:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error)
                                                      {
                                                          // Case A: Error launching the dialog or sending request.
                                                          NSLog(@"Error sending request.");
                                                      }
                                                      else
                                                      {
                                                          if (result == FBWebDialogResultDialogNotCompleted)
                                                          {
                                                              // Case B: User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          }
                                                          else
                                                          {
                                                              NSLog(@"Request Sent.");
                                                          }
                                                      }
                                                  }];
}


-(void)getFriends
{
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMyFriends] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *friends,
           NSError *error)
         {
             if (!error)
             {
                 NSArray *friendInfo = (NSArray *) [friends objectForKey:@"data"];
                 [[NSUserDefaults standardUserDefaults] setObject:self.userInfoDict forKey:@"facebookUserInfo"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 if( self.delegate && [self.delegate respondsToSelector:@selector(friendListRetrieved:)]) {
                     [self.delegate friendListRetrieved:friendInfo];
                 }
                 
             }
             NSLog(@"error=%@",[error description]);
         }];
    }
}













/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
            if (!error)
            {
                // We have a valid session
                //NSLog(@"User session found");
                [FBRequestConnection
                 startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                   NSDictionary<FBGraphUser> *user,
                                                   NSError *error)
                {
                     if (!error)
                     {
                         self.userId = user.objectID;
                         self.loggedInSession = FBSession.activeSession;
                     }
                 }];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


-(void)downloadFacebookImage:(NSDictionary*)dict
{
    [dict retain];
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																			selector:@selector(loadFreindsImageWithImageView:)
																			  object:dict];
	
	[_imageDownloadQueue addOperation:operation];
	
	[operation release];
    [dict release];
}


-(void)loadFreindsImageWithImageView:(NSDictionary*)dict
{
    [dict retain];
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	UIImageView *imageView = (UIImageView*)[dict objectForKey:@"imageView"];
	
	
	NSFileManager *filemanager = [NSFileManager defaultManager];
	UIImage *profileImage;
	NSData *profileImageData;
	if (![filemanager fileExistsAtPath:FACEBOOKPROFILEIMAGES_FOLDER_PATH])
	{
		[filemanager createDirectoryAtPath:FACEBOOKPROFILEIMAGES_FOLDER_PATH withIntermediateDirectories:NO attributes:nil error:nil];
	}
	NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png",FACEBOOKPROFILEIMAGES_FOLDER_PATH,[dict objectForKey:@"ID"]];
	
	
	profileImageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[dict objectForKey:@"ID"]]]];
	profileImage = [UIImage imageWithData:profileImageData];
	
    [profileImageData writeToFile:imagePath atomically:YES];
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:FACEBOOK_REFRESHED_DATE];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	
	[imageView setImage:profileImage];
	
	[(UIActivityIndicatorView*)[dict objectForKey:@"activityIndicator"] stopAnimating];
	
	[dict release];
	[pool release];
}






@end
