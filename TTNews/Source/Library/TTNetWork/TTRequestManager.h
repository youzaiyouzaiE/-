//
//  TTRequestManager.h
//  TTNews
//
//  Created by jiahui on 2016/12/4.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^successWithObjectBlock)(NSURLSessionDataTask *task, id responseObject);  // 网络请求成功的block
typedef void (^failErrorBlock)(NSURLSessionDataTask *task, NSError *error); // 网络请求失败的block

extern NSString * const kMAPI_TTNetworkManager_DebugBaseURL; // debug base url key
extern NSString * const kMAPI_TTNetworkManager_NetworkStatusChanged; // 发送设备网络状态通知, NSNumber类型：0 未知网络，1 不可达，2 WWAN，3 WIFI


@interface TTRequestManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (BOOL)isReachable; // 检测网络是否可达


// 发送网络请求 - GET
- (NSURLSessionDataTask *)GETWithAction:(NSString *)url
                             parameters:(NSDictionary *)para
                                success:(successWithObjectBlock)success
                                failure:(failErrorBlock)failure;

- (NSURLSessionDataTask *)GETWithAction:(NSString *)url
                             parameters:(NSDictionary *)para
                               progress:(void (^)(NSProgress *))downloadProgress
                                success:(successWithObjectBlock)success
                                failure:(failErrorBlock)failure;

// 发送网络请求 - POST
- (NSURLSessionDataTask *)POSTWithAction:(NSString *)url
                              parameters:(NSDictionary *)para
                                 success:(successWithObjectBlock)success
                                 failure:(failErrorBlock)failure;

- (NSURLSessionDataTask *)POSTWithAction:(NSString *)url
                              parameters:(NSDictionary *)para
                                progress:(void (^)(NSProgress *))uploadProgress
                                 success:(successWithObjectBlock)success
                                 failure:(failErrorBlock)failure;

- (NSURLSessionDataTask *)POSTWithAction:(NSString *)url
                              parameters:(id)para
               constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                progress:(void (^)(NSProgress *))uploadProgress
                                 success:(successWithObjectBlock)success
                                 failure:(failErrorBlock)failure;

/*
 * 添加对网络的监控,如果网络不通弹出提示框
 *
 * */
- (void)listenNetworking;

@end
