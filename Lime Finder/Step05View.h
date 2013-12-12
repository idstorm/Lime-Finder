//
//  Step05View.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 31..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemManage.h"

@class RootViewController;

@interface Step05View : UIView
{
    RootViewController      *rootViewController_;
    ItemManageSequence      itemManageSequence_;
    UIButton                *checkButton_;
}

@property (nonatomic, retain)   RootViewController    *rootViewController_;
@property (nonatomic)           ItemManageSequence    itemManageSequence_;
@property (nonatomic, retain)   UIButton              *checkButton_;

/* 서브뷰를 초기화 한다. */
- (void)initSubView;

/* 뷰의 객체를 재초기화 한다. */
- (void)resetView;

/* 현재 시퀀스를 설정한다. */
- (void)setSequence:(ItemManageSequence)sequence;

/* 체크버튼이 터치되었다. */
- (void)checkButtonTouched:(id)sender;

@end

