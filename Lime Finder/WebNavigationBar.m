//
//  WebNavigationBar.m
//  Lime Finder
//
//  Created by idstorm on 13. 4. 27..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "WebNavigationBar.h"
#import "RootViewController.h"


@implementation WebNavigationBar

@synthesize webView_;
@synthesize rootViewController_;
@synthesize barPortraitSideMargin_;
@synthesize barLandscapeSideMargin_;
@synthesize iconPortraitSize_;
@synthesize iconLandscapeSize_;


@synthesize iconCount_;
@synthesize listButton_;


@synthesize  barPropertyList_;

- (id)initWithFrame:(CGRect)frame webView:(WebView *)webView
{
    self = [super initWithFrame:frame];
    if (self)
    {
        webView_ = webView;
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        [self initIconButtonList];
    }
    return self;
}

- (void)initIconButtonList
{
    barPropertyList_ = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WebNavigationBar" ofType:@"plist"]];
    barPortraitSideMargin_.width = (CGFloat)[[barPropertyList_ objectForKey:@"BarPortraitSideMarginWidth"] floatValue];
    barPortraitSideMargin_.height = (CGFloat)[[barPropertyList_ objectForKey:@"BarPortraitSideMarginHeight"] floatValue];
    iconPortraitSize_.width = (CGFloat)[[barPropertyList_ objectForKey:@"IconPortraitSizeWidth"] floatValue];
    iconPortraitSize_.height = (CGFloat)[[barPropertyList_ objectForKey:@"IconPortraitSizeHeight"] floatValue];
    iconLandscapeSize_.width = (CGFloat)[[barPropertyList_ objectForKey:@"IconLandscapeSizeWidth"] floatValue];
    iconLandscapeSize_.height = (CGFloat)[[barPropertyList_ objectForKey:@"IconLandscapeSizeHeight"] floatValue];
    
    NSArray *iconList = [barPropertyList_ objectForKey:@"List"];
    /*
    barPortraitSize_.width = self.bounds.size.width;
    barPortraitSize_.height = self.bounds.size.height;
    barLandscapeSize_.width = self.bounds.size.width;
    barLandscapeSize_.height = self.bounds.size.height;
    */
    
    // NSInteger iconListWidth = self.bounds.size.width - barLandscapeSideMargin_.width * 2;
    
    CGPoint iconOrigin;
    iconOrigin.x = 0;
    iconOrigin.y = 0;
    
    for (NSInteger i = 0; i < iconList.count; i ++)
    {
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *icon = [iconList objectAtIndex:i];
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

        [iconButton addTarget:self action:selector forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:iconButton];
        if (i >= 0 && i < iconList.count -1)
            iconOrigin.x = iconOrigin.x + buttonOffImage.size.width / 2.0 + 1.0;
        else
            iconOrigin.x = iconOrigin.x + buttonOffImage.size.width / 2.0;
    }
    listButton_ = [self.subviews objectAtIndex:0];
}


/* 레이아웃이 변경되었을 경우 호출 */
- (void)layoutSubviews
{
    [super layoutSubviews];
}


