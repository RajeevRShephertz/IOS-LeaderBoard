//
//  PWFacebookHelper.h
//  PlayWithWords
//
//  Created by shephertz technologies on 09/05/13.
//  Copyright (c) 2013 shephertz technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;
@protocol PWFacebookHelperDelegate;
@interface PWFacebookHelper : NSObject
{
    NSOperationQueue *_imageDownloadQueue;
    BOOL m_postingInProgress;
}
@property (nonatomic, assign) id<PWFacebookHelperDelegate> delegate;
@property(nonatomic,retain) FBSession       *loggedInSession;
@property(nonatomic,retain) NSString        *userName;
@property(nonatomic,retain) NSString        *userId;
@property(nonatomic,retain) NSMutableDictionary    *userInfoDict;
+(PWFacebookHelper *)sharedInstance;

-(BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
-(void)sessionStateChanged:(FBSession *)session
                     state:(FBSessionState) state
                     error:(NSError *)error;

-(void)getUserDetails;
-(void)getFriends;
-(void)shareSnapshot:(UIImage*)snapShot;
-(void)getFriendsPlayingThisGame;
-(void)downloadFacebookImage:(NSDictionary*)dict;
-(void)loadFreindsImageWithImageView:(NSDictionary*)dict;
-(void)loginToFacebook;
-(void)inviteFacebookFreind:(NSString*)uid;
-(void)getFriendsNotPlayingThisGame;

-(void) postWithText: (NSString*) message
           ImageName: (NSString*) image
                 URL: (NSString*) url
             Caption: (NSString*) caption
                Name: (NSString*) name
      andDescription: (NSString*) description;

-(void) postToWall: (NSMutableDictionary*) params;
@end



@protocol PWFacebookHelperDelegate<NSObject>

@optional

    -(void)fbDidNotLogin:(BOOL)cancelled;
    -(void)userDidLoggedOut;
    -(void)userDidLoggedIn;
    -(void)friendListRetrieved:(NSArray *)friends;
    -(void)snapshotSharedToTheWall;
    -(void)snapshotSharingFailed;
    -(void)messageSharingDialogRemoved;
    -(void)removeParentViewIncaseOfNetworkFailure;
    -(void)relationShipRetrieved:(BOOL)isFriend;

@end

