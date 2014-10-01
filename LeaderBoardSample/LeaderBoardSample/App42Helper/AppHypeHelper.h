//
//  AppHypeHelper.h
//  SpacePowerCombat
//
//  Created by Shephertz Technologies Pvt Ltd on 01/10/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppHype_iOS_SDK/AppHype_iOS_SDK.h>

@interface AppHypeHelper : NSObject<AppHypeListener>

@property(nonatomic) int adcounter;

+(AppHypeHelper *)sharedAppHypeHelper;

- (void)initializeAppHype;
-(BOOL)isAdAvailable:(AdType)adType;
- (void)loadInterstitialAd ;
- (void)showInterstitialAd ;
- (void)loadVideoAd ;
- (void)showVideoAd ;
@end
