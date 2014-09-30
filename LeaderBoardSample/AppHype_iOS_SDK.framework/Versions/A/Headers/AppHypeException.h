//
//  AppHypeException.h
//  AppHype_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 29/07/14.
//  Copyright (c) 2014 Shephertz Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppHypeConstants.h"

@interface AppHypeException : NSException


@property(nonatomic) int httpErrorCode;
@property(nonatomic) int appErrorCode;
@property(nonatomic) AdType adType;

+(AppHypeException*)exceptionWithReason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo httpErrorCode:(int)httpCode appErrorCode:(int)appCode;

+(AppHypeException*)exceptionWithReason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo adType:(AdType)adType httpErrorCode:(int)httpCode appErrorCode:(int)appCode;

@end
