//
//  SystemBar.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 10..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "SystemBar.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SystemBar
@synthesize rootViewController_;
@synthesize listButton_;
@synthesize iconList_;

/*
@synthesize menuButton_;
@synthesize editButton_;
@synthesize infoButton_;
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        
        // 아이콘 버튼을 초기화 한다. 
        [self initIconButtonList];
    }
    return self;
}


/* 아이콘 버튼을 초기화 한다. */
- (void)initIconButtonList
{
    iconList_ = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SystemBar" ofType:@"plist"]];    

    CGPoint iconOrigin;
    iconOrigin.x = 0;
    iconOrigin.y = 0;
    
    for (NSInteger i = 0; i < iconList_.count; i ++)
    {
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *icon = [iconList_ objectAtIndex:i];
        NSArray *offImageArray = [[icon objectForKey:@"IconOff"] componentsSeparatedByString:@"."];
        NSArray *onImageArray = [[icon objectForKey:@"IconOn"] componentsSeparatedByString:@"."];
        NSArray *overImageArray = [[icon objectForKey:@"IconOver"] componentsSeparatedByString:@"."];
        UIImage  *buttonOffImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[offImageArray objectAtIndex:0] ofType:[offImageArray objectAtIndex:1]]];
        UIImage  *buttonOnImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[onImageArray objectAtIndex:0] ofType:[onImageArray objectAtIndex:1]]];
        UIImage  *buttonOverImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[onImageArray objectAtIndex:0] ofType:[overImageArray objectAtIndex:1]]];
        
        iconButton.frame = CGRectMake(iconOrigin.x, iconOrigin.y, buttonOffImage.size.width / 2.0 , buttonOffImage.size.height / 2.0);
        
        [iconButton setImage:buttonOffImage forState:UIControlStateNormal];
        [iconButton setImage:buttonOverImage forState:UIControlStateHighlighted];
        [iconButton setImage:buttonOnImage forState:UIControlStateSelected];
        
        SEL selector = NSSelectorFromString([icon objectForKey:@"Selector"]);
                
        [iconButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:iconButton];
        if (i >= 0 && i < iconList_.count -1)
            iconOrigin.x = iconOrigin.x + buttonOffImage.size.width / 2.0 + 1.0;
        else
            iconOrigin.x = iconOrigin.x + buttonOffImage.size.width / 2.0;
    }
    listButton_ = [self.subviews objectAtIndex:0];
}


/* 시스템바 항목을 초기화 한다. */
// 열린 항목을 모두 닫는다.
- (void)resetSystemBar
{
    [rootViewController_.mainViewController_ hideEditButtonBar];
    [rootViewController_.mainViewController_ hideInfoViewNoAnimation];
    
    for (NSInteger i = 0; i < iconList_.count; i ++)
    {
        if (i == 0)
            continue;
        NSDictionary *icon = [iconList_ objectAtIndex:i];
        SEL selector = NSSelectorFromString([icon objectForKey:@"Selector"]);
        UIButton *iconButton = [self.subviews objectAtIndex:i];
        if (iconButton.selected)
        {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selector withObject:iconButton];
            #pragma clang diagnostic pop
        }
    }
    if (rootViewController_.mainViewController_.systemBar_.hidden == NO)
        rootViewController_.mainViewController_.systemBar_.hidden = YES;
}


- (void)actionSet:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    [rootViewController_.mainViewController_ hideSystemBar];
}

- (void)actionEdit:(id)sender
{
    if (rootViewController_.listManager_.list_.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"즐겨찾기 리스트 없음!" message:@"즐겨찾기 리스트가 존재하지 않습니다.\n즐겨찾기 리스트를 등록하거나 초기화시켜 주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return ;
    }
    
    UIButton *button = sender;
    button.selected = !button.selected;
    
    if(button.selected)
    {
        UIButton *infoButton = [self.subviews objectAtIndex:4];
        if (infoButton.selected)
            [self actionInfo:infoButton];
        [rootViewController_.mainViewController_ showEditButtonBar];
        [rootViewController_.mainViewController_ setEditMode:self];
    }
    else
    {
        // [rootViewController_.mainViewController_ endEditMode:self];
    }
}

- (void)actionAdd:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    if(button.selected)
    {
        // [rootViewController_ showItemManageView];
    }
    else
    {
        
    }
}


/* 리셋 버튼 액션 */
// 리스트를 처음 설치 상태로 초기화 한다. 
- (void)actionReset:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    
    if (button.selected)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"리스트 초기화" message:@"즐겨찾기 리스트를 처음 설치상태로 \n초기화 하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil
        ];
        [alertView show];
    }
}


- (void)actionInfo:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    if(button.selected)
    {
        [rootViewController_.mainViewController_ showInfoView];
    }
    else
    {
        // [rootViewController_.mainViewController_ hideInfoView];
    }
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    CGContextRef barContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(barContext);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Draw Line
    CGFloat lineColor[] = {(114.0 / 255.0), (210.0 / 255.0), (216.0 / 255.0), 1.0};
    
    CGFloat lineX = 0.5;
    
    CGColorRef color = CGColorCreate(colorSpace, lineColor);
    for (int i = 0; i < iconList_.count; i ++)
    {
        lineX = lineX + WEB_NAVIGATION_BAR_ICON_WIDTH;
        CGContextSetLineWidth(barContext, 1.0);
        CGContextSetStrokeColorWithColor(barContext, color);
        CGContextMoveToPoint(barContext, lineX, self.bounds.origin.y);
        CGContextAddLineToPoint(barContext, lineX, self.bounds.size.height);
        CGContextStrokePath(barContext);
        lineX = lineX + 1.0;
    }
    CGColorRelease(color);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(barContext);
}


#pragma -
#pragma mark - UIAlertViewDelegate Protocol
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [rootViewController_.listManager_ resetDefaultArray];
        [rootViewController_.mainViewController_.listTableViewController_.listTableView_ reloadData];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIButton *resetButton = [self.subviews objectAtIndex:2];
    if (resetButton.selected)
    {
        resetButton.selected = NO;
    }
}


@end
