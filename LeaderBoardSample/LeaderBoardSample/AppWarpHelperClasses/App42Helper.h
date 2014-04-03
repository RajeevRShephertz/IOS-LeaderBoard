//
//  App42Helper.h
//  Cocos2DSimpleGame
//
//  Created by Shephertz Technology on 03/04/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h"

@interface App42Helper : NSObject {
    BOOL _app42Intialized;
}

@property (nonatomic,retain) NSString *userID;
@property (nonatomic,assign) int      score;

+(App42Helper *)sharedApp42Helper ;

//App42CloudAPI Handler Methods

-(void)saveScore;
-(NSMutableArray*)getScores ;
-(NSMutableArray *) getFBFriendScores ;


@end
