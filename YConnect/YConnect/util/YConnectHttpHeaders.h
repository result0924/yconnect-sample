//
//  HttpHeaders.h
//  Http
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YConnectHttpHeaders : NSObject  // : NSMutableDictionary
- (id)init;
- (NSString *)toHeaderString;

//データ保持用Dictionary 追加
@property (nonatomic, retain) NSMutableDictionary *nsMutableDictionary;

//追加 NSMutableDictionary 操作用
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)objectForKey:(id)aKey;
- (NSArray *)allKeys;
- (NSUInteger)count;
@end
