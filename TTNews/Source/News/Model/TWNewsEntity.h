//
//  TWNewsEntity.h
//  TTNews
//
//  Created by hasty on 16/11/13.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//
/*
 {
 "url_3w": "http://news.163.com/16/1112/09/C5LLCPJ90001875N.html",
 "postid": "C5LLCPJ90001875N",
 "votecount": 18039,
 "replyCount": 20870,
 "ltitle": "外交部官网公布12位领导婚育状况 王毅已婚有一女",
 "digest": "日前，外交部官网领导栏进行了更新，十八届中央纪委委员谢杭生，正式出任中央纪委驻外交部纪检组长。封面新闻记者注意到，在外交部官网上，谢杭生的简历底部，特别注明了一",
 "url": "http://3g.163.com/news/16/1112/09/C5LLCPJ90001875N.html",
 "docid": "C5LLCPJ90001875N",
 "title": "外交部官网公布12位领导婚育状况 王毅已婚有一女",
 "source": "封面新闻",
 "priority": 109,
 "lmodify": "2016-11-12 14:06:24",
 "imgsrc": "http://cms-bucket.nosdn.127.net/b74a4321681d44ca950d7703cdb9b07020161112090519.png",
 "subtitle": "",
 "boardid": "news_guonei8_bbs",
 "ptime": "2016-11-12 09:04:12"
 },
 */

/*
 {
 "id": 2,      //文章id
 "state": 0,   //是否已经发布
 "linked_id": 0, //是否文字链接
 "type": 0,      //类型：
 "title": "我的哈哈", //标题
 "author_id": 1,
 "auditor_id": 0,
 "channel_id": 6,
 "title_bold": 0,
 "title_color": "#ccc",
 "subtitle": "1234", //子标题
 "cover_pic": "image/9d997b1ae75b32425e192735f0c5e6ff.png",
 "top_grade": 0,
 "description": "", //描述
 "source": "",      //来源
 "is_headline": 0,  //是否头条
 "is_soft": 0,
 "is_political": 0,
 "is_international": 0,
 "is_important": 0,
 "published_at": "2016-10-25 19:28:05",
 "created_at": "2016-10-25 18:28:05",
 "updated_at": "2016-10-26 14:47:04",
 "deleted_at": null
 }
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TWNewsEntity : NSObject

@property (nonatomic,copy) NSString *tname;
/**
 *  新闻发布时间
 */
@property (nonatomic,copy) NSString *published_at;  //ptime,创建时间
/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;  //title
/**
 *  多图数组
 */
@property (nonatomic,strong)NSArray *imgextra;
@property (nonatomic,copy) NSString *photosetID;
@property (nonatomic,copy)NSNumber *hasHead;
@property (nonatomic,copy)NSNumber *hasImg;
@property (nonatomic,copy) NSString *lmodify;
@property (nonatomic,copy) NSString *template;
@property (nonatomic,copy) NSString *skipType;
/**
 *  跟帖人数
 */
@property (nonatomic,copy)NSNumber *replyCount;
@property (nonatomic,copy)NSNumber *votecount;
@property (nonatomic,copy)NSNumber *voteCount;

@property (nonatomic,copy) NSString *alias;
/**
 *  新闻ID
 */
@property (nonatomic,copy) NSString *id;  //doc_ic，文章id
@property (nonatomic,assign)BOOL hasCover;
@property (nonatomic,copy)NSNumber *hasAD;
@property (nonatomic,copy)NSNumber *priority;
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,strong)NSArray *videoID;
/**
 *  图片连接
 */
@property (nonatomic,copy) NSString *cover_pic; //imgsrc,封面图片,
@property (nonatomic,assign)BOOL hasIcon;
@property (nonatomic,copy) NSString *ename;
@property (nonatomic,copy) NSString *skipID;
@property (nonatomic,copy)NSNumber *order;
/**
 *  描述
 */
@property (nonatomic,copy) NSString *digest;

@property (nonatomic,strong)NSArray *editor;


@property (nonatomic,copy) NSString *url_3w;
@property (nonatomic,copy) NSString *specialID;
@property (nonatomic,copy) NSString *timeConsuming;
@property (nonatomic,copy) NSString *subtitle; //subtitle
@property (nonatomic,copy) NSString *adTitle;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *source;


@property (nonatomic,copy) NSString *TAGS;
@property (nonatomic,copy) NSString *TAG;
/**
 *  大图样式
 */
@property (nonatomic,copy)NSNumber *imgType;
@property (nonatomic,strong)NSArray *specialextra;


@property (nonatomic,copy) NSString *boardid;
@property (nonatomic,copy) NSString *commentid;
@property (nonatomic,copy)NSNumber *speciallogo;
@property (nonatomic,copy) NSString *specialtip;
@property (nonatomic,copy) NSString *specialadlogo;

@property (nonatomic,copy) NSString *pixel;
@property (nonatomic,strong)NSArray *applist;

@property (nonatomic,copy) NSString *wap_portal;
@property (nonatomic,copy) NSString *live_info;
@property (nonatomic,copy) NSString *ads;
@property (nonatomic,copy) NSString *videosource;

@property (nonatomic, assign) CGFloat cellHeight;
+ (instancetype)newsModelWithDict:(NSDictionary *)dict;


@end
