//
//  WebURLBar.m
//  Lime Finder
//
//  Created by idstorm on 13. 4. 28..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "WebURLBar.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebURLBar

@synthesize urlTextField_;
@synthesize clearButton_;
@synthesize reloadButton_;
@synthesize rootViewController_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        
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
        
        [self initViews];
    }
    return self;
}


/* 서브뷰를 초기화 한다. */
- (void)initViews
{
    // URL 입력 필드 //
    UIImage *clearButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_fieldset_btn_closs" ofType:@"png"]];
    UIImage *reloadButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_fieldset_btn_reload" ofType:@"png"]];
    UIView  *blank = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, 15.0)];
    UIView  *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 39.0, 34.0)];
    clearButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton_ setImage:clearButtonImage forState:UIControlStateNormal];
    [clearButton_ setFrame:CGRectMake(0, 0, 34.0, 34.0)];
    [clearButton_ addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchDown];
    clearButton_.hidden = YES;
    [rightButtonView addSubview:clearButton_];
    reloadButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadButton_ setImage:reloadButtonImage forState:UIControlStateNormal];
    [reloadButton_ setFrame:CGRectMake(0, 0, 34.0, 34.0)];
    [reloadButton_ addTarget:self action:@selector(reloadWebView:) forControlEvents:UIControlEventTouchDown];
    reloadButton_.hidden = YES;
    [rightButtonView addSubview:reloadButton_];
    urlTextField_ = [[WebURLBarTextField alloc] initWithFrame:CGRectMake(self.bounds.origin.x + 10.0, self.bounds.origin.y + 7.0, self.bounds.size.width - 20.0, self.bounds.size.height - 14.0)];
    urlTextField_.leftViewMode = UITextFieldViewModeAlways;
    urlTextField_.leftView = blank;
    urlTextField_.rightViewMode = UITextFieldViewModeAlways;
    urlTextField_.rightView = rightButtonView;
    urlTextField_.borderStyle = UITextBorderStyleNone;
    urlTextField_.adjustsFontSizeToFitWidth = YES;
    urlTextField_.textColor = [UIColor whiteColor];
    urlTextField_.keyboardType = UIKeyboardTypeURL;
    urlTextField_.returnKeyType = UIReturnKeyGo;
    urlTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    urlTextField_.backgroundColor = [UIColor whiteColor];
    //urlTextField_.background = urlTextFieldBackgroundImage;
    [urlTextField_ addTarget:self action:@selector(urlTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    urlTextField_.delegate = self;
   [self addSubview:urlTextField_];
}


- (void)layoutSubviews
{
    //[urlTextField_ setFrame:CGRectMake(self.bounds.origin.x + 6.f, self.bounds.origin.y + 6.f, self.bounds.size.width - 12.f, self.bounds.size.height - 12.f)];
    [super layoutSubviews];
}


/* 로딩 진행상태 표시를 시작한다. */

- (void)startProgress
{
    if (urlTextField_.showProgress_ == NO)
        [urlTextField_ showProgressBar];
}


/* 진행상태를 세팅한다. */
- (void)setProgress:(NSInteger)completedCount totalCount:(NSInteger)totalCount
{
    if (totalCount == 0)
        return;
    CGFloat completed = (CGFloat)completedCount / (CGFloat)totalCount;
    [urlTextField_ setProgress:completed];
}


/* 로딩 진행상태 표시를 끝낸다. */
- (void)endProgress
{
    [urlTextField_ hideProgressBar];
}


/* URL 텍스트필트를 클리어 한다. */
- (void)clearText:(id)sender
{
    urlTextField_.text = @"";
    clearButton_.hidden = YES;
    reloadButton_.hidden = YES;
}


/* 웹페이지를 새로고침한다. */
- (void)reloadWebView:(id)sender
{
    [rootViewController_.webViewController_.webView_ reload];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



#pragma -
#pragma mark - UITextFieldDelegate 매서드
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""] || textField.text == nil)
        return NO;
    
    NSString *string = textField.text;
    NSString *urlString;
    
    if([[string lowercaseString] rangeOfString:@"http://"].location == NSNotFound && [[string lowercaseString] rangeOfString:@"https://"].location == NSNotFound)
        urlString = [[NSString alloc] initWithFormat:@"http://%@", string];
    else
        urlString = string;
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [rootViewController_.webViewController_ requestWithURL:url];
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    rootViewController_.webViewController_.shadowScreen_.hidden = NO;
    
    if (![urlTextField_.text isEqualToString:@""] && urlTextField_.text != nil)
    {
        clearButton_.hidden = NO;
        reloadButton_.hidden = YES;
    }
    else
    {
        clearButton_.hidden = YES;
        reloadButton_.hidden = YES;
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    rootViewController_.webViewController_.shadowScreen_.hidden = YES;
    clearButton_.hidden = YES;
    reloadButton_.hidden = NO;
}


/* 텍스트 필드의 값이 변경되다. */
- (void)urlTextFieldEditingChanged:(id)sender
{
    if (![urlTextField_.text isEqualToString:@""] && urlTextField_.text != nil)
    {
        clearButton_.hidden = NO;
        reloadButton_.hidden = YES;
    }
    else
    {
        clearButton_.hidden = YES;
        reloadButton_.hidden = YES;
    }
}





@end
