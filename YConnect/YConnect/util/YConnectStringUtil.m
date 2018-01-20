//
//  StringUtil.m
//  YConnectSDK
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectLog.h"
#import "YConnectStringUtil.h"
#import <CommonCrypto/CommonDigest.h>  // SHA256計算

//プライベート
@interface YConnectStringUtil ()
@property (nonatomic, retain) NSString *uuid;
+ (NSString *)sha256Encode:(NSString *)string;
@end

/**
 * UUIDを生成し、前半部をState、後半部をNonceに利用。
 * それぞれの値をSHA256に変換して返す。
 */
@implementation YConnectStringUtil
/**
 * 初期化
 * @return id
 **/
- (id)init
{
    self = [super init];
    if (self) {
        // UUIDを生成
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        _uuid = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuidRef);
        YConnectLogDebug(@"%@: UUID=%@", NSStringFromClass([self class]), self.uuid);
        CFRelease(uuidRef);
    }
    return self;
}

/**
 * Stateを生成(コールバックの検証)
 * @return NSString * UUIDの先頭から半分までをSHA256変換した文字列
 **/
- (NSString *)generateState
{
    NSString *prefixUUID = [self.uuid substringToIndex:[self.uuid length] / 2];  // 先頭から半分までのUUID
    YConnectLogDebug(@"%@: state=%@", NSStringFromClass([self class]), prefixUUID);
    return [YConnectStringUtil sha256Encode:prefixUUID];
}

/**
 * Nonceを生成(リプレイアタック防止)
 * @return NSString * UUIDの半分から最後尾までをSHA256変換した文字列
 **/
- (NSString *)generateNonce
{
    NSString *suffixUUID = [self.uuid substringFromIndex:[self.uuid length] / 2];  // 半分から最後尾までのUUID
    YConnectLogDebug(@"%@: nonce=%@", NSStringFromClass([self class]), suffixUUID);
    return [YConnectStringUtil sha256Encode:suffixUUID];
}

/**
 * 文字列をSHA256に変換する
 * @param NSString *string
 * @return NSString * 変換後の文字列
 **/
+ (NSString *)sha256Encode:(NSString *)string
{
    const char *stringChar = [string UTF8String];                      // C言語の文字列へ変換
    unsigned char sha256Result[CC_SHA256_DIGEST_LENGTH];               // SHA256計算結果の保持領域
    CC_SHA256(stringChar, (CC_LONG)strlen(stringChar), sha256Result);  // SHA256計算実行
    //Objective-cの文字列にフォーマット
    NSMutableString *stringSHA256 = [[NSMutableString alloc] init];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [stringSHA256 appendFormat:@"%02X", sha256Result[i]];
    }

    return stringSHA256;
}
@end
