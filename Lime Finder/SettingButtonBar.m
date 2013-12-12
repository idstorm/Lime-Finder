//
//  SettingButtonBar.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 23..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "SettingButtonBar.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SettingButtonBar
@synthesize settingButton_;
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
        
        /*
        CGFloat shadowColor[] = {70.0 / 255.0, 198.0 / 255.0, 207.0 / 255.0, 1.f};
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOffset = CGSizeMake(0.0, -1.0);
        self.layer.shadowRadius = 1.0;
        self.layer.shadowColor = CGColorCreate( CGColorSpaceCreateDeviceRGB(), shadowColor);
        self.layer.shadowOpacity = 1.0;
         */

        [self initSubViews];
    }
    return self;
}


- (void)initSubViews
{
    UIImage  *settingButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_btn_set02" ofType:@"png"]];
    settingButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton_ setImage:settingButtonImage forState:UIControlStateNormal];
    settingButton_.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, settingButtonImage.size.width / 2.0, settingButtonImage.size.height / 2.0);
    [settingButton_ addTarget:self action:@selector(settingButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:settingButton_];
}


- (void)settingButtonTouched:(id)sender
{
    [rootViewController_.mainViewController_ showSystemBar];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [rootViewController_.mainViewController_ returnTransformViews];
    [rootViewController_ hideWebView];
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
