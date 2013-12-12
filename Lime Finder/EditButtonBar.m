//
//  EditButtonBar.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 26..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "EditButtonBar.h"
#import "RootViewController.h"

@implementation EditButtonBar
@synthesize editButton_;
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
    UIImage  *editButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_btn_edit_apply_01" ofType:@"png"]];
    UIImage  *editButtonImageOver = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_btn_edit_apply_01_over" ofType:@"png"]];
    editButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton_ setImage:editButtonImage forState:UIControlStateNormal];
    [editButton_ setImage:editButtonImageOver forState:UIControlStateHighlighted];
    editButton_.frame = CGRectMake(self.bounds.size.width / 2.0 - editButtonImage.size.width / 4.0, self.bounds.origin.y, editButtonImage.size.width / 2.0, editButtonImage.size.height / 2.0);
    [editButton_ addTarget:self action:@selector(editButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editButton_];
}


- (void)editButtonTouched:(id)sender
{
    [rootViewController_.mainViewController_ hideEditButtonBar];
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
    CGContextMoveToPoint(barContext, editButton_.frame.origin.x - 1.0, self.bounds.origin.y);
    CGContextAddLineToPoint(barContext, editButton_.frame.origin.x - 1.0, self.bounds.size.height);
    CGContextMoveToPoint(barContext, editButton_.frame.origin.x + editButton_.bounds.size.width + 1.0, self.bounds.origin.y);
    CGContextAddLineToPoint(barContext, editButton_.frame.origin.x + editButton_.bounds.size.width + 1.0, self.bounds.size.height);
    CGContextStrokePath(barContext);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(barContext);// Drawing code
    CGColorRelease(color);
}


@end
