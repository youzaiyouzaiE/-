

#import "TTNetworkManger.h"
#import "TTHTTPRequestSerializer.h"
#import "TTHTTPResponseSerializer.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "TTIFConfigHelper.h"

// Debug url 动态定义key
NSString * const kMAPI_TTNetworkManger_DebugBaseURL         = @"TTNetworkMangerDebugServerBaseURL";
NSString * const kMAPI_TTNetworkManger_NetworkStatusChanged = @"kTTNetworkMangerNetworkStatusChanged";

static TTNetworkManger *sharedManager;
static dispatch_once_t onceToken;

@implementation TTNetworkManger

// 获取单例
+ (instancetype)sharedManager
{
    dispatch_once(&onceToken, ^{
        NSString *TTBaseURL = SERVER_URL;
        
#ifdef DEBUG
        // 处理调试控制器的baseURL切换
        NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:kMAPI_TTNetworkManger_DebugBaseURL];
        if (temp && temp.length > 0) {
            TTBaseURL = temp;
        }
#endif
        
        sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:TTBaseURL]];
        if (sharedManager) {
            [sharedManager checkNetworkStatus];
            [sharedManager.reachabilityManager startMonitoring];
            
            TTHTTPRequestSerializer *reqSerializer = [TTHTTPRequestSerializer serializer];
            reqSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            reqSerializer.timeoutInterval = [sharedManager timeoutInterval];
            sharedManager.requestSerializer = reqSerializer;
            
            TTHTTPResponseSerializer *rspSerializer = [TTHTTPResponseSerializer serializer];
            rspSerializer.removesKeysWithNullValues = YES; // trim 应答中的NULL
            sharedManager.responseSerializer = rspSerializer;
            
            NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:1UL << 21
                                                                    diskCapacity:10 * (1UL << 20)
                                                                        diskPath:nil];
            [NSURLCache setSharedURLCache:sharedCache];
        }
    });
    
    return sharedManager;
}

#ifdef DEBUG
// debug 时切换baseURL
- (void)resetSharedManger
{
    sharedManager = nil;
    onceToken = 0;
}
#endif

#pragma mark - CTTelephonyNetworkInfo
- (NSTimeInterval)timeoutInterval
{
    NSTimeInterval timeInterval = 30;
    switch (self.reachabilityManager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            break;
        case AFNetworkReachabilityStatusNotReachable:
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadioAccessTechnology = networkInfo.currentRadioAccessTechnology;
            if (!currentRadioAccessTechnology) {
                NSDictionary *configDict = @{CTRadioAccessTechnologyGPRS: @(60),
                                             CTRadioAccessTechnologyEdge: @(45),
                                             CTRadioAccessTechnologyWCDMA: @(30),
                                             CTRadioAccessTechnologyHSDPA: @(20),
                                             CTRadioAccessTechnologyHSUPA: @(20),
                                             CTRadioAccessTechnologyCDMA1x: @(60),
                                             CTRadioAccessTechnologyCDMAEVDORev0: @(45),
                                             CTRadioAccessTechnologyCDMAEVDORevA: @(30),
                                             CTRadioAccessTechnologyCDMAEVDORevB: @(30),
                                             CTRadioAccessTechnologyeHRPD: @(20),
                                             CTRadioAccessTechnologyLTE: @(15)};
                timeInterval = [configDict[currentRadioAccessTechnology] doubleValue];
            }
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            break;
    }
    
    return timeInterval;
}

#pragma mark - 发送网络请求 GET
- (NSURLSessionDataTask *)GETWithAction:(NSString *)url
                             parameters:(NSDictionary *)para
                                success:(successWithObjectBlock)success
                                failure:(failErrorBlock)failure
{
    assert(url);
    return [self GETWithAction:url parameters:para progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)GETWithAction:(NSString *)url
                             parameters:(NSDictionary *)para
                               progress:(void (^)(NSProgress *))downloadProgress
                                success:(successWithObjectBlock)success
                                failure:(failErrorBlock)failure{
    
    return [super GET:url parameters:para progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccessWithRsp:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailureWithRsp:task error:error failure:failure];
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
    return [super POST:url parameters:para progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self handleSuccessWithRsp:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailureWithRsp:task error:error failure:failure];
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
        
        [self handleSuccessWithRsp:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailureWithRsp:task error:error failure:failure];
    }];
}

#pragma mark - 处理请求应答
- (NSDictionary *)handleSuccessWithRsp:(id)responseObject success:(successWithObjectBlock)success failure:(failErrorBlock)failure {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    return mDict;
}

- (NSDictionary *)handleFailureWithRsp:(NSURLSessionDataTask *)task error:(NSError *)error failure:(failErrorBlock)failure
{
    NSMutableDictionary *mDict = [@{} mutableCopy];

    
    return mDict;
}

#pragma mark - 网络可达性
- (BOOL)isReachable
{
    return self.reachabilityManager.isReachable;
}

#pragma mark - 设置网络变化的回调
- (void)checkNetworkStatus
{
    __weak typeof(self) weakSelf = self;
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.requestSerializer.timeoutInterval = [strongSelf timeoutInterval];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                 NSLog(@"Current network status : unknown");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"Current network status : not reachable");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"Current network status : 2/3/4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"Current network status : Wifi");
                break;
            default:
                break;
        }
        [TTIFConfigHelper carrierInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMAPI_TTNetworkManger_NetworkStatusChanged object:@(status)];
    }];
}


- (void)listenNetworking
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAlert) name:kMAPI_TTNetworkManger_NetworkStatusChanged object:nil];
}

- (void)showAlert
{

    BOOL hasAlert = NO;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        NSArray *subviews = window.subviews;
        if ([subviews count] > 0)
            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]]) {
                hasAlert = YES;
            }
    }

    BOOL isReachable = [[TTNetworkManger sharedManager] isReachable];
    if (!isReachable && !hasAlert) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"未连接到互联网，请检查网络配置"
                                                        delegate:self
                                               cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }


}
@end
