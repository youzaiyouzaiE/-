

#import "TTIFConfigHelper.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@implementation TTIFConfigHelper

+ (NSString *)internalNetworkIP

{ NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if (0 == strcmp(temp_addr->ifa_name, "en0")) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    free(interfaces);
    free(temp_addr);
    
    return address ? address : nil;
}

// 目前移动设备能获取外网IP只能通过访问才能对其获得
+ (NSString *)networkIP
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://ifconfig.me/ip"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    
    return ip ? ip : nil;
}

+ (void)networkIPWithCompletion:(void(^)(NSString *ip))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://ifconfig.me/ip"];
        NSError *error = nil;
        NSString *ipString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error ? ipString : nil);
            });
        }
    });
}


+ (CTCarrier *)carrierInfo
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    
    return carrier;
}

@end
