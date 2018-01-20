//
//  HttpParameters.m
//  Http
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectHttpParameters.h"
#import "YConnectLog.h"

/**Http通信を行う際のパラメータを扱う
 *
 *NSMutableDictionaryのクラスをすべて引き継げないので
 *クラスの内部にNSMutableDictionaryの変数を定義し、
 *その変数を操作する
 **/
@implementation YConnectHttpParameters

/**
 * 初期化
 * @return id
 **/
- (id)init
{
    self = [super init];
    if (self) {
        _nsMutableDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}
/**
 * NSString形式に変換する
 * @return パラメータをクエリーに積むための文字列に変換したもの
 **/
- (NSString *)toQueryString
{
    NSString *query = @"";
    NSString *ampersand = @"";

    //全キーをソートして取得
    NSArray *keys = [[self.nsMutableDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (id key in keys) {
        query = [query stringByAppendingFormat:@"%@%@=%@", ampersand, key, [self.nsMutableDictionary objectForKey:key]];
        ampersand = @"&";
    }
    return query;
}

/**
 * キーとバリューをセットする
 * @param id value
 * @param NSString *key
 **/
- (void)setValue:(id)value forKey:(NSString *)key
{
    [self.nsMutableDictionary setValue:value forKey:key];
}
/**
 * キーからバリューを取得する
 * @param id aKey
 * @return id
 **/
- (id)objectForKey:(id)aKey
{
    return [self.nsMutableDictionary objectForKey:aKey];
}
/**
 * すべてのキーを取得する
 * @return NSArray *
 **/
- (NSArray *)allKeys
{
    return [self.nsMutableDictionary allKeys];
}
/**
 * サイズを取得する
 * @return NSUInteger
 **/
- (NSUInteger)count
{
    return [self.nsMutableDictionary count];
}
@end
