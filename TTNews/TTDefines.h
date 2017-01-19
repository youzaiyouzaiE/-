//
//  TTDefines.h
//  TTNews
//
//  Created by jiahui on 2016/11/17.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#ifndef TTDefines_h
#define TTDefines_h



#define Screen_Width                                [UIScreen mainScreen].bounds.size.width
#define Screen_Height                               [UIScreen mainScreen].bounds.size.height
#define FORMAT(format, ...)                         [NSString stringWithFormat:(format), ##__VA_ARGS__]

#define IOS_7LAST                                   ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?1:0
#define IOS_8LAST                                   ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)?1:0


#define NORMAL_COLOR                                [UIColor colorWithHexString:@"fa5054"]
#define COLOR_HexStr(hexStr)                        [UIColor colorWithHexString:@hexStr]

///Font
#define FONT_Regular_PF(fontSize)                   ([UIFont fontWithName:@"PingFangSC-Regular" size:(fontSize)])?[UIFont fontWithName:@"PingFangSC-Regular" size:(fontSize)]:[UIFont systemFontOfSize:(fontSize)]

#define FONT_Medium_PF(fontSize)                    ([UIFont fontWithName:@"PingFangSC-Medium" size:(fontSize)])?[UIFont fontWithName:@"PingFangSC-Medium" size:(fontSize)]:[UIFont systemFontOfSize:(fontSize)]

#define FONT_Light_PF(fontSize)                    ([UIFont fontWithName:@"PingFangSC-Light" size:(fontSize)])?[UIFont fontWithName:@"PingFangSC-Light" size:(fontSize)]:[UIFont systemFontOfSize:(fontSize)]

#define Font_NAME_SIZE(fontName,fontSize)           [UIFont fontWithName:(fontName) size:(fontSize)]



#define FORMAT(format, ...)                         [NSString stringWithFormat:(format), ##__VA_ARGS__]



#endif /* TTDefines_h */
