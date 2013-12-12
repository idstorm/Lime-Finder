//
//  Step03View.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 30..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "Step03View.h"
#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"

#define TITLE_IMAGE_VIEW_SIDE_MARGINE           0
#define TITLE_IMAGE_VIEW_TOP_BOTTOM_MARGINE     0
#define TITLE_IMAGE_VIEW_WIDTH                  320.0
#define TITLE_IMAGE_VIEW_HEIGHT                 75.0
#define HELP_IMAGE_VIEW_SIDE_MARGINE            0
#define HELP_IMAGE_VIEW_TOP_BOTTOM_MARGINE      0
#define HELP_IMAGE_VIEW_WIDTH                   320.0
#define HELP_IMAGE_VIEW_HEIGHT                  40
#define HELP_LABEL_WIDTH                        300.0
#define HELP_LABEL_HEIGHT                       40.0
#define HELP_LABEL_TOP_BOTTOM_MARGINE           10.0
#define HELP_LABEL_SIDE_MARGINE                 10.0
#define HELP_LABEL_FONT_SIZE                    15.0
#define HELP_LABEL_BOLD_FONT_SIZE               15.0
#define TEXTFIELD_SIDE_MARGINE                  10.0
#define TEXTFIELD_TOP_BOTTOM_MARGINE            40.0
#define TEXTFIELD_WIDTH                         300.0
#define TEXTFIELD_HEIGHT                        35.0
#define SELF_HEIGHT                             125.0

@implementation Step03View

@synthesize     rootViewController_;
@synthesize     clearButton_;
@synthesize     itemManageTextField_;
@synthesize     helpImageView_;
@synthesize     helpLabel_;
@synthesize     itemManageSequence_;

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
    UIImage *titleImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_title_step02" ofType:@"png"]];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    titleImageView.frame = CGRectMake(self.bounds.origin.x + TITLE_IMAGE_VIEW_SIDE_MARGINE, self.bounds.origin.y + TITLE_IMAGE_VIEW_TOP_BOTTOM_MARGINE, TITLE_IMAGE_VIEW_WIDTH, TITLE_IMAGE_VIEW_HEIGHT);
    [self addSubview:titleImageView];
    
    // 도움말 이미지 뷰 //
    UIImage *helpImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_title_step02_txt" ofType:@"png"]];
    helpImageView_ = [[UIImageView alloc] initWithImage:helpImage];
    helpImageView_.frame = CGRectMake(self.bounds.origin.x + HELP_IMAGE_VIEW_SIDE_MARGINE, titleImageView.frame.origin.y + titleImageView.bounds.size.height + HELP_IMAGE_VIEW_TOP_BOTTOM_MARGINE, HELP_IMAGE_VIEW_WIDTH, HELP_IMAGE_VIEW_HEIGHT);
    [self addSubview:helpImageView_];
    
    // URL 라벨 //
    helpLabel_ = [[UILabel alloc] init];
    
    UIFont *boldFont = [UIFont boldSystemFontOfSize:HELP_LABEL_BOLD_FONT_SIZE];
    UIFont *regularFont = [UIFont systemFontOfSize:HELP_LABEL_FONT_SIZE];
    UIColor *foregroundColor = [[UIColor alloc] initWithRed:(215.0 / 255.0) green:(253.0 / 255.0) blue:(255.0 / 255.0) alpha:1.0];
    UIColor *highlightColor = [UIColor whiteColor];
    
    // Label의 문자열 속성을 설정한다. //
    
    // 기본 문자열 설정 - 레귤러 폰트, grayColor
    NSDictionary *attrsDefault = [NSDictionary dictionaryWithObjectsAndKeys:
                                  regularFont, NSFontAttributeName,
                                  foregroundColor, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *attrsHighlight = [NSDictionary dictionaryWithObjectsAndKeys:
                                    boldFont, NSFontAttributeName,
                                    highlightColor, NSForegroundColorAttributeName, nil];

    NSString *subMessage = @"웹페이지 검색창에 라임파인더를 검색하세요.";

    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:subMessage
                                           attributes:attrsDefault];
    [attributedText setAttributes:attrsHighlight range:[subMessage rangeOfString:@"라임파인더"]];
    
    [helpLabel_ setAttributedText:attributedText];
    helpLabel_.textAlignment = NSTextAlignmentCenter;
    helpLabel_.backgroundColor = [UIColor clearColor];
    helpLabel_.frame = CGRectMake(self.bounds.origin.x + HELP_LABEL_SIDE_MARGINE, titleImageView.frame.origin.y + titleImageView.bounds.size.height + HELP_LABEL_TOP_BOTTOM_MARGINE, HELP_LABEL_WIDTH, HELP_LABEL_HEIGHT);
    helpLabel_.hidden = YES;
    [self addSubview:helpLabel_];

}


/* 뷰의 객체를 재초기화 한다. */
- (void)resetView
{
    [itemManageTextField_ resignFirstResponder];
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


/* 텍스트필드의 수정이 시작 되다. */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [rootViewController_.itemManageViewController_ setSequence:ITEM_MANAGE_SEQUENCE_STEP_02_02];
    // 수정이 시작되고, searchField의 값이 있을경우만 클리어 버튼을 보인다.
    if (![itemManageTextField_.text isEqualToString:@""] && itemManageTextField_.text != nil)
    {
        clearButton_.hidden = NO;
    }
    else
    {
        clearButton_.hidden = YES;
    }
    return YES;
}


/* 텍스트필드의 값이 변경되다. */
- (void)searchFieldValueChanged:(id)sender
{
    if ([itemManageTextField_.text isEqualToString:@""] || itemManageTextField_.text == nil)
    {
        clearButton_.hidden = YES;
    }
    else
    {
        clearButton_.hidden = NO;
    }
}


/* 텍스트필트를 클리어 한다. */
- (void)clearText:(id)sender
{
    itemManageTextField_.text = @"";
    clearButton_.hidden = YES;
}


/* 텍스트필드를 수정을 완료함 */
- (void)searchFieldEditingDidEnd:(id)sender
{
//    if (rootViewController_.mainViewController_.itemManageViewController_.messageView_.messageViewState_ == MESSAGE_VIEW_STATE_STEP_02_TITLE_EDITING)
//        [rootViewController_.mainViewController_.itemManageViewController_ setSequence:ITEM_MANAGE_SEQUENCE_STEP_02_01];
    clearButton_.hidden = YES;
}


/* 텍스트필드를 수정을 완료하고 키보드 리턴 */
- (void)searchFieldEditingDidEndOnExit:(id)sender
{
    [rootViewController_.itemManageViewController_ setSequence:ITEM_MANAGE_SEQUENCE_STEP_02_01];
    clearButton_.hidden = YES;
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