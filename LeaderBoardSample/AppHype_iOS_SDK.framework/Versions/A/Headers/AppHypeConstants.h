//
//  AppHypeConstants.h
//  AppHype_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 29/07/14.
//  Copyright (c) 2014 Shephertz Technologies Pvt Ltd. All rights reserved.
//


#define CURRENT_SDK_VERSION     @"1.0" // Current SDK version



#define VERSION_INTERNAL    @"1.0" // version used in the http request

#define contentType @"application/json"

#define acceptType  @"application/json"


/***
 *  BASIC SERVICE PARAMS
 **/
#define API_KEY             @"apiKey"
//#define SECRET_KEY          @"secretKey"
#define SDK_VERSION         @"version"
#define TIME_STAMP          @"timeStamp"
#define LOG_TAG             @"AppHype"
#define VIDEO               @"video"
#define INTERSTITIAL        @"interstitial"
#define INSTALL             @"install"
#define CLICK               @"click"
#define IMPRESSION          @"impression"

#define WAIT_TILL_LAUNCH_NUM        @"waitTillLaunchNumber"
#define CURRENT_LAUNCH_NUM          @"currentLaunchNumber"
#define IS_LAUNCHED_BEFORE          @"isLaunchedBefore"

#define SDK_NAME @"os"
#define DEVICE_ID @"deviceId"
#define BUNDLE_IDENTIFIER @"appPackage" // make it to appId
#define AD_TYPE @"adUnit" //make it adCode


#define SCREEN_WIDTH    @"deviceWidth"
#define SCREEN_HEIGHT   @"deviceHeight"
#define ORIENTATION     @"orientation"
#define FREE_BYTES      @"freeBytes"
#define OS_VERSION      @"osVersion"
#define PLATFORM        @"platform"
#define DEVICE_MODEL    @"deviceModel"
#define DEVICE_TYPE     @"deviceType"
#define CARRIER         @"carrier"
#define CONNECTION_TYPE @"connectionType"
#define COUNTRY         @"country"
#define DENSITY         @"density"

#define APPHYPE_EVENTS  @"appHypeEvents"
#define CAMPAIGNID      @"campaignId"
#define CAMPAIGN_PACKAGE @"campaignPackage"
#define APPLE_ID        @"appleId"
#define URL_SCHEME      @"customUrl"

#define DELETEBUTTON @"deleteButton.png"
#define DELETEBUTTON2X @"deleteButton@2x.png"

typedef enum AdType
{
    kInterstitial,
    kVideo
}AdType;


typedef enum AdOrientaion
{
    kPortrait,
    kLandscape,
    kDefaultOrientation = kPortrait,
}AdOrientaion;

typedef enum EventCode
{
    kInstall,
    kClick,
    kImpression,
    kNone
}EventType;
