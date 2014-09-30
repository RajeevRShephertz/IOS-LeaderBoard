//
//  AppHype.h
//  AppHype_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 29/07/14.
//  Copyright (c) 2014 Shephertz Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "AppHypeConstants.h"
#import "AppHypeException.h"

@protocol AppHypeListener <NSObject>

-(void)onAdAvailable:(AdType)adType;
-(void)onShow:(AdType)adType;
-(void)onFailedToShow:(AppHypeException*)appHypeException;
-(void)onFailedToLoad:(AppHypeException*)appHypeException;
-(void)onHide:(AdType)adType;

@end


@interface AppHype : NSObject
{
    
}

+ (id)sharedInstance;

/**
 * Initializes AppHype SDK
 * @param apiKey
 * @param secretKey
 */

+(void)initializeWithAPIKey:(NSString*)l_apiKey andSecretKey:(NSString*)l_secretKey;

/**
 * Enables AppHype Internal logs that can be seen in xcode console
 */
+(void)enableLogs:(BOOL)isEnable;

-(void)restrictAd:(int)waitTillLaunchNumber;

-(void)preLoadAd:(AdType)adType;
-(void)closeAd;
-(void)showAd:(AdType)adType;
-(BOOL)isAvailable:(AdType)adType;
-(void)setAppHypeListener:(id<AppHypeListener>) listener;

@end
