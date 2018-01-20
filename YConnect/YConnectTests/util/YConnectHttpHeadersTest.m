//
//  HttpHeadersTest.m
//  Http
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectHttpHeadersTest.h"

@implementation YConnectHttpHeadersTest
- (void)setUp
{
    [super setUp];

    headers = [[YConnectHttpHeaders alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}
/**
 * (id)init
 * @test 例外を投げずに初期化できるか(正常系)
 **/
- (void)testInit
{
    XCTAssertNoThrow(headers = [[YConnectHttpHeaders alloc] init], @"");
}

/**
 * (NSString *)toHeaderString
 * @test Httpヘッダ用に文字列化して取得できているか(正常系)
 **/
- (void)testToHeaderString
{
    NSString *expected = @"name: value";
    [headers setValue:@"value" forKey:@"name"];
    XCTAssertEqualObjects([headers toHeaderString], expected, @"not match toHeaderString");
}

/**
 * (NSString *)toHeaderString
 * @test Httpヘッダ用に複数のパラメータを文字列化して取得できているか(正常系)
 **/
- (void)testToHeaderStringMulti
{
    NSString *expected = @"name1: value1\nname2: value2\nname3: value3";
    [headers setValue:@"value1" forKey:@"name1"];
    [headers setValue:@"value2" forKey:@"name2"];
    [headers setValue:@"value3" forKey:@"name3"];
    XCTAssertEqualObjects([headers toHeaderString], expected, @"not match toHeaderString (multi)");
}

/**
 * (void)setValue:(id)value forKey:(NSString *)key
 * @test 例外を投げずにキーと値をセットできるか(正常系)
 **/
- (void)testSetValue
{
    XCTAssertNoThrow([headers setValue:@"value" forKey:@"name"], @"Throw exception");
}

/**
 * (id)objectForKey:(id)aKey
 * @test キーを指定して値を取得でき、一致するか(正常系)
 **/
- (void)testObjectForKey
{
    [headers setValue:@"value" forKey:@"name"];
    XCTAssertEqualObjects([headers objectForKey:@"name"], @"value", @"not match value");
}

/**
 * (NSArray *)allKeys
 * @test 複数のキーを取得し、一致するか(正常系)
 **/
- (void)testAllKeys
{
    [headers setValue:@"value" forKey:@"name1"];
    [headers setValue:@"value" forKey:@"name2"];
    [headers setValue:@"value" forKey:@"name3"];
    XCTAssertTrue([[headers allKeys] containsObject:@"name1"], @"not include name1");
    XCTAssertTrue([[headers allKeys] containsObject:@"name2"], @"not include name2");
    XCTAssertTrue([[headers allKeys] containsObject:@"name3"], @"not include name3");
    XCTAssertTrue([[headers allKeys] count] == 3, @"not match array_size");
}

/**
 * (NSUInteger)count
 * @test 格納されているサイズを取得し、一致するか(正常系)
 **/
- (void)testCount
{
    [headers setValue:@"value" forKey:@"name1"];
    [headers setValue:@"value" forKey:@"name2"];
    [headers setValue:@"value" forKey:@"name3"];
    XCTAssertTrue([headers count] == 3, @"not match headers_count");
}
@end
