//
//  InfoView.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 27..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "InfoView.h"
#import "RootViewController.h"

@implementation InfoView
@synthesize rootViewController_;
@synthesize appLogoButton_;
@synthesize teamLogoButton_;
@synthesize limeWorksLinkButton_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        [self initSubViews];
    }
    return self;
}


/* 서브뷰를 초기화 한다. */
-(void)initSubViews
{
    UIImage *appLogoImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info_limefinder_logo" ofType:@"png"]];
    UIImage *teamLogoImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info_limeworks_logo" ofType:@"png"]];
    UIImage *limeWorksLinkImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info_limeworks_logo_link" ofType:@"png"]];
    
    appLogoButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [appLogoButton_ setImage:appLogoImage forState:UIControlStateNormal];
    [appLogoButton_ setImage:appLogoImage forState:UIControlStateSelected];
    [appLogoButton_ setImage:appLogoImage forState:UIControlStateHighlighted];
    appLogoButton_.frame = CGRectMake(self.bounds.origin.x + INFO_VIEW_APP_LOGO_BUTTON_SIDE_MARGINE, (self.bounds.size.height + 5.0 - INFO_BUTTON_BAR_HEIGHT) / 2 -  (INFO_VIEW_APP_LOGO_BUTTON_HEIGHT + INFO_VIEW_LINK_BUTTON_HEIGHT) / 2, INFO_VIEW_APP_LOGO_BUTTON_WIDTH, INFO_VIEW_APP_LOGO_BUTTON_HEIGHT);
    appLogoButton_.hidden = NO;
    [appLogoButton_ addTarget:self action:@selector(appLogoButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:appLogoButton_];
    
    teamLogoButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [teamLogoButton_ setImage:teamLogoImage forState:UIControlStateNormal];
    [teamLogoButton_ setImage:teamLogoImage forState:UIControlStateSelected];
    [teamLogoButton_ setImage:teamLogoImage forState:UIControlStateHighlighted];
    teamLogoButton_.frame = CGRectMake(self.bounds.origin.x + INFO_VIEW_TEAM_LOGO_BUTTON_SIDE_MARGINE, (self.bounds.size.height - INFO_BUTTON_BAR_HEIGHT) / 2 -  (INFO_VIEW_TEAM_LOGO_BUTTON_HEIGHT + INFO_VIEW_LINK_BUTTON_HEIGHT) / 2, INFO_VIEW_TEAM_LOGO_BUTTON_WIDTH, INFO_VIEW_TEAM_LOGO_BUTTON_HEIGHT);
    [teamLogoButton_ addTarget:self action:@selector(teamLogoButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    teamLogoButton_.hidden = YES;
    teamLogoButton_.alpha = 0.0;
    [self addSubview:teamLogoButton_];

    limeWorksLinkButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [limeWorksLinkButton_ setImage:limeWorksLinkImage forState:UIControlStateNormal];
    [limeWorksLinkButton_ setImage:limeWorksLinkImage forState:UIControlStateSelected];
    [limeWorksLinkButton_ setImage:limeWorksLinkImage forState:UIControlStateHighlighted];
    limeWorksLinkButton_.frame = CGRectMake(self.bounds.origin.x + INFO_VIEW_LINK_BUTTON_SIDE_MARGINE, appLogoButton_.frame.origin.y + appLogoButton_.bounds.size.height, INFO_VIEW_LINK_BUTTON_WIDTH, INFO_VIEW_LINK_BUTTON_HEIGHT);
    [limeWorksLinkButton_ addTarget:self action:@selector(linkButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:limeWorksLinkButton_];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, limeWorksLinkButton_.frame.origin.y + limeWorksLinkButton_.frame.size.height, self.bounds.size.width, 20.0)];
    versionLabel.text = [[NSString alloc] initWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    versionLabel.textColor = [[UIColor alloc] initWithRed:(114.0 / 255.0) green:(210.0 / 255.0) blue:(216.0 / 255.0) alpha:1.0];
    versionLabel.font = [UIFont systemFontOfSize:13.0];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:versionLabel];
    
    UILabel *creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, versionLabel.frame.origin.y + versionLabel.frame.size.height  + INFO_VIEW_CREDIT_TOP_MARGINE, self.bounds.size.width, 20.0)];
    creditLabel.text = @"idstorm cubixlab♥lora parkdm78";
    creditLabel.textColor = [[UIColor alloc] initWithRed:(153.0 / 255.0) green:(153.0 / 255.0) blue:(153.0 / 255.0) alpha:1.0];
    creditLabel.font = [UIFont systemFontOfSize:11.0];
    creditLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:creditLabel];
}


/* 앱 로고 버튼이 터치되다. */
-(void)appLogoButtonTouched:(id)sender
{
    if (appLogoButton_.hidden == YES)
        return;
    appLogoButton_.hidden = YES;
    appLogoButton_.alpha = 0.0;
    teamLogoButton_.hidden = NO;
    teamLogoButton_.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        teamLogoButton_.alpha = 1.0;
    }];
}


/* 팀 로고 버튼이 터치되다. */
-(void)teamLogoButtonTouched:(id)sender
{
    if (teamLogoButton_.hidden == YES)
        return;
    teamLogoButton_.hidden = YES;
    teamLogoButton_.alpha = 0.0;
    appLogoButton_.hidden = NO;
    appLogoButton_.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        appLogoButton_.alpha = 1.0;
    }];
}


/* 링크 버튼이 터치되다. */
-(void)linkButtonTouched:(id)sender
{
    [rootViewController_.webViewController_.webNavigationBar_ selectListButton:NO];
    [rootViewController_.webViewController_ requestWithURL:[NSURL URLWithString:@"http://limeworks.co.kr"]];
    [rootViewController_ showWebView];
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
