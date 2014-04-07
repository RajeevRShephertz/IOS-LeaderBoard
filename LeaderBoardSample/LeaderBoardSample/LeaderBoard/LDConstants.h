//
//  LDConstants.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 18/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <Foundation/Foundation.h>


#define APP42_APP_KEY         <Your App Key>
#define APP42_SECRET_KEY      <Your Secret Key>

#define GAME_NAME             <Your Game Name>

#define DB_NAME               @"ScoreDB"
#define COLLECTION_NAME       @"ScoreCollection"

#define MAX_NUMBER_OF_RECORDS_DISPLAYED_IN_LB   20
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define  FACEBOOKPROFILEIMAGES_FOLDER_PATH	[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/FacebookProfileImages"]
#define FACEBOOK_REFRESHED_DATE   @"facebookPicsLastRefreshedOn"
