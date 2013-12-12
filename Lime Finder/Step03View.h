//
//  Step03View.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 30..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemManageTextField.h"
#import "ItemManage.h"

@class RootViewController;

@interface Step03View : UIView <UITextFieldDelegate>
{
    RootViewController      *rootViewController_;
    UIButton                *clearButton_;
    ItemManageTextField     *itemManageTextField_;
    UILabel                 *helpLabel_;
    UIImageView             *helpImage_view_;
    ItemManageSequence      itemManageSequence_;
}

@property (nonatomic, retain)   RootViewController    *rootViewController_;
@property (nonatomic, retain)   UIButton              *clearButton_;
@property (nonatomic, retain)   ItemManageTextField   *itemManageTextField_;
@property (nonatomic, retain)   UILabel               *helpLabel_;
@property (nonatomic, retain)   UIImageView           *helpImageView_;
@property (nonatomic)           ItemManageSequence    itemManageSequence_;


/* 서브뷰를 초기화 한다. */
- (void)initSubView;

/* 뷰의 객체를 재초기화 한다. */
- (void)resetView;

/* 현재 시퀀스를 설정한다. */
- (void)setSequence:(ItemManageSequence)sequence;

/* 텍스트필트를 클리어 한다. */
- (void)clearText:(id)sender;

/* 텍스트필드를 수정을 완료함 */
- (void)searchFieldEditingDidEnd:(id)sender;

/* 텍스트필드를 수정을 완료하고 키보드 리턴 */
- (void)searchFieldEditingDidEndOnExit:(id)sender;

@end
