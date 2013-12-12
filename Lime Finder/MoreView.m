//
//  MoreView.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 8..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "MoreView.h"
#import "RootViewController.h"
#import "KakaoLinkCenter.h"
#import "MypeopleManager.h"


@implementation MoreView

@synthesize cellListArray_;
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
    }
    return self;
}


/* MoreViewCell 들을 초기화 한다. */
- (void)initMoreViewCellList
{
    cellListArray_ = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MoreViewCellList" ofType:@"plist"]];
    
    // 서브뷰를 제거한다.
    for (UIView* view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    // cellListArray에서 사용 가능한 아이콘만 추려낸다.
    NSMutableArray *canOpenItems = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in cellListArray_)
    {
        SEL selector = NSSelectorFromString([dictionary objectForKey:@"ValidationSelector"]);
#       pragma clang diagnostic push
#       pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        BOOL isOpen = (BOOL)[self performSelector:selector];
#       pragma clang diagnostic pop
        if (isOpen)
        {
            [canOpenItems addObject:dictionary];
            // NSLog(@"%@ YES", [dictionary objectForKey:@"ValidationSelector"]);
        }
    }
    
    
    CGPoint iconOrigin;
    iconOrigin.x = 0.5;
    iconOrigin.y = 0;
    
    // rows 를 구한다. 
    int rows = (canOpenItems.count / MORE_VIEW_CELL_COLS) + ((canOpenItems.count % MORE_VIEW_CELL_COLS > 0)? 1 : 0);
    
    // frame의 높이를 구한다.
    CGFloat height = rows * MORE_VIEW_CELL_HEIGHT + (rows - 1) * 1.0 + 5.0;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, height);
    
    
    
    for (NSInteger i = 0; i < canOpenItems.count; i ++)
    {
        NSDictionary *icon = [canOpenItems objectAtIndex:i];
        NSArray *offImageArray = [[icon objectForKey:@"IconOff"] componentsSeparatedByString:@"."];
        NSArray *onImageArray = [[icon objectForKey:@"IconOn"] componentsSeparatedByString:@"."];
        NSArray *overImageArray = [[icon objectForKey:@"IconOver"] componentsSeparatedByString:@"."];
        UIImage  *buttonOffImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[offImageArray objectAtIndex:0] ofType:[offImageArray objectAtIndex:1]]];
        UIImage  *buttonOnImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[onImageArray objectAtIndex:0] ofType:[onImageArray objectAtIndex:1]]];
        UIImage  *buttonOverImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[overImageArray objectAtIndex:0] ofType:[overImageArray objectAtIndex:1]]];
        
        if (i > 0 && (i % MORE_VIEW_CELL_COLS) == 0)
        {
            iconOrigin.x = 0.5;
            iconOrigin.y = iconOrigin.y + MORE_VIEW_CELL_HEIGHT + 1.0;
        }
        
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        iconButton.frame = CGRectMake(iconOrigin.x, iconOrigin.y, MORE_VIEW_CELL_WIDTH , MORE_VIEW_CELL_HEIGHT);
        [iconButton setImage:buttonOffImage forState:UIControlStateNormal];
        [iconButton setImage:buttonOverImage forState:UIControlStateHighlighted];
        [iconButton setImage:buttonOnImage forState:UIControlStateSelected];
        
        SEL selector = NSSelectorFromString([icon objectForKey:@"ActionSelector"]);
        
        [iconButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:iconButton];
        
        if ((i % MORE_VIEW_CELL_COLS - 1) == 0)
            iconOrigin.x = iconOrigin.x + MORE_VIEW_CELL_WIDTH;
        else
            iconOrigin.x = iconOrigin.x + MORE_VIEW_CELL_WIDTH + 1.0;
    }
    [self setNeedsDisplay];
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
    CGFloat lineColor[] = {(228.0 / 255.0), (228.0 / 255.0), (228.0 / 255.0), 1.0};
    
    CGFloat lineX = 0.5;
    CGFloat lineY = 0.0;
    CGContextSetLineWidth(barContext, 1.0);
    CGContextSetStrokeColorWithColor(barContext, CGColorCreate(colorSpace, lineColor));
    for (int i = 0; i < MORE_VIEW_CELL_COLS; i ++)
    {
        lineX = lineX + MORE_VIEW_CELL_WIDTH;
        CGContextMoveToPoint(barContext, lineX, self.bounds.origin.y);
        CGContextAddLineToPoint(barContext, lineX, self.bounds.size.height);
        CGContextStrokePath(barContext);
        lineX = lineX + 1.0;
    }
    
    // 라인갯수를 구한다.
    int lineCount = (self.bounds.size.height / MORE_VIEW_CELL_HEIGHT) - 1;
    
    for (int i = 0; i < lineCount;i ++)
    {
        lineY = lineY + MORE_VIEW_CELL_HEIGHT + 1.0;
        CGContextMoveToPoint(barContext, self.bounds.origin.x, lineY);
        CGContextAddLineToPoint(barContext, self.bounds.size.width, lineY);
        CGContextStrokePath(barContext);
    }
    
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(barContext);
}