/* 리스트 아이콘 터치 */
- (void)actionList:(id)sender
{
    UIViewController *webViewController = rootViewController_.webViewController_;
    MainViewController *mainViewController = rootViewController_.mainViewController_;
    CGFloat moveWidth = webViewController.view.bounds.size.width - WEB_NAVIGATION_BAR_ICON_WIDTH;
    
    // 하단바 숨겨짐을 해제한다.
    [rootViewController_.webViewController_ removeHideTimer];
    
    
    // MoreView를 숨긴다. 
     [rootViewController_.webViewController_ hideMoreView];;
    UIButton *iconButton = [self.subviews objectAtIndex:4];
    iconButton.selected = NO;
    
    // 리스트 아이콘을 선택상태로 한다.
    listButton_.selected = !listButton_.selected;
    
    // 리스트 아이콘이 선택상태이거나, 메인 뷰 컨트롤러의 상태의 가로 크기가 변경전일 경우  크기를 수정한다. //
    if (listButton_.selected || mainViewController.isTransformed_ == NO)
         [mainViewController transformViews:CGRectMake(webViewController.view.frame.origin.x, webViewController.view.frame.origin.y, moveWidth, webViewController.view.bounds.size.height)];
    
    // 리스트 버튼이 선택되어진 경우, Lock Screen을 활성화 한다. //
    if (listButton_.selected)
        rootViewController_.webViewController_.lockScreen_.hidden = NO;
    else
        rootViewController_.webViewController_.lockScreen_.hidden = YES;
    
    
    // 웹 뷰 컨트롤러 애니메이션 //
    [UIView animateWithDuration:0.15f animations:^{
        /* 애니메이션 블록 시작 */
        if (listButton_.selected)
        {
            [webViewController.view setFrame:CGRectMake(webViewController.view.frame.origin.x - 5.0, webViewController.view.frame.origin.y, webViewController.view.bounds.size.width, webViewController.view.bounds.size.height)];
        }
        else
        {
            [webViewController.view setFrame:CGRectMake(webViewController.view.frame.origin.x + 5.0, webViewController.view.frame.origin.y, webViewController.view.bounds.size.width, webViewController.view.bounds.size.height)];
        }
        /* 애니메이션 블록 끝 */
    } completion:^(BOOL finished) {
        
        // 웹 뷰 컨트롤러 애니메이션 //
        [UIView animateWithDuration:0.15f animations:^{
            /* 애니메이션 블록 시작 */
            if (listButton_.selected)
            {
                [webViewController.view setFrame:CGRectMake(webViewController.view.frame.origin.x + moveWidth + 10.0, webViewController.view.frame.origin.y, webViewController.view.bounds.size.width, webViewController.view.bounds.size.height)];
            }
            else
            {
                [webViewController.view setFrame:CGRectMake(rootViewController_.view.frame.origin.x, webViewController.view.frame.origin.y, webViewController.view.bounds.size.width, webViewController.view.bounds.size.height)];
            }
            /* 애니메이션 블록 끝 */
        } completion:^(BOOL finished) {
            
            // 웹 뷰 컨트롤러 애니메이션 //
            [UIView animateWithDuration:0.15f animations:^{
                /* 애니메이션 블록 시작 */
                if (listButton_.selected)
                {
                    [webViewController.view setFrame:CGRectMake(webViewController.view.frame.origin.x - 5.0, webViewController.view.frame.origin.y, webViewController.view.bounds.size.width, webViewController.view.bounds.size.height)];
                    [rootViewController_.webViewController_.webView_ stopLoading];
                }
                else
                {
                    //[webViewController.view setFrame:CGRectMake(rootViewController_.view.frame.origin.x, webViewController.view.frame.origin.y, webViewController.view.bounds.size.width, webViewController.view.bounds.size.height)];
                }
                /* 애니메이션 블록 끝 */
            } completion:^(BOOL finished)
            {
            }];
           }];
    }];
    [rootViewController_.mainViewController_.listTableViewController_.listTableView_ reloadData];
}


/* 리스트 아이콘 버튼 선택 */
- (void)selectListButton:(BOOL)select
{
    UIButton *iconButton = [self.subviews objectAtIndex:0];
    iconButton.selected = select;
}


/* 뒤로가기 아이콘 터치 */
- (void)actionBackward:(id)sender
{
    [webView_ goBack];
}


/* 앞으로가기 아이콘 터치 */
- (void)actionForward:(id)sender
{
    [webView_ goForward];
}


/* 홈 아이콘 터치 */
- (void)actionHome:(id)sender
{
    [rootViewController_ hideWebView];
}


/* 즐겨찾기 추가 */
- (void)actionAddList:(id)sender
{
    rootViewController_.itemManageViewController_.itemManageState_ = ITEM_MANAGE_STATE_ADD;
    NSMutableDictionary* mutableDictionary = rootViewController_.itemManageViewController_.itemMutableDictionary_;
    [mutableDictionary setObject:[[webView_.request mainDocumentURL] absoluteString]forKey:@"HostURL"];
    [mutableDictionary setObject:[webView_ stringByEvaluatingJavaScriptFromString:@"document.title"] forKey:@"Title"];
    [rootViewController_ showItemManageView];
}


/* 더보기 아이콘 터치 */
- (void)actionMore:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.selected)
    {
        [rootViewController_.webViewController_ hideMoreView];
        button.selected = NO;
    }
    else
    {
        [rootViewController_.webViewController_ showMoreView];
        button.selected = YES;
    }
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Bar ContextRef
    CGContextRef barContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(barContext);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Draw Line
    CGFloat lineColor[] = {(114.0 / 255.0), (210.0 / 255.0), (216.0 / 255.0), 1.0};

    CGFloat lineX = 0.5;
    
    NSArray *iconList = [barPropertyList_ objectForKey:@"List"];
    
    CGContextSetLineWidth(barContext, 1.0);
    CGColorRef color = CGColorCreate(colorSpace, lineColor);
    CGContextSetStrokeColorWithColor(barContext, color);
    for (int i = 0; i < iconList.count; i ++)
    {
        lineX = lineX + WEB_NAVIGATION_BAR_ICON_WIDTH;
        CGContextMoveToPoint(barContext, lineX, self.bounds.origin.y);
        CGContextAddLineToPoint(barContext, lineX, self.bounds.size.height);
        CGContextStrokePath(barContext);
        lineX = lineX + 1.0;
    }
    CGColorRelease(color);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(barContext);
}

@end
