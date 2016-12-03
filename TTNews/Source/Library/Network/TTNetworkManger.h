

#import <AFNetworking/AFNetworking.h>


#ifdef DEBUG
#define SERVER_URL             @""
#else
#define SERVER_URL             @""
#endif

typedef void (^successWithObjectBlock)(NSDictionary *result);  // 网络请求成功的block
typedef void (^failErrorBlock)(NSDictionary *error); // 网络请求失败的block

extern NSString * const kMAPI_TTNetworkManger_DebugBaseURL; // debug base url key
extern NSString * const kMAPI_TTNetworkManger_NetworkStatusChanged; // 发送设备网络状态通知, NSNumber类型：0 未知网络，1 不可达，2 WWAN，3 WIFI



@interface TTNetworkManger : AFHTTPSessionManager

// 单例
+ (instancetype)sharedManager;

- (BOOL)isReachable; // 检测网络是否可达
#ifdef DEBUG
- (void)resetSharedManger;
#endif

// 发送网络请求 - GET
- (NSURLSessionDataTask *)GETWithAction:(NSString *)url
                             parameters:(NSDictionary *)para
                                success:(successWithObjectBlock)success
                                failure:(failErrorBlock)failure;

/*!
 *  @brief GET HTTP请求
 *
 *  @param url              访问的资源路径
 *  @param para             访问的参数
 *  @param downloadProgress 下载进度，想要做UI上的操作，请派发到主线程执行
 *  @param success          HTTP请求成功的回调
 *  @param failure          HTTP请求失败的回调
 *
 *  @return 返回的task, 可以做相关的task操作
 */
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

/*!
 *  @brief POST HTTP请求
 *
 *  @param url            访问的资源路径
 *  @param para           访问的参数
 *  @param block          处理上传数据的blcok
 *  @param uploadProgress 上传进度，想要做UI上的操作，请派发到主线程执行
 *  @param success        HTTP请求成功的回调
 *  @param failure        HTTP请求失败的回调
 *
 *  @return 返回的task, 可以做相关的task操作
 */
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
