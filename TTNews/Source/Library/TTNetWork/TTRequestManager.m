//
//  TTRequestManager.m
//  TTNews
//
//  Created by jiahui on 2016/12/4.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTRequestManager.h"


NSString * const kMAPI_ZCNetworkManger_DebugBaseURL         = @"ZCNetworkMangerDebugServerBaseURL";
NSString * const kMAPI_ZCNetworkManger_NetworkStatusChanged = @"kZCNetworkMangerNetworkStatusChanged";

@implementation TTRequestManager

+ (instancetype)sharedManager {
    static TTRequestManager *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [TTRequestManager manager];
        if (shareInstance) {
//            [shareInstance checkNetworkStatus];
            //            //            [sharedManager.reachabilityManager startMonitoring];
            //
            //            TTHTTPRequestSerializer *reqSerializer = [TTHTTPRequestSerializer serializer];
            //            reqSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            //            reqSerializer.timeoutInterval = [shareInstance timeoutInterval];
            //            shareInstance.requestSerializer = reqSerializer;
            //
            //            TTHTTPResponseSerializer *rspSerializer = [TTHTTPResponseSerializer serializer];
            //            rspSerializer.removesKeysWithNullValues = YES; // trim 应答中的NULL
            //            shareInstance.responseSerializer = rspSerializer;
            //
            //            NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:1UL << 21
            //                                                                    diskCapacity:10 * (1UL << 20)
            //                                                                        diskPath:nil];
            //            [NSURLCache setSharedURLCache:sharedCache];
        }
    });
    return shareInstance;
}

#pragma mark - 发送网络请求 GET
- (NSURLSessionDataTask *)GETWithAction:(NSString *)url
                             parameters:(NSDictionary *)para
                                success:(successWithObjectBlock)success
                                failure:(failErrorBlock)failure {
    assert(url);
    return [self GETWithAction:url parameters:para progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)GETWithAction:(NSString *)url
                             parameters:(NSDictionary *)para
                               progress:(void (^)(NSProgress *))downloadProgress
                                success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                                failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
    return [super GET:url
           parameters:para
             progress:downloadProgress
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  success(task , responseObject);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failure(task , error);
                  
              }];
}

#pragma mark - 发送网络请求 POST
- (NSURLSessionDataTask *)POSTWithAction:(NSString *)url
                              parameters:(NSDictionary *)para
                                 success:(successWithObjectBlock)success
                                 failure:(failErrorBlock)failure
{
    return [self POSTWithAction:url parameters:para progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)POSTWithAction:(NSString *)url
                              parameters:(NSDictionary *)para
                                progress:(void (^)(NSProgress *))uploadProgress
                                 success:(successWithObjectBlock)success
                                 failure:(failErrorBlock)failure
{
    return [super POST:url
            parameters:para
              progress:uploadProgress
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   success(task , responseObject);
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failure(task , error);
               }];
}

- (NSURLSessionDataTask *)POSTWithAction:(NSString *)url
                              parameters:(id)para
               constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                progress:(void (^)(NSProgress *))uploadProgress
                                 success:(successWithObjectBlock)success
                                 failure:(failErrorBlock)failure
{
    return [super POST:url parameters:para constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task , responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task , error);
    }];
}

#pragma mark - 网络可达性
- (BOOL)isReachable {
    return self.reachabilityManager.isReachable;
}

//#pragma mark - 设置网络变化的回调
//- (void)checkNetworkStatus {
//    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"Current network status : unknown");
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//                NSLog(@"Current network status : not reachable");
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"Current network status : 2/3/4G");
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"Current network status : Wifi");
//                break;
//            default:
//                break;
//        }
//        //        [TTIFConfigHelper carrierInfo];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kMAPI_TTNetworkManager_NetworkStatusChanged object:@(status)];
//    }];
//}

//- (void)listenNetworking
//{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAlert) name:kMAPI_TTNetworkManager_NetworkStatusChanged object:nil];
//}
//
//- (void)showAlert {
//    BOOL hasAlert = NO;
//    for (UIWindow *window in [UIApplication sharedApplication].windows) {
//        NSArray *subviews = window.subviews;
//        if ([subviews count] > 0)
//            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]]) {
//                hasAlert = YES;
//            }
//    }
//    
//    BOOL isReachable = [[TTNetWorkManager manager] isReachable];
//    if (!isReachable && !hasAlert) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                         message:@"未连接到互联网，请检查网络配置"
//                                                        delegate:self
//                                               cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//}

@end
