//
//  YConnectLog.m
//  YConnect
//
//  Created by ynakayam on 2015/09/08.
//  Copyright (c) 2015年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YConnectLog.h"

@implementation YConnectLog

static YConnectLogLevel logLevel = 0;

+ (void)initLogLevelWithPlist
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSNumber *plistYConnectLogLevel = [bundle objectForInfoDictionaryKey:@"YConnectLogLevel"];
    NSInteger level = [plistYConnectLogLevel intValue];
    if (level > 7 || level < 1) {
        logLevel = YConnectLogLevelDebug;
    } else {
        logLevel = level;
    }
}

+ (void)changeLogLevel:(YConnectLogLevel)level
{
    logLevel = level;
}

+ (void)fatal:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self logging:YConnectLogLevelFatal label:@"FATAL" format:format argList:args];
    va_end(args);
}

+ (void)error:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self logging:YConnectLogLevelError label:@"ERROR" format:format argList:args];
    va_end(args);
}

+ (void)warn:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self logging:YConnectLogLevelWarn label:@"WARN" format:format argList:args];
    va_end(args);
}

+ (void)info:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self logging:YConnectLogLevelInfo label:@"INFO" format:format argList:args];
    va_end(args);
}

+ (void)debug:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self logging:YConnectLogLevelDebug label:@"DEBUG" format:format argList:args];
    va_end(args);
}

+ (void)logging:(YConnectLogLevel)level label:(NSString *)label format:(NSString *)format argList:(va_list)argList
{
    if (logLevel == 0) {
        [YConnectLog initLogLevelWithPlist];
    }
    if (logLevel < level) {
        return;
    }
    NSString *logMessage = [NSString stringWithFormat:@"[YConnect][%@] %@", label, format];
    NSLogv(logMessage, argList);
}

@end