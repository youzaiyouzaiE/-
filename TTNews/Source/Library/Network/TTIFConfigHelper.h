

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCarrier.h>

@interface TTIFConfigHelper : NSObject

/*!
 *  @brief 设备当前的局域网IP
 *
 *  @return 当前的局域网IP, nil表示获取失败
 */
+ (NSString *)internalNetworkIP;

/*!
 *  @brief 设备当前的外网IP，同步获取，会阻塞当前的线程
 *
 *  @return 获取的IP地址，返回nil获取失败
 */
+ (NSString *)networkIP;

/*!
 *  @brief 设备当前的外网IP
 *
 *  @param completion 异步获取ip后回调到主线程处理，ip为nil时表示获取失败
 */
+ (void)networkIPWithCompletion:(void(^)(NSString *ip))completion;

/*!
 *  @brief 获取运营商信息
 *
 *  @return 运营商信息
 */
+ (CTCarrier *)carrierInfo;

@end
