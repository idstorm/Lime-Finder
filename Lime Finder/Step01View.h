//
//  Step01View.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 28..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemManageURLBar.h"
#import "ItemManage.h"



@interface Step01View : UIView
{
    ItemManageURLBar    *itemManageURLBar_;
    ItemManageSequence  itemManageSequence_;
}

@property (nonatomic, retain)   ItemManageURLBar    *itemManageURLBar_;
@property (nonatomic) ItemManageSequence  itemManageSequence_;

/* 서브뷰를 초기화 한다. */
- (void)initSubView;

/* 뷰의 객체를 재초기화 한다. */
- (void)resetView;

/* 현재 시퀀스를 설정한다. */
- (void)setSequence:(ItemManageSequence)sequence;

@end
