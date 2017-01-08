//
//  DetailViewController.h
//  TTNews
//
//  Created by jiahui on 16/3/29.
//  Copyright © 2016Y Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"
#import "TTNewListModel.h"

@interface TTDetailViewController : TTBaseViewController

@property (nonatomic, strong) TTNewListModel *detailModel;
@property (nonatomic, strong) NSNumber *article_id;

@end
