//
//  YConnectLog.h
//  YConnect
//
//  Created by yitou on 2014/12/01.
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

typedef NS_ENUM(NSInteger, YConnectLogLevel) {
    YConnectLogLevelNone = 1,
    YConnectLogLevelFatal,
    YConnectLogLevelError,
    YConnectLogLevelWarn,
    YConnectLogLevelInfo,
    YConnectLogLevelDebug,
    YConnectLogLevelAll
};

// デバッグ時以外ではNSLogをはかないようにする
#ifdef DEBUG

#define YConnectLogSetLevel(level) [YConnectLog changeLogLevel:level]
#define YConnectLogFatal(...) [YConnectLog fatal:__VA_ARGS__]
#define YConnectLogError(...) [YConnectLog error:__VA_ARGS__]
#define YConnectLogWarn(...) [YConnectLog warn:__VA_ARGS__]
#define YConnectLogInfo(...) [YConnectLog info:__VA_ARGS__]
#define YConnectLogDebug(...) [YConnectLog debug:__VA_ARGS__]

#else

#define YConnectLogSetLevel(level)
#define YConnectLogFatal(...)
#define YConnectLogError(...)
#define YConnectLogWarn(...)
#define YConnectLogInfo(...)
#define YConnectLogDebug(...)

#endif

@interface YConnectLog : NSObject
+ (void)changeLogLevel:(YConnectLogLevel)level;
+ (void)fatal:(NSString*)format, ...;
+ (void)error:(NSString*)format, ...;
+ (void)warn:(NSString*)format, ...;
+ (void)info:(NSString*)format, ...;
+ (void)debug:(NSString*)format, ...;
@end
