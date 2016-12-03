//
//  TWNewsEntity.m
//  TTNews
//
//  Created by hasty on 16/11/13.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TWNewsEntity.h"
#import <MJExtension.h>
#import "SinglePictureNewsTableViewCell.h"
#import "MultiPictureTableViewCell.h"

@implementation TWNewsEntity

+ (instancetype)newsModelWithDict:(NSDictionary *)dict
{
    TWNewsEntity *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    [model setValuesForKeysWithDictionary:dict];
    //    if (model.hasHead && model.photosetID) {
    //        model.cellName =  @"TopImageCell";
    //    }else if (model.hasHead){
    //        model.cellName =  @"TopTxtCell";
    //    }else if (model.imgType){
    //        model.cellName =  @"BigImageCell";
    
    
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat horizontalMargin = 10;
    CGFloat verticalMargin = 15;
    CGFloat controlMargin = 5;
    CGFloat titleLabelHeight = 19.5;
    CGFloat descLabelHeight = 31;
    CGFloat commentLabelHeight = 13.5;
    
    if (model.imgextra.count == 2) {
        model.cellHeight = verticalMargin + titleLabelHeight + horizontalMargin + ((kScreenWidth - 4 *horizontalMargin)/3)*3/4 + controlMargin + commentLabelHeight + controlMargin;
    } else {
        model.cellHeight = verticalMargin + titleLabelHeight + controlMargin + descLabelHeight + controlMargin + commentLabelHeight + controlMargin;
    }
    
    
    return model;
}

-(void)setCover_pic:(NSString *)cover_pic {
    //NSString *pic_prefix=@"http://59.110.23.172/upload/";
    /*self.cover_pic = [NSString stringWithFormat:@"http://59.110.23.172/upload/%@",
                    cover_pic];
    */
     _cover_pic=[NSString stringWithFormat:@"http://yun.app/upload/image/38dc7e5fa4a412cb7dc30eb94eb349da.jpeg"];
}

-(void)setImgextra:(NSArray *)imgextra {
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat horizontalMargin = 10;
    CGFloat verticalMargin = 15;
    CGFloat controlMargin = 5;
    CGFloat titleLabelHeight = 19.5;
    CGFloat descLabelHeight = 31;
    CGFloat commentLabelHeight = 13.5;
    
    if (self.imgextra.count == 2) {
        self.cellHeight = verticalMargin + titleLabelHeight + horizontalMargin + ((kScreenWidth - 4 *horizontalMargin)/3)*3/4 + controlMargin + commentLabelHeight + controlMargin;
    } else {
        self.cellHeight = verticalMargin + titleLabelHeight + controlMargin + descLabelHeight + controlMargin + commentLabelHeight + controlMargin;
    }
}


@end
