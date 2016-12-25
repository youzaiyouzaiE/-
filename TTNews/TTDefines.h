//
//  TTDefines.h
//  TTNews
//
//  Created by jiahui on 2016/11/17.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#ifndef TTDefines_h
#define TTDefines_h

/////登陆 login
#define INITIALIZE_URL                      @"https://passportforapp.skykiwi.com/v2/register/init.do"
#define CHECK_EMAIL_URL                     @"https://passportforapp.skykiwi.com/v2/register/isExist.do"
#define PICTURE_VERIFY_CODE_URL             @"https://passportforapp.skykiwi.com/v2/register/picVerifycode.do"////guid
#define SEND_EMAIL_URL                      @"https://passportforapp.skykiwi.com/v2/register/sendmail.do"
#define REGISTER_URL                        @"https://passportforapp.skykiwi.com/v2/register/done.do"
#define LOGIN_URL                           @"https://passportforapp.skykiwi.com/v2/login/logging.do"
#define USER_INFO_URL                       @"https://passportforapp.skykiwi.com/v2/member/self.do"
///news
#define TT_NEWS_CHANNELS                    @"http://59.110.23.172/api/channels"    ////频道列表
#define TT_FRIST_CYCLE_LIST                 @"http://59.110.23.172/api/app_photos"  ////头条循环图
#define TT_FRIST_LIFE_CITY                  @"http://139.196.16.143/city.php"       ////日期，城市天气，等信息
#define TT_FRIST_NEWS_List                  @"http://59.110.23.172/api/sort_links/with_photos"///头条列表
#define TT_OTHER_News_LIST                  @"http://59.110.23.172/api/articles/channel/1"///其它频道列表
#define TT_COMMENT_LIST                     @"http://59.110.23.172/api/comments"    ////评论

#define TT_EXPOSURES_URL                    @"http://59.110.23.172/api/exposures"   ////爆料（post）



#define Screen_Width                        [UIScreen mainScreen].bounds.size.width
#define Screen_Height                       [UIScreen mainScreen].bounds.size.height
#define FORMAT(format, ...)                 [NSString stringWithFormat:(format), ##__VA_ARGS__]

#define IOS_7LAST                           ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?1:0
#define IOS_8LAST                           ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)?1:0





#endif /* TTDefines_h */
