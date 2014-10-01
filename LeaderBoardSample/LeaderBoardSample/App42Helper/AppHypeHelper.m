//
//  AppHypeHelper.m
//  SpacePowerCombat
//
//  Created by Shephertz Technologies Pvt Ltd on 01/10/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "AppHypeHelper.h"
#import "LDConstants.h"

@implementation AppHypeHelper

static AppHypeHelper *appHypeInstance;

+(AppHypeHelper *)sharedAppHypeHelper
{
    if(appHypeInstance == nil)
    {
        appHypeInstance = [[self alloc] init];
    }
    return appHypeInstance;
}

-(void)initializeAppHype
{
    [AppHype initializeWithAPIKey:APPHYPE_APP_KEY andSecretKey:APPHYPE_SECRET_KEY];
    [AppHype enableLogs:YES];
    [[AppHype sharedInstance] setAppHypeListener:self];
    
    int counter = (int)[[NSUserDefaults standardUserDefaults] integerForKey:APPHYPE_COUNTER];
    if (counter)
    {
        self.adcounter = counter;
    }
    else
    {
        self.adcounter = 1;
    }
}

-(BOOL)isAdAvailable:(AdType)adType
{
    return [[AppHype sharedInstance] isAvailable:adType];
}

- (void)loadInterstitialAd 
{
    NSLog(@"%s",__FUNCTION__);
    self.adcounter = 1;
    [[NSUserDefaults standardUserDefaults] setInteger:self.adcounter forKey:APPHYPE_COUNTER];
    AdType adType = kInterstitial;
    [[AppHype sharedInstance] preLoadAd:adType];
}

- (void)showInterstitialAd 
{
    NSLog(@"%s",__FUNCTION__);
    self.adcounter = 2;
    [[NSUserDefaults standardUserDefaults] setInteger:self.adcounter forKey:APPHYPE_COUNTER];
    AdType adType = kInterstitial;
    [[AppHype sharedInstance] showAd:adType];
    
}

- (void)loadVideoAd 
{
    NSLog(@"%s",__FUNCTION__);
    self.adcounter = 2;
    [[NSUserDefaults standardUserDefaults] setInteger:self.adcounter forKey:APPHYPE_COUNTER];
    AdType adType = kVideo;
    [[AppHype sharedInstance] preLoadAd:adType];
}

- (void)showVideoAd 
{
    NSLog(@"%s",__FUNCTION__);
    self.adcounter = 1;
    [[NSUserDefaults standardUserDefaults] setInteger:self.adcounter forKey:APPHYPE_COUNTER];
    AdType adType = kVideo;
    [[AppHype sharedInstance] showAd:adType];
}

#pragma mark- AppHypeListeners

-(void)onAdAvailable:(AdType)adType
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"adType=%d",adType);
}

-(void)onFailedToLoad:(AppHypeException *)appHypeException
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",appHypeException.reason);
}

-(void)onFailedToShow:(AppHypeException *)appHypeException
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",appHypeException.reason);
}

-(void)onHide:(AdType)adType
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"adType=%d",adType);
}

-(void)onShow:(AdType)adType
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"adType=%d",adType);
}

@end
