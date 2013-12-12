//
//  Step01View.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 28..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "Step01View.h"
#import <QuartzCore/QuartzCore.h>

#define TITLE_IMAGE_VIEW_SIDE_MARGINE           0
#define TITLE_IMAGE_VIEW_TOP_BOTTOM_MARGINE     0
#define TITLE_IMAGE_VIEW_WIDTH                  320.0
#define TITLE_IMAGE_VIEW_HEIGHT                 75.0
#define HELP_IMAGE_VIEW_SIDE_MARGINE            0
#define HELP_IMAGE_VIEW_TOP_BOTTOM_MARGINE      0
#define HELP_IMAGE_VIEW_WIDTH                   320.0
#define HELP_IMAGE_VIEW_HEIGHT                  100.0
#define URL_BAR_TOP_BOTTOM_MARGINE              5
#define URL_BAR_WIDTH                           320
#define URL_BAR_HEIGHT                          54
#define SELF_HEIGHT                             TITLE_IMAGE_VIEW_TOP_BOTTOM_MARGINE + TITLE_IMAGE_VIEW_HEIGHT + HELP_IMAGE_VIEW_TOP_BOTTOM_MARGINE + HELP_IMAGE_VIEW_HEIGHT + URL_BAR_TOP_BOTTOM_MARGINE + URL_BAR_HEIGHT

@implementation Step01View
@synthesize     itemManageURLBar_;
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
        
        self.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, SELF_HEIGHT);
        
        // 서브뷰를 초기화 한다. //
        [self initSubView];
    }
    return self;
}


/* 서브뷰를 초기화 한다. */
- (void)initSubView
{
    // 타이틀 이미지 뷰 //
    UIImage *titleImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_title_step01" ofType:@"png"]];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    titleImageView.frame = CGRectMake(self.bounds.origin.x + TITLE_IMAGE_VIEW_SIDE_MARGINE, self.bounds.origin.y + TITLE_IMAGE_VIEW_TOP_BOTTOM_MARGINE, TITLE_IMAGE_VIEW_WIDTH, TITLE_IMAGE_VIEW_HEIGHT);
    [self addSubview:titleImageView];
    
    // 도움말 이미지 뷰 //
    UIImage *helpImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favicon_dummy" ofType:@"png"]];
    UIImageView *helpImageView = [[UIImageView alloc] initWithImage:helpImage];
    helpImageView.frame = CGRectMake(self.bounds.origin.x + HELP_IMAGE_VIEW_SIDE_MARGINE, titleImageView.frame.origin.y + titleImageView.bounds.size.height + HELP_IMAGE_VIEW_TOP_BOTTOM_MARGINE, HELP_IMAGE_VIEW_WIDTH, HELP_IMAGE_VIEW_HEIGHT);
    [self addSubview:titleImageView];
    
    // URL 바 //
    itemManageURLBar_ = [[ItemManageURLBar alloc] initWithFrame:CGRectMake(self.bounds.origin.x, helpImageView.frame.origin.y + helpImageView.bounds.size.height + URL_BAR_TOP_BOTTOM_MARGINE, URL_BAR_WIDTH, URL_BAR_HEIGHT)];
    itemManageURLBar_.backgroundColor = [UIColor whiteColor];
    [self addSubview:itemManageURLBar_];
}

/* 뷰의 객체를 재초기화 한다. */
- (void)resetView
{
    itemManageURLBar_.urlTextField_.text = @"";
    itemManageURLBar_.reloadButton_.hidden = YES;
    [itemManageURLBar_.urlTextField_ resignFirstResponder];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
