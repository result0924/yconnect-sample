//
//  StringUtil.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>  // SHA256計算

@interface YConnectStringUtil : NSObject
- (id)init;
- (NSString *)generateState;
- (NSString *)generateNonce;
@end
