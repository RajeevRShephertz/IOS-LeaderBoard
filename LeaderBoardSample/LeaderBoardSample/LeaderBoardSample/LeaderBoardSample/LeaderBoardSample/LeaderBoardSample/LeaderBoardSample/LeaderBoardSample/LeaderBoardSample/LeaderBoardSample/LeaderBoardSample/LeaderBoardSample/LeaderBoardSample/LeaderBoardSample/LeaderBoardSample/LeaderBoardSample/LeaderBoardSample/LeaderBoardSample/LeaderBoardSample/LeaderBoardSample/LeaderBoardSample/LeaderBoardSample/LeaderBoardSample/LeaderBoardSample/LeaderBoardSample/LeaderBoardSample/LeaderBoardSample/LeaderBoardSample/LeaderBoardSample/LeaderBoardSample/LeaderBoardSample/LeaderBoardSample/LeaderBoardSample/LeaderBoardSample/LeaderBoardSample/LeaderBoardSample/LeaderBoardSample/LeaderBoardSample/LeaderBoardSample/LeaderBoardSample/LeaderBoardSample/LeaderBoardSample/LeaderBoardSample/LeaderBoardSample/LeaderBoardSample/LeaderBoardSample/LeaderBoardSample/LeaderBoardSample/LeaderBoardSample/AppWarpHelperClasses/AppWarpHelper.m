//
//  AppWarpHelper.m
//  Cocos2DSimpleGame
//
//  Created by Shephertz Technology on 06/08/12.
//  Copyright (c) 2012 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "AppWarpHelper.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "ConnectionListener.h"
#import "RoomListener.h"
#import "NotificationListener.h"
#import "LDConstants.h"
#import "PWFacebookHelper.h"


static AppWarpHelper *appWarpHelper;

@implementation AppWarpHelper

@synthesize delegate,roomId,userName,enemyName,emailId,password,alreadyRegistered,score,numberOfPlayers;
+(AppWarpHelper *)sharedAppWarpHelper
{
	if(appWarpHelper == nil)
	{
		appWarpHelper = [[self alloc] init];
	}
	return appWarpHelper;
}

- (id) init
{
	self = [super init];
	if (self != nil)
    {
        delegate    = nil;
        enemyName   = nil;
        userName    = nil;
        emailId     = nil;
        password    = nil;
        alreadyRegistered = NO;
		self.roomId = nil;
        numberOfPlayers = 0;
        serviceAPIObject = nil;
        timer = nil;
	}
	return self;
}

- (void)dealloc
{
    if (delegate)
    {
        self.delegate=nil;
    }
    if (roomId)
    {
        self.roomId=nil;
    }
    if (userName)
    {
        self.userName=nil;
    }
    if (enemyName)
    {
        self.enemyName=nil;
    }
    if (emailId)
    {
        self.emailId=nil;
    }
    if (serviceAPIObject)
    {
//        [serviceAPIObject release];
        serviceAPIObject=nil;
    }
//    [super dealloc];
}



#pragma mark -------------

-(void)initializeAppWarp
{
    
   // NSLog(@"%s",__FUNCTION__);
    [WarpClient initWarp:APPWARP_APP_KEY secretKey:APPWARP_SECRET_KEY];
    
    
    WarpClient *warpClient = [WarpClient getInstance];
    [warpClient setRecoveryAllowance:60];
    
    ConnectionListener *connectionListener = [[ConnectionListener alloc] initWithHelper:self];
    [warpClient addConnectionRequestListener:connectionListener];
    [warpClient addZoneRequestListener:connectionListener];
//    [connectionListener release];
    
    RoomListener *roomListener = [[RoomListener alloc]initWithHelper:self];
    [warpClient addRoomRequestListener:roomListener];
//    [roomListener release];
    
    NotificationListener *notificationListener = [[NotificationListener alloc]initWithHelper:self];
    [warpClient addNotificationListener:notificationListener];
//    [notificationListener release];
}

-(void)disconnectWarp
{
    
    [[WarpClient getInstance] unsubscribeRoom:roomId];
    [[WarpClient getInstance] leaveRoom:roomId];
    [[WarpClient getInstance] disconnect];
    
}

-(void)connectToWarp
{
    [[WarpClient getInstance] connectWithUserName:userName];
}

-(void)scheduleRecover
{
    if (!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(recoverConnection) userInfo:nil repeats:YES];
    }
}

-(void)unScheduleRecover
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

-(void)recoverConnection
{
    NSLog(@"%s",__FUNCTION__);
   [[WarpClient getInstance] recoverConnection];
}



#pragma mark-------------
#pragma mark --App42CloudAPI Handler Methods
#pragma mark-------------

-(BOOL)registerUser
{
    if (!serviceAPIObject)
    {
        serviceAPIObject = [[ServiceAPI alloc]init];//Allocate service api object
        serviceAPIObject.apiKey = APPWARP_APP_KEY;//assign api key
        serviceAPIObject.secretKey = APPWARP_SECRET_KEY;//assign secret key
        [App42API setDbName:DB_NAME];
    }
    
    
    UserService *userService = [serviceAPIObject buildUserService];
    
    
    @try
    {
        
        User *user = [userService createUser:userName password:password emailAddress:emailId];
//        [user release];
        return YES;
        
    }
    @catch (App42BadParameterException *ex)
    {
        // Exception Caught
        // Check if User already Exist by checking app error code
        if (ex.appErrorCode == 2001)
        {
            // Do exception Handling for Already created User.
            NSLog(@"Bad Parameter Exception found. User With this name already Exists or there is some bad parameter");
        }
        return NO;
    }
    @catch (App42SecurityException *ex)
    {
        // Exception Caught
        // Check for authorization Error due to invalid Public/Private Key
        if (ex.appErrorCode == 1401)
        {
            // Do exception Handling here
            NSLog(@"Security Exception found");
        }
        return NO;
    }
    @catch (App42Exception *ex)
    {
        // Exception Caught due to other Validation
        NSLog(@"App42 Exception found");
        return NO;
    }

}

