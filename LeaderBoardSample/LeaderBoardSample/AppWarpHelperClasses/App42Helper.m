//
//  App42Helper.m
//  Cocos2DSimpleGame
//
//  Created by Shephertz Technology on 03/04/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "App42Helper.h"
#import "LDConstants.h"
#import "PWFacebookHelper.h"


static App42Helper *app42Instance;

@implementation App42Helper
@synthesize userID  = _userID;
@synthesize score = _score;

+(App42Helper *)sharedApp42Helper {
	if(app42Instance == nil){
		app42Instance = [[self alloc] init];
	}
	return app42Instance;
}

- (id) init {
	self = [super init];
	if (self != nil) {
        _userID    = nil;
        _app42Intialized = false;
        _score = 0;
	}
	return self;
}

- (void)dealloc {
    if (_userID) {
        _userID=nil;
    }
}

#pragma mark --App42CloudAPI Handler Methods

-(void)saveScore {
    if (!_app42Intialized) {
        [App42API initializeWithAPIKey:APP42_APP_KEY andSecretKey:APP42_SECRET_KEY];
        [App42API setDbName:DB_NAME];
        _app42Intialized = true;
    }
    @try {
        NSString *name = [[PWFacebookHelper sharedInstance] userName];
        ScoreBoardService *scoreboardService = [App42API buildScoreBoardService];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_userID,@"UserID",[NSNumber numberWithInt:_score],@"Score",name,@"Name", nil];
        [scoreboardService addCustomScore:dict collectionName:COLLECTION_NAME];

        Game *game=[scoreboardService saveUserScore:GAME_NAME gameUserName:_userID gameScore:_score];
        if(game.isResponseSuccess) {
            NSLog(@"saveScore Success");
            [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Your score submitted successfully" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        }
    }
    @catch (App42Exception *exception) {
        NSLog(@"%@",[exception description]);
    }
    
}

-(NSMutableArray*)getScores {
    if (!_app42Intialized) {
        [App42API initializeWithAPIKey:APP42_APP_KEY andSecretKey:APP42_SECRET_KEY];
        [App42API setDbName:DB_NAME];
        _app42Intialized = true;
    }

    ScoreBoardService *scoreboardService = [App42API buildScoreBoardService];
    [scoreboardService setQuery:COLLECTION_NAME metaInfoQuery:Nil];

    Game *game=[scoreboardService getTopNRankers:GAME_NAME max:MAX_NUMBER_OF_RECORDS_DISPLAYED_IN_LB];
    NSMutableArray *scoreList = game.scoreList;
    return scoreList;
}

-(NSMutableArray *) getFBFriendScores {
    if (!_app42Intialized) {
        [App42API initializeWithAPIKey:APP42_APP_KEY andSecretKey:APP42_SECRET_KEY];
        [App42API setDbName:DB_NAME];
        _app42Intialized = true;
    }

    ScoreBoardService *scoreboardService = [App42API buildScoreBoardService];
    [scoreboardService setQuery:COLLECTION_NAME metaInfoQuery:Nil];
    
    NSString *accessToken = [[[[PWFacebookHelper sharedInstance] loggedInSession] accessTokenData] accessToken];
    Game *game=[scoreboardService getTopNRankersFromFacebook:GAME_NAME fbAccessToken:accessToken max:MAX_NUMBER_OF_RECORDS_DISPLAYED_IN_LB];
    NSMutableArray *scoreList = game.scoreList;
    return scoreList;
}

@end
