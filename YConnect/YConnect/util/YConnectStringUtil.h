//
//  StringUtil.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YConnectStringUtil : NSObject
- (id)init;
- (NSString *)generateState;
- (NSString *)generateNonce;
@end
