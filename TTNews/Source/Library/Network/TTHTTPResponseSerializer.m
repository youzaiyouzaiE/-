

#import "TTHTTPResponseSerializer.h"

@implementation TTHTTPResponseSerializer

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"text/plain", @"text/xml", @"application/rss+xml", @"application/json", nil];
    }
    
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSString *rspString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([rspString isEmptyObj]) {
        return nil;
    }
//    NSString *responseStr = [NSData AES256DecryptWithCiphertextExt:rspString];
    NSData *rspData = [rspString dataUsingEncoding:NSUTF8StringEncoding];
    return [super responseObjectForResponse:response data:rspData error:error];
}

@end
