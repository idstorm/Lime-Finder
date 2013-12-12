//
//  InfoButtonBar.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 28..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "InfoButtonBar.h"
#import "RootViewController.h"

@implementation InfoButtonBar
@synthesize infoButton_;
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
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews
{
    UIImage  *infoButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_btn_set_close" ofType:@"png"]];
    UIImage  *infoButtonImageOn = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_btn_info_over" ofType:@"png"]];
    UIImage  *infoButtonImageOver = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_btn_info_over" ofType:@"png"]];
    infoButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton_ setImage:infoButtonImage forState:UIControlStateNormal];
    [infoButton_ setImage:infoButtonImageOver forState:UIControlStateHighlighted];
    [infoButton_ setImage:infoButtonImageOn forState:UIControlStateSelected];
    infoButton_.frame = CGRectMake(self.bounds.size.width / 2.0 - infoButtonImage.size.width / 4.0, self.bounds.origin.y, infoButtonImage.size.width / 2.0, infoButtonImage.size.height / 2.0);
    [infoButton_ addTarget:self action:@selector(infoButtonTouched:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:infoButton_];
}


- (void)infoButtonTouched:(id)sender
{
    [rootViewController_.mainViewController_ hideInfoView];
}

/*
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 [rootViewController_.mainViewController_ returnTransformViews];
 [rootViewController_ hideWebView];
 }
 */

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{   CGContextRef barContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(barContext);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Draw Line
    CGFloat lineColor[] = {(114.0 / 255.0), (210.0 / 255.0), (216.0 / 255.0), 1.0};
    CGColorRef color = CGColorCreate(colorSpace, lineColor);
    CGContextSetLineWidth(barContext, 1.0);
    CGContextSetStrokeColorWithColor(barContext, color);
    CGContextMoveToPoint(barContext, infoButton_.frame.origin.x - 1.0, self.bounds.origin.y);
    CGContextAddLineToPoint(barContext, infoButton_.frame.origin.x - 1.0, self.bounds.size.height);
    CGContextMoveToPoint(barContext, infoButton_.frame.origin.x + infoButton_.bounds.size.width + 1.0, self.bounds.origin.y);
    CGContextAddLineToPoint(barContext, infoButton_.frame.origin.x + infoButton_.bounds.size.width + 1.0, self.bounds.size.height);
    CGContextStrokePath(barContext);
    CGColorRelease(color);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(barContext);// Drawing code
}

@end
