

#import "TTHTTPRequestSerializer.h"


static NSString * const kPLATFORM = @"200";   //iOS平台
static NSString * const kTTHTTPRequestSerializer_UserDefaultUUID = @"kStartUUID";

@implementation TTHTTPRequestSerializer

- (NSDictionary *)getParaWithDic:(NSDictionary *)parameters
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //cid
    static NSString *cid = nil;
    if (!cid) {
        cid = [[self class] clientID];
    }
    dic[@"cid"] = cid;
    
    // uid
    NSString *uid = [[self class] uid];
    if (![uid isEmptyObj]) {
        dic[@"uid"] = uid;
    }
   
    if (!parameters || 0 == parameters.count) { // mapi不能传空参数
        parameters = @{@"":@""};
    }
    //post图片时，q在外部设置
    NSString *value = [NSString stringWithFormat:@"%@",[parameters objectForKey:@"q"]];
    if (![value isEmptyObj]) {

        [dic addEntriesFromDictionary:parameters];
//        dic[@"q"] = [NSData AES256EncryptWithPlainTextExt:value];
        
    }else{
        
        // 获取参数经过加密和编码后的q
        NSData *qData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        NSString *q = [[NSString alloc] initWithData:qData encoding:NSUTF8StringEncoding];
//        dic[@"q"] = [NSData AES256EncryptWithPlainTextExt:q];
    }
    
	return dic;
}


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error
{
    return [super requestWithMethod:method
                          URLString:URLString
                         parameters:[self getParaWithDic:parameters]
                              error:error];
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                                                  error:(NSError *__autoreleasing *)error
{
	return [super multipartFormRequestWithMethod:method
                                       URLString:URLString
                                      parameters:[self getParaWithDic:parameters]
                       constructingBodyWithBlock:block
                                           error:error];
}


+ (void)setUID:(NSString *)uid
{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:kTTHTTPRequestSerializer_UserDefaultUUID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)removeUID
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTTHTTPRequestSerializer_UserDefaultUUID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)uid
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kTTHTTPRequestSerializer_UserDefaultUUID];
    if ([uid isKindOfClass:[NSString class]]) {
        return uid;
    }
    
    return nil;
}

+ (NSString *)clientID
{
    NSString *versionCode = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    versionCode = [versionCode stringByReplacingOccurrencesOfString:@"." withString:@""];
    return [NSString stringWithFormat:@"%@%@", kPLATFORM, versionCode];
}

@end
