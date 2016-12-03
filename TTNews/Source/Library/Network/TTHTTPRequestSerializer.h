

#import "AFURLRequestSerialization.h"


@interface TTHTTPRequestSerializer : AFHTTPRequestSerializer


+ (void)setUID:(NSString *)uid;
+ (NSString *)uid;
+ (NSString *)clientID;
// 移除UID
+(void)removeUID;
@end