- (void)actionSafari:(id)sender
{
    //UIButton *button = sender;
    //button.selected = !button.selected;
   
    NSString *urlString = rootViewController_.webViewController_.webURLBar_.urlTextField_.text;
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)actionEmail:(id)sender
{
    //UIButton *button = sender;
    //button.selected = !button.selected;
    
    NSString *urlString = rootViewController_.webViewController_.webURLBar_.urlTextField_.text;
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"URL Link !"];
    [controller setMessageBody:urlString isHTML:YES];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [rootViewController_ presentViewController:controller animated:YES completion:nil];
}

- (void)actionFacebook:(id)sender
{
    //UIButton *button = sender;
    //button.selected = !button.selected;
    
    NSString *urlString = rootViewController_.webViewController_.webURLBar_.urlTextField_.text;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *snsSheet = [SLComposeViewController
                                             composeViewControllerForServiceType:SLServiceTypeFacebook];
        [snsSheet setInitialText:urlString];
        [rootViewController_ presentViewController:snsSheet animated:YES completion:nil];
    }
}

- (void)actionTwitter:(id)sender
{
    //UIButton *button = sender;
    //button.selected = !button.selected;
    
    NSString *urlString = rootViewController_.webViewController_.webURLBar_.urlTextField_.text;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *snsSheet = [SLComposeViewController
                                             composeViewControllerForServiceType:SLServiceTypeTwitter];
        [snsSheet setInitialText:urlString];
        [rootViewController_ presentViewController:snsSheet animated:YES completion:nil];

    }
}

- (void)actionKaKaoTalk:(id)sender
{
    //UIButton *button = sender;
    //button.selected = !button.selected;
    
    if (![KakaoLinkCenter canOpenKakaoLink])
    {
        return;
    }
    
    NSString *urlString = rootViewController_.webViewController_.webURLBar_.urlTextField_.text;
    NSMutableArray *metaInfoArray = [NSMutableArray array];
    
    NSDictionary *metaInfoAndroid = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"android", @"os",
                                     @"phone", @"devicetype",
                                     @"market://details?id=com.kakao.talk", @"installurl",
                                     @"example://example", @"executeurl",
                                     nil];

    NSDictionary *metaInfoIOS = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios", @"os",
                                 @"phone", @"devicetype",
                                 @"http://itunes.apple.com/app/id362057947?mt=8", @"installurl",
                                 @"example://example", @"executeurl",
                                 nil];
    
    [metaInfoArray addObject:metaInfoAndroid];
    [metaInfoArray addObject:metaInfoIOS];
    
    /*
    [KakaoLinkCenter openKakaoAppLinkWithMessage:urlString
                                             URL:@"http://link.kakao.com/?test-ios-app"
                                     appBundleID:[[NSBundle mainBundle] bundleIdentifier]
                                      appVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                                         appName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                                   metaInfoArray:metaInfoArray];
    */
    
    [KakaoLinkCenter openKakaoLinkWithURL:urlString
                               appVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                              appBundleID:[[NSBundle mainBundle] bundleIdentifier]
                                  appName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                                  message:@""];
}

- (void)actionMyPeople:(id)sender
{
    //UIButton *button = sender;
    //button.selected = !button.selected;
    
    MypeopleManager *mypeopleManager = [MypeopleManager sharedInstance];
    if (![mypeopleManager canOpenMypeopleURL])
        return;
    NSString *urlString = rootViewController_.webViewController_.webURLBar_.urlTextField_.text;
    [mypeopleManager sendTextMessageWithUrl:urlString message:@"링크 보냄"];
    
}

- (void)actionMessage:(id)sender
{
    
    NSString *urlString = rootViewController_.webViewController_.webURLBar_.urlTextField_.text;
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    controller.messageComposeDelegate = self;
    [controller setBody:urlString];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [rootViewController_ presentViewController:controller animated:YES completion:nil];
}

- (void)actionKaKaoStory:(id)sender
{
	if (![KakaoLinkCenter canOpenStoryLink]) {
		return;
	}
    
	NSString *urlString = rootViewController_.webViewController_.webURLBar_.urlTextField_.text;
    
	[KakaoLinkCenter openStoryLinkWithPost:urlString
							   appBundleID:[[NSBundle mainBundle] bundleIdentifier]
								appVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
								   appName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
								   urlInfo:nil];
}


- (BOOL)canOpenSafari
{
    return YES;
}


- (BOOL)canOpenEmail
{
    return YES;
}


- (BOOL)canOpenFacebook
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
}


- (BOOL)canOpenTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}


- (BOOL)canOpenKaKaoTalk
{
    return [KakaoLinkCenter canOpenKakaoLink];
}


- (BOOL)canOpenMyPeople
{
    MypeopleManager *mypeopleManager = [MypeopleManager sharedInstance];
    return [mypeopleManager canOpenMypeopleURL];
}


- (BOOL)canOpenMessage
{
    return YES;
}


- (BOOL)canOpenKaKaoStory
{
    return [KakaoLinkCenter canOpenStoryLink];
}


#pragma -
#pragma mark - MFMailComposeViewControllerDelegate Method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
     [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma -
#pragma mark - MFMailComposeViewControllerDelegate Method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
