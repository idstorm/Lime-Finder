//
//  CloseMessageView.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 30..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "CloseMessageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CloseMessageView

@synthesize     messageBoxGray_;
@synthesize     messageBoxOrange_;
@synthesize     messageBoxImageView_;
@synthesize     messageLabel_;

@synthesize     leftButtonImage_;
@synthesize     rightButtonImage_;
@synthesize     leftButton_;
@synthesize     rightButton_;

@synthesize     closeMessageViewState_;
@synthesize     itemManageSequence_;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 쉐도우 //
        CGFloat shadowColor[] = {0, 0, 0, 1.f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpace, shadowColor);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOffset = CGSizeMake(0.0, 3.0);
        self.layer.shadowRadius = 3.0;
        self.layer.shadowColor = color;
        self.layer.shadowOpacity = 0.5;
        CGColorRelease(color);
        CGColorSpaceRelease(colorSpace);
        
        // 서브뷰를 초기화 한다. //
        [self initSubView];
    }
    return self;
}


/* 뷰의 객체를 재초기화 한다. */
- (void)resetView
{
    [self setState:CLOSE_MESSAGE_VIEW_STATE_STEP_01_URL_VALID];
}


/* 서브뷰를 초기화 한다. */
- (void)initSubView
{
    // 메세지 박스 //
    messageBoxGray_ = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_message_bg_01" ofType:@"png"]];
    messageBoxOrange_ = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_message_bg_02" ofType:@"png"]];
    messageBoxImageView_ = [[UIImageView alloc] initWithImage:messageBoxGray_];
    messageBoxImageView_.frame = CGRectMake(self.bounds.origin.x + CLOSE_MESSAGE_VIEW_MESSAGE_SIDE_MARGINE, self.bounds.origin.y + CLOSE_MESSAGE_VIEW_MESSAGE_TOP_BOTTOM_MARGINE, CLOSE_MESSAGE_VIEW_MESSAGE_WIDTH, CLOSE_MESSAGE_VIEW_MESSAGE_HEIGHT);
    [self addSubview:messageBoxImageView_];
    
    // 메세지 라벨 //
    messageLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(messageBoxImageView_.bounds.origin.x + CLOSE_MESSAGE_VIEW_MESSAGE_LABEL_SIDE_MARGINE, messageBoxImageView_.bounds.origin.y + CLOSE_MESSAGE_VIEW_MESSAGE_LABEL_TOP_BOTTOM_MARGINE, CLOSE_MESSAGE_VIEW_MESSAGE_LABEL_WIDTH, CLOSE_MESSAGE_VIEW_MESSAGE_LABEL_HEIGHT)];
    messageLabel_.textAlignment = NSTextAlignmentCenter;
    messageLabel_.font = [UIFont systemFontOfSize:CLOSE_MESSAGE_VIEW_MESSAGE_LABEL_FONT_SIZE];
    messageLabel_.backgroundColor = [UIColor clearColor];
    messageLabel_.textColor = [UIColor colorWithRed:(136.0 / 255.0) green:(136.0 / 255.0) blue:(136.0 / 255.0) alpha:1.0];
    [messageBoxImageView_ addSubview:messageLabel_];
    
    // 왼쪽 버튼 //
    leftButtonImage_ = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_btn_type_01" ofType:@"png"]];
    leftButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton_ setBackgroundImage:leftButtonImage_ forState:UIControlStateNormal];
    leftButton_.frame = CGRectMake(self.bounds.origin.x + CLOSE_MESSAGE_VIEW_BUTTON_SIDE_MARGINE, messageBoxImageView_.frame.origin.y + messageBoxImageView_.bounds.size.height + CLOSE_MESSAGE_VIEW_BUTTON_TOP_BOTTOM_MARGINE, CLOSE_MESSAGE_VIEW_BUTTON_WIDTH, CLOSE_MESSAGE_VIEW_BUTTON_HEIGHT);
    leftButton_.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:leftButton_];
    
    // 오른쪽 버튼 //
    rightButtonImage_ = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_btn_type_02" ofType:@"png"]];
    rightButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton_ setBackgroundImage:rightButtonImage_ forState:UIControlStateNormal];
    rightButton_.frame = CGRectMake(leftButton_.frame.origin.x + leftButton_.bounds.size.width + CLOSE_MESSAGE_VIEW_BUTTON_GAP, messageBoxImageView_.frame.origin.y + messageBoxImageView_.bounds.size.height + CLOSE_MESSAGE_VIEW_BUTTON_TOP_BOTTOM_MARGINE, CLOSE_MESSAGE_VIEW_BUTTON_WIDTH, CLOSE_MESSAGE_VIEW_BUTTON_HEIGHT);
    rightButton_.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:rightButton_];
}


/* 현재 상태를 설정한다. */
- (void)setState:(CloseMessageViewState)state
{
    closeMessageViewState_ = state;
    switch (closeMessageViewState_)
    {
        case CLOSE_MESSAGE_VIEW_STATE_STEP_02_TITLE_CONFIRM:
        case CLOSE_MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_REQUEST:
        case CLOSE_MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_VALID:
        case CLOSE_MESSAGE_VIEW_STATE_STEP_03_SEARCH_URL_INVALID:
        {
            messageBoxImageView_.image = messageBoxOrange_;
            messageLabel_.text = @"등록을 취소하시겠습니까?";
            [leftButton_ setTitle:@"아니오" forState:UIControlStateNormal];
            [rightButton_ setTitle:@"예" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}


/* 현재 시퀀스를 설정한다. */
- (void)setSequence:(ItemManageSequence)sequence
{
    itemManageSequence_ = sequence;
    switch (itemManageSequence_)
    {
        case ITEM_MANAGE_SEQUENCE_STEP_01_01:
        {
            
        }
            break;
        case ITEM_MANAGE_SEQUENCE_STEP_01_02:
        {
            
        }
            break;
            
        default:
            break;
    }
}

@end
