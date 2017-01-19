//
//  TTURLFile.h
//  TTNews
//
//  Created by jiahui on 2017/1/19.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#ifndef TTURLFile_h
#define TTURLFile_h

/////登陆 login
#define INITIALIZE_URL                      @"https://passportforapp.skykiwi.com/v2/register/init.do"
#define CHECK_EMAIL_URL                     @"https://passportforapp.skykiwi.com/v2/register/isExist.do"
#define PICTURE_VERIFY_CODE_URL             @"https://passportforapp.skykiwi.com/v2/register/picVerifycode.do"////guid
#define SEND_EMAIL_URL                      @"https://passportforapp.skykiwi.com/v2/register/sendmail.do"
#define REGISTER_URL                        @"https://passportforapp.skykiwi.com/v2/register/done.do"
#define LOGIN_URL                           @"https://passportforapp.skykiwi.com/v2/login/logging.do"
#define USER_INFO_URL                       @"https://passportforapp.skykiwi.com/v2/member/self.do"

///news
#define TT_NEWS_CHANNELS                    @"http://cmstest.skykiwichina.com/api/channels"    ////频道列表
#define TT_APP_AD_IMAGE                     @"http://cmstest.skykiwichina.com/api/app_photos"  ////头条启动广告图
#define TT_FRIST_CYCLE_LIST                 @"http://cmstest.skykiwichina.com/api/sort_photos"  ////头条循环图
#define TT_FRIST_LIFE_CITY                  @"http://139.196.16.143/city.php"                   ////日期，城市天气，等信息
#define TT_FRIST_NEWS_List                  @"http://cmstest.skykiwichina.com/api/sort_links/with_photos"///头条列表
#define TT_OTHER_News_LIST(channelID)       [NSString stringWithFormat:@"http://cmstest.skykiwichina.com/api/articles/channel/%@",channelID]///其它频道列表
#define TT_COMMENT_URL                      @"http://cmstest.skykiwichina.com/api/comments"    ////评论 "http://59.110.23.172/api/comments"
#define TT_EXPOSURES_URL                    @"http://cmstest.skykiwichina.com/api/exposures"   ////爆料（post）



#endif /* TTURLFile_h */