-(BOOL)signInUser
{
    if (!serviceAPIObject)
    {
        serviceAPIObject = [[ServiceAPI alloc]init];//Allocate service api object
        serviceAPIObject.apiKey = APPWARP_APP_KEY;//assign api key
        serviceAPIObject.secretKey = APPWARP_SECRET_KEY;//assign secret key
        [App42API setDbName:DB_NAME];
    }
    
    UserService *userService = [serviceAPIObject buildUserService];
    App42Response *app42Response = [userService authenticateUser:userName password:password];
    if (app42Response.isResponseSuccess)
    {
        NSLog(@"LoggedIn");
        return YES;
    }
    else
    {
        NSLog(@"LogIn Failed");
        return NO;
    }
}

-(void)saveScore
{
    if (!serviceAPIObject)
    {
        [App42API setDbName:DB_NAME];
        serviceAPIObject = [[ServiceAPI alloc]init];//Allocate service api object
        serviceAPIObject.apiKey = APPWARP_APP_KEY;//assign api key.
        serviceAPIObject.secretKey = APPWARP_SECRET_KEY;//assign secret key
    }
    
    @try
    {
        NSString *name = [[PWFacebookHelper sharedInstance] userName];
        
        ScoreBoardService *scoreboardService = [serviceAPIObject buildScoreBoardService];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"UserID",[NSNumber numberWithInt:score],@"Score",name,@"Name", nil];
        [scoreboardService addCustomScore:dict collectionName:COLLECTION_NAME];

        Game *game=[scoreboardService saveUserScore:GAME_NAME gameUserName:userName gameScore:score];
//        [game release];
        if (enemyName)
        {
            self.enemyName=nil;
        }
    }
    @catch (App42Exception *exception)
    {
        
    }
    
}

-(NSMutableArray*)getScores {
    if (!serviceAPIObject) {
        serviceAPIObject = [[ServiceAPI alloc]init];//Allocate service api object
        serviceAPIObject.apiKey = APPWARP_APP_KEY;//assign api key
        serviceAPIObject.secretKey = APPWARP_SECRET_KEY;//assign secret key
        [App42API setDbName:DB_NAME];
    }
    ScoreBoardService *scoreboardService = [serviceAPIObject buildScoreBoardService];
    [scoreboardService setQuery:COLLECTION_NAME metaInfoQuery:Nil];

    Game *game=[scoreboardService getTopNRankers:GAME_NAME max:MAX_NUMBER_OF_RECORDS_DISPLAYED_IN_LB];
    NSMutableArray *scoreList = game.scoreList;
    for(Score *scoreObj in scoreList) {
        NSLog(@"userName=%@",scoreObj.userName);
        NSLog(@"Rank=%@",scoreObj.rank);
        NSLog(@"Value=%f",scoreObj.value);
    }
    
    
    return scoreList;
}

- (NSMutableArray *) getFBFriendScores {
    if (!serviceAPIObject) {
        serviceAPIObject = [[ServiceAPI alloc]init];//Allocate service api object
        serviceAPIObject.apiKey = APPWARP_APP_KEY;//assign api key
        serviceAPIObject.secretKey = APPWARP_SECRET_KEY;//assign secret key
        [App42API setDbName:DB_NAME];
    }
    ScoreBoardService *scoreboardService = [serviceAPIObject buildScoreBoardService];
    [scoreboardService setQuery:COLLECTION_NAME metaInfoQuery:Nil];
    
    NSString *accessToken = [[[[PWFacebookHelper sharedInstance] loggedInSession] accessTokenData] accessToken];
    Game *game=[scoreboardService getTopNRankersFromFacebook:GAME_NAME fbAccessToken:accessToken max:MAX_NUMBER_OF_RECORDS_DISPLAYED_IN_LB];
    NSMutableArray *scoreList = game.scoreList;
    return scoreList;
}

#pragma mark -------------

-(void)setCustomDataWithData:(NSData*)data
{
    if ([[WarpClient getInstance] getConnectionState]== CONNECTED)
    {
        [[WarpClient getInstance] sendUpdatePeers:data];
    }

}


-(void)receivedEnemyStatusData:(NSData*)data
{
    NSError *error = nil;
	NSPropertyListFormat plistFormat;
    //converting the data into plist supported object.
	if(! data)
	{
		return;
	}
	
	id contentObject = [NSPropertyListSerialization propertyListWithData:data options:0 format:&plistFormat error:&error];
	
	if(error)
	{
		NSLog(@"DataConversion Failed. ErrorDescription: %@",[error description]);
		return;
	}
}

-(void)getAllUsers
{
    [[WarpClient getInstance] getOnlineUsers];
}

-(void)sendGameRequest
{
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:userName,USER_NAME,@"",PLAYER_POSITION,@"",PROJECTILE_DESTINATION,@"",MOVEMENT_DURATION,[NSNumber numberWithBool:YES],IS_USER_JOINED_MESSAGE,nil];
}

-(void)onConnectionFailure:(NSDictionary*)messageDict
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: [messageDict objectForKey:@"title"]
                          message:[messageDict objectForKey:@"message"] 
                          delegate: self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
//    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
    {
		NSLog(@"user pressed OK");
	}
	else
    {
		NSLog(@"user pressed Cancel");
	}
}

@end
