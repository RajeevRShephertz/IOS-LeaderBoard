//
//  AppWarpHelper.h
//  Cocos2DSimpleGame
//
//  Created by Shephertz Technology on 06/08/12.
//  Copyright (c) 2012 ShephertzTechnology PVT LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h"

@interface AppWarpHelper : NSObject
{
    ServiceAPI *serviceAPIObject;
    int numberOfPlayers;
    NSTimer *timer;
}
@property(nonatomic,retain) id delegate;
@property (nonatomic,retain) NSString *roomId;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *emailId;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *enemyName;
@property (nonatomic,assign) BOOL     alreadyRegistered;
@property (nonatomic,assign) int      score;
@property (nonatomic,assign) int      numberOfPlayers;

+(AppWarpHelper *)sharedAppWarpHelper;
-(void)initializeAppWarp;
-(void)setCustomDataWithData:(NSData*)data;
-(void)receivedEnemyStatusData:(NSData*)data;
-(void)getAllUsers;
-(BOOL)registerUser;
-(BOOL)signInUser;
-(void)saveScore;
-(NSMutableArray*)getScores;
- (NSMutableArray *) getFBFriendScores;

-(void)disconnectWarp;
-(void)connectToWarp;
-(void)recoverConnection;
-(void)scheduleRecover;
-(void)unScheduleRecover;
-(void)onConnectionFailure:(NSDictionary*)messageDict;
@end
