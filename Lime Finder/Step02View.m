//
//  Step02View.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 29..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "Step02View.h"
#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"

#define TITLE_IMAGE_VIEW_SIDE_MARGINE           0
#define TITLE_IMAGE_VIEW_TOP_BOTTOM_MARGINE     0
#define TITLE_IMAGE_VIEW_WIDTH                  320.0
#define TITLE_IMAGE_VIEW_HEIGHT                 75.0
#define HELP_IMAGE_VIEW_SIDE_MARGINE            0
#define HELP_IMAGE_VIEW_TOP_BOTTOM_MARGINE      0
#define HELP_IMAGE_VIEW_WIDTH                   320.0
#define HELP_IMAGE_VIEW_HEIGHT                  20.0
#define URL_LABEL_WIDTH                         300.0
#define URL_LABEL_HEIGHT                        15.0
#define URL_LABEL_TOP_BOTTOM_MARGINE            30.0
#define URL_LABEL_SIDE_MARGINE                  10.0
#define URL_LABEL_FONT_SIZE                     14.0
#define TEXTFIELD_SIDE_MARGINE                  10.0
#define TEXTFIELD_TOP_BOTTOM_MARGINE            14.0
#define TEXTFIELD_WIDTH                         300.0
#define TEXTFIELD_HEIGHT                        35.0
#define SELF_HEIGHT                             200.0


@implementation Step02View

@synthesize     rootViewController_;
@synthesize     clearButton_;
@synthesize     urlLabel_;
@synthesize     itemManageTextField_;
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
        
        self.frame = CGRectMake(self.frame.origin.x, self.bounds.origin.y - SELF_HEIGHT, self.bounds.size.width, SELF_HEIGHT);
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
    UIImage *helpImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favorites_title_step01_txt" ofType:@"png"]];
    UIImageView *helpImageView = [[UIImageView alloc] initWithImage:helpImage];
    helpImageView.frame = CGRectMake(self.bounds.origin.x + HELP_IMAGE_VIEW_SIDE_MARGINE, titleImageView.frame.origin.y + TITLE_IMAGE_VIEW_HEIGHT, HELP_IMAGE_VIEW_WIDTH, HELP_IMAGE_VIEW_HEIGHT);
    [self addSubview:helpImageView];
    
    // URL 라벨 //
    urlLabel_ = [[UILabel alloc] init];
    urlLabel_.text = @"";
    urlLabel_.font = [UIFont systemFontOfSize:URL_LABEL_FONT_SIZE];
    urlLabel_.textColor = [[UIColor alloc] initWithRed:(114.0 / 255.0) green:(210.0 / 255.0) blue:(216.0 / 255.0) alpha:1.0];
    urlLabel_.frame = CGRectMake(self.bounds.origin.x + URL_LABEL_SIDE_MARGINE, helpImageView.frame.origin.y + helpImageView.bounds.size.height + URL_LABEL_TOP_BOTTOM_MARGINE , URL_LABEL_WIDTH, URL_LABEL_HEIGHT);
    [self addSubview:urlLabel_];
    
    // 텍스트필드 //
    UIImage *clearButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_fieldset_btn_closs" ofType:@"png"]];
    UIView  *clearBlankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 39.0, 34.0)];
    clearButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton_ setImage:clearButtonImage forState:UIControlStateNormal];
    [clearButton_ setFrame:CGRectMake(0, 0, 34.0, 34.0)];
    [clearButton_ addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchDown];
    clearButton_.hidden = YES;
    [clearBlankView addSubview:clearButton_];
    
    
    UIView  *blank = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, TEXTFIELD_HEIGHT)];
    
    itemManageTextField_ = [[ItemManageTextField alloc] initWithFrame:CGRectMake(self.bounds.origin.x + TEXTFIELD_SIDE_MARGINE, urlLabel_.frame.origin.y + urlLabel_.bounds.size.height + TEXTFIELD_TOP_BOTTOM_MARGINE, TEXTFIELD_WIDTH, TEXTFIELD_HEIGHT)];
    itemManageTextField_.textColor = [UIColor whiteColor];
    itemManageTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    itemManageTextField_.leftViewMode = UITextFieldViewModeAlways;
    itemManageTextField_.leftView = blank;
    itemManageTextField_.rightViewMode = UITextFieldViewModeAlways;
    itemManageTextField_.rightView = clearBlankView;
    itemManageTextField_.adjustsFontSizeToFitWidth = YES;
    itemManageTextField_.delegate = self;
    [itemManageTextField_ addTarget:self action:@selector(searchFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [itemManageTextField_ addTarget:self action:@selector(searchFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [itemManageTextField_ addTarget:self action:@selector(searchFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self addSubview:itemManageTextField_];
}


/* 뷰의 객체를 재초기화 한다. */
- (void)resetView
{
    itemManageTextField_.text = @"";
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
    [rootViewController_.itemManageViewController_ hideMessageView:NO];
    [rootViewController_.itemManageViewController_ hideCloseMessageView:NO];
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
    [rootViewController_.itemManageViewController_ setSequence:ITEM_MANAGE_SEQUENCE_STEP_02_01];
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
