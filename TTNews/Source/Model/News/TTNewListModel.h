//
//  TTNewListModel.h
//  TTNews
//
//  Created by jiahui on 2016/12/4.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTBaseModel.h"
#import "TTNewsArticleInfo.h"

@interface TTNewListModel : TTBaseModel ////新闻列表

@property (nonatomic, strong) NSNumber *id_list;//文章编号
@property (nonatomic, strong) NSNumber *state;             //状态 2：已发布
@property (nonatomic, strong) NSNumber *link_id;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *title;//文章标题
@property (nonatomic, strong) NSNumber *author_id;//作者编号
@property (nonatomic, strong) NSNumber *auditor_id;     //编辑id
@property (nonatomic, strong) NSNumber *channel_id;   //文章所属频道id
@property (nonatomic, strong) NSNumber *title_bold;//标题加粗显示
@property (nonatomic, copy) NSString *title_color;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *cover_pic; //封面图片
@property (nonatomic, strong) NSNumber *top_grade;
@property (nonatomic, copy) NSString *desc;//文章内容介绍
@property (nonatomic, copy) NSString *source;//文章来源
@property (nonatomic, copy) NSString *original_url;//文章来源 url
@property (nonatomic, strong) NSNumber *is_soft;//是否软文
@property (nonatomic, strong) NSNumber *is_political;//是否政治文章
@property (nonatomic, strong) NSNumber *is_international;//是否网络文章
@property (nonatomic, strong) NSNumber *is_important;//是否重要
@property (nonatomic, copy) NSString *published_at;//发布时间
@property (nonatomic, copy) NSString *created_at;//创建时间
@property (nonatomic, copy) NSString *updated_at;//更新时间
@property (nonatomic, copy) NSString *deleted_at;//删除时间
@property (nonatomic, copy) NSString *url;//文章详情链接
@property (nonatomic, strong) NSNumber *comment_num;///评论数
@property (nonatomic, strong) TTNewsArticleInfo *articleInfo;


@end
