//
//  Step04View.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 31..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "Step04View.h"
#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"

#define TITLE_IMAGE_VIEW_SIDE_MARGINE           0
#define TITLE_IMAGE_VIEW_TOP_BOTTOM_MARGINE     0
#define TITLE_IMAGE_VIEW_WIDTH                  320.0
#define TITLE_IMAGE_VIEW_HEIGHT                 75.0
#define HELP_IMAGE_VIEW_SIDE_MARGINE            0
#define HELP_IMAGE_VIEW_TOP_BOTTOM_MARGINE      0
#define HELP_IMAGE_VIEW_WIDTH                   320.0
#define HELP_IMAGE_VIEW_HEIGHT                  100.0

#define BUTTON_TOP_GAP                       5.0
#define BUTTON_SIDE_MARGINE                  10.0
#define BUTTON_TOP_BOTTOM_MARGINE            10.0
#define BUTTON_WIDTH                         150.0
#define BUTTON_HEIGHT                        34.0
#define SELF_HEIGHT                             TITLE_IMAGE_VIEW_TOP_BOTTOM_MARGINE + TITLE_IMAGE_VIEW_HEIGHT + HELP_IMAGE_VIEW_TOP_BOTTOM_MARGINE + HELP_IMAGE_VIEW_HEIGHT + BUTTON_TOP_GAP + BUTTON_TOP_BOTTOM_MARGINE + BUTTON_HEIGHT + BUTTON_TOP_BOTTOM_MARGINE

@implementation Step04View

@synthesize     rootViewController_;
@synthesize     itemManageSequence_;
@synthesize     checkButton_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        
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
        
        self.frame = CGRectMake(self.frame.origin.x, self.bounds.origin.y, self.bounds.size.width, SELF_HEIGHT);
        
        // 서브뷰를 초기화 한다. //
        [self initSubView];
    }
    return self;
}


/* 서브뷰를 초기화 한다. */
- (void)initSubView
{
    // 타이틀 이미지 뷰 //
    UIImage *titleImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_title_step04" ofType:@"png"]];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    titleImageView.frame = CGRectMake(self.bounds.origin.x + TITLE_IMAGE_VIEW_SIDE_MARGINE, self.bounds.origin.y + TITLE_IMAGE_VIEW_TOP_BOTTOM_MARGINE, TITLE_IMAGE_VIEW_WIDTH, TITLE_IMAGE_VIEW_HEIGHT);
    [self addSubview:titleImageView];
    
    // 도움말 이미지 뷰 //
    UIImage *helpImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favicon_dummy" ofType:@"png"]];
    UIImageView *helpImageView = [[UIImageView alloc] initWithImage:helpImage];
    helpImageView.frame = CGRectMake(self.bounds.origin.x + HELP_IMAGE_VIEW_SIDE_MARGINE, titleImageView.frame.origin.y + titleImageView.bounds.size.height + HELP_IMAGE_VIEW_TOP_BOTTOM_MARGINE, HELP_IMAGE_VIEW_WIDTH, HELP_IMAGE_VIEW_HEIGHT);
    [self addSubview:titleImageView];
    
    // 체크버튼 //
    UIImage *checkButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_btn_url_encoding" ofType:@"png"]];
    UIImage *checkButtonImageOn = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_btn_url_encoding_over" ofType:@"png"]];
    checkButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton_ setImage:checkButtonImage forState:UIControlStateNormal];
    [checkButton_ setImage:checkButtonImageOn forState:UIControlStateSelected];
    [checkButton_ addTarget:self action:@selector(checkButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    checkButton_.frame = CGRectMake(self.bounds.size.width / 2.0 - BUTTON_WIDTH / 2.0 , helpImageView.frame.origin.y + helpImageView.bounds.size.height + BUTTON_TOP_BOTTOM_MARGINE, BUTTON_WIDTH, BUTTON_HEIGHT);
    [self addSubview:checkButton_];
    
}


/* 뷰의 객체를 재초기화 한다. */
- (void)resetView
{
    checkButton_.selected = NO;
}


/* 체크버튼이 터치되었다. */
- (void)checkButtonTouched:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    
    if (button.selected)
    {
        [rootViewController_.itemManageViewController_.itemMutableDictionary_ setObject:@"YES" forKey:@"EncodeUTF8"];
    }
    else
    {
        [rootViewController_.itemManageViewController_.itemMutableDictionary_ setObject:@"NO" forKey:@"EncodeUTF8"];
    }
}


/* 현재 시퀀스를 설정한다. */
- (void)setSequence:(ItemManageSequence)sequence
{
    itemManageSequence_ = sequence;
    switch (itemManageSequence_)
    {
        case ITEM_MANAGE_SEQUENCE_STEP_02_01:
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



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end