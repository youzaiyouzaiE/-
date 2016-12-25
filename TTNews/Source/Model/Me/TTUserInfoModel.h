//
//  TTUserInfoModel.h
//  TTNews
//
//  Created by jiahui on 2016/12/25.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTBaseModel.h"

@interface TTUserInfoModel : TTBaseModel

@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, strong) NSString *homeVerCode;
@property (nonatomic, strong) NSString *cfgVerCode;
//@property (nonatomic, strong) NSNumber *newMsgNum;
@property (nonatomic, copy) NSString *regDate;
@property (nonatomic, strong) NSNumber *favNewsNum;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, strong) NSMutableDictionary *avatar;///dir, ext, prefix, name, namePostfix
@property (nonatomic, copy) NSString *cmtCounter;
@property (nonatomic, strong) NSNumber *shareCounter;
@property (nonatomic, strong) NSNumber *shareGrade;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, strong) NSNumber *updateGrade;
@property (nonatomic, copy) NSString *levelInfo;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *isGentle;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSMutableArray *label;
@property (nonatomic, copy) NSString *resume;


@end
