//
//  MessageView.h
//  Lime Finder
//
//  Created by idstorm on 13. 5. 28..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemManage.h"

#define MESSAGE_VIEW_MESSAGE_SIDE_MARGINE               35.0
#define MESSAGE_VIEW_MESSAGE_TOP_BOTTOM_MARGINE         20.0
#define MESSAGE_VIEW_MESSAGE_WIDTH                      250.0
#define MESSAGE_VIEW_MESSAGE_HEIGHT                     40.0
#define MESSAGE_VIEW_MESSAGE_LABEL_SIDE_MARGINE         0
#define MESSAGE_VIEW_MESSAGE_LABEL_TOP_BOTTOM_MARGINE   0
#define MESSAGE_VIEW_MESSAGE_LABEL_WIDTH                250.0
#define MESSAGE_VIEW_MESSAGE_LABEL_HEIGHT               34.0
#define MESSAGE_VIEW_MESSAGE_LABEL_FONT_SIZE            13.0
#define MESSAGE_VIEW_BUTTON_SIDE_MARGINE                34.0
#define MESSAGE_VIEW_BUTTON_TOP_BOTTOM_MARGINE          15.0
#define MESSAGE_VIEW_BUTTON_GAP                         10.0
#define MESSAGE_VIEW_BUTTON_WIDTH                       120.0
#define MESSAGE_VIEW_BUTTON_HEIGHT                      34.0

typedef enum
{
        MESSAGE_VIEW_STATE_STEP_01_URL_VALID,
        MESSAGE_VIEW_STATE_STEP_01_URL_VALID_LEFT,
        MESSAGE_VIEW_STATE_STEP_01_URL_VALID_RIGHT,
        MESSAGE_VIEW_STATE_STEP_01_URL_INVALID,
        MESSAGE_VIEW_STATE_STEP_01_URL_INVALID_LEFT,
        MESSAGE_VIEW_STATE_STEP_01_URL_INVALID_RIGHT,
        MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM,
        MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM_LEFT,
        MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM_RIGHT,
        MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST,
        MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST_LEFT,
        MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST_RIGHT,
        MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID,
        MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID_LEFT,
        MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID_RIGHT,
        MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_INVALID,
        MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_INVALID_LEFT,
        MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_INVALID_RIGHT,
        MESSAGE_VIEW_STATE_STEP_04_URL_ENCODING_CONFIRM,
        MESSAGE_VIEW_STATE_STEP_04_URL_ENCODING_CONFIRM_LEFT,
        MESSAGE_VIEW_STATE_STEP_04_URL_ENCODING_CONFIRM_RIGHT,
        MESSAGE_VIEW_STATE_STEP_05_SPACE_ENCODING_CONFIRM,
        MESSAGE_VIEW_STATE_STEP_05_SPACE_ENCODING_CONFIRM_LEFT,
        MESSAGE_VIEW_STATE_STEP_05_SPACE_ENCODING_CONFIRM_RIGHT
    
} MessageViewState;


@interface MessageView : UIView
{
    UIImage     *messageBoxGray_;
    UIImage     *messageBoxOrange_;
    UIImageView *messageBoxImageView_;
    UILabel     *messageLabel_;
    
    UIImage     *leftButtonImage_;
    UIImage     *rightButtonImage_;
    UIButton    *leftButton_;
    UIButton    *rightButton_;
    
    MessageViewState  messageViewState_;
    ItemManageSequence  itemManageSequence_;
}

@property (nonatomic, retain) UIImage     *messageBoxGray_;
@property (nonatomic, retain) UIImage     *messageBoxOrange_;
@property (nonatomic, retain) UIImageView *messageBoxImageView_;
@property (nonatomic, retain) UILabel     *messageLabel_;

@property (nonatomic, retain) UIImage     *leftButtonImage_;
@property (nonatomic, retain) UIImage     *rightButtonImage_;
@property (nonatomic, retain) UIButton    *leftButton_;
@property (nonatomic, retain) UIButton    *rightButton_;
@property (nonatomic)         MessageViewState  messageViewState_;
@property (nonatomic)         ItemManageSequence  itemManageSequence_;


/* 서브뷰를 초기화 한다. */
- (void)initSubView;

/* 뷰의 객체를 재초기화 한다. */
- (void)resetView;

/* 현재 상태를 설정한다. */
- (void)setState:(MessageViewState)state;

/* 현재 시퀀스를 설정한다. */
- (void)setSequence:(ItemManageSequence)sequence;

@end
