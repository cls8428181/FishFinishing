//
//  FishFinishingTests.m
//  FishFinishingTests
//
//  Created by apple on 2019/4/10.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KNBLoginRegisterApi.h"
#import "KNBLoginSendCodeApi.h"
#import "KNBLoginBindingApi.h"
#import "KNBLoginThirdPartyApi.h"
#import "KNBLoginModifyApi.h"
#import "KNBLoginLoginApi.h"
#import "KNBOrderAreaApi.h"

@interface FishFinishingTests : XCTestCase

@end

@implementation FishFinishingTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
//测试注册接口
- (void)testRegisterApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@" KNBLoginRegisterApi"];
    KNBLoginRegisterApi *api = [[KNBLoginRegisterApi alloc] initWithMobile:@"18600393004" code:@"1234" password:@"12345678" repassword:@"12345678"];

    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        XCTAssertNotNil(request.responseJSONObject, @"request.responseJSONObject nil");
        XCTAssertNotNil(request, @"request nil");
        XCTAssertEqual(request.responseStatusCode, 200, @"status != 1");
//        NSArray *dataArray = [KNBBusinessSchoolActiveContentModel changeResponseJSONObject:request.responseJSONObject[@"data"]];
        [expectation fulfill];
        
        NSLog(@"%@", request.responseJSONObject);
        
    } failure:^(__kindof YTKBaseRequest *request) {
        XCTAssertNotNil(request, @"request nil");
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *_Nullable error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}
//发送验证码
- (void)testSendCodeApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@" KNBLoginSendCodeApi"];
    KNBLoginSendCodeApi *api = [[KNBLoginSendCodeApi alloc] initWithMobile:@"18600393004" type:KNBLoginSendCodeTypeRegister];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        XCTAssertNotNil(request.responseJSONObject, @"request.responseJSONObject nil");
        XCTAssertNotNil(request, @"request nil");
        XCTAssertEqual(request.responseStatusCode, 200, @"status != 1");
        //        NSArray *dataArray = [KNBBusinessSchoolActiveContentModel changeResponseJSONObject:request.responseJSONObject[@"data"]];
        [expectation fulfill];
        
        NSLog(@"%@", request.responseJSONObject);
        
    } failure:^(__kindof YTKBaseRequest *request) {
        XCTAssertNotNil(request, @"request nil");
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *_Nullable error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

//第三方登录
- (void)testThirdPartyApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@" KNBLoginThirdPartyApi"];
    KNBLoginThirdPartyApi *api = [[KNBLoginThirdPartyApi alloc] initWithOpenid:@"11111" loginType:KNBLoginThirdPartyTypeWechat portrait:@"11111" nickName:@"111111" sex:@"11111"];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        XCTAssertNotNil(request.responseJSONObject, @"request.responseJSONObject nil");
        XCTAssertNotNil(request, @"request nil");
        XCTAssertEqual(request.responseStatusCode, 200, @"code != 1");
        //        NSArray *dataArray = [KNBBusinessSchoolActiveContentModel changeResponseJSONObject:request.responseJSONObject[@"data"]];
        [expectation fulfill];
        
        NSLog(@"%@", request.responseJSONObject);
        
    } failure:^(__kindof YTKBaseRequest *request) {
        XCTAssertNotNil(request, @"request nil");
    }];

    [self waitForExpectationsWithTimeout:20 handler:^(NSError *_Nullable error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

//获取所有省市区
- (void)testGetAreaApi {
    XCTestExpectation *expectation = [self expectationWithDescription:@" KNBOrderAreaApi"];
     KNBOrderAreaApi *api = [[KNBOrderAreaApi alloc] init];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        XCTAssertNotNil(request.responseJSONObject, @"request.responseJSONObject nil");
        XCTAssertNotNil(request, @"request nil");
        XCTAssertEqual(request.responseStatusCode, 200, @"code != 1");
        NSLog(@"%@",request.responseJSONObject[@"list"]);
        NSArray *array = request.responseJSONObject[@"list"];
        NSString *str= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *plistPath = [str stringByAppendingString:@"/hmkj_c_addressList.plist" ];
        //转换成功后,文件位置要输出出来便于查找
        NSLog(@"plistPath = %@", plistPath);
        [array writeToFile:plistPath atomically:YES];
        //        NSArray *dataArray = [KNBBusinessSchoolActiveContentModel changeResponseJSONObject:request.responseJSONObject[@"data"]];
        [expectation fulfill];
        
        NSLog(@"%@", request.responseJSONObject);
        
    } failure:^(__kindof YTKBaseRequest *request) {
        XCTAssertNotNil(request, @"request nil");
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *_Nullable error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
