//
//  SearchBarTextField.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 23..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "SearchBarTextField.h"

@implementation SearchBarTextField

@synthesize completed_;
@synthesize urlTextFieldBackgroundImage_;
@synthesize showProgress_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        urlTextFieldBackgroundImage_ = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_fieldset_bg" ofType:@"png"]];
        showProgress_ = NO;
    }
    return self;
}


// 진행상태를 설정하고, 컨텍스트를 갱신한다.
- (void)setProgress:(CGFloat)complete
{
    completed_ = complete;
    [self setNeedsDisplay];
}


- (void)drawPlaceholderInRect:(CGRect)rect
{
    [[UIColor whiteColor] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:18]];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Bar ContextRef
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat progressColor[] = {(48.0 / 255.0), (217.0 / 255.0), (228.0 / 255.0), 0.8};
    CGFloat progressWidth = (self.bounds.size.width - 2.0) * completed_;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    [urlTextFieldBackgroundImage_ drawInRect:self.bounds];
    
    CGContextSetLineWidth(context, 2.0);
    CGColorRef color = CGColorCreate(colorSpace, progressColor);
    CGContextSetFillColorWithColor(context, color);
    
    if (showProgress_)
    {
        CGContextAddRect(context, CGRectMake(self.bounds.origin.x + 1.0, self.bounds.origin.y + 1.0, progressWidth, self.bounds.size.height - 2.0));
        CGContextDrawPath(context, kCGPathFill);
    }
    
    CGColorRelease(color);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
}


@end
