//
//  LMLabel.m
//  Lime Finder
//
//  Created by idstorm on 13. 6. 8..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "LMLabel.h"
#import <CoreText/CoreText.h>

@implementation LMLabel

@synthesize attributedString_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        attributedString_ = [[NSMutableAttributedString alloc] init];
        // self.font = [UIFont systemFontOfSize:20.0];
        // self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(self.text)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        //CGContextTranslateCTM(ctx, 0, self.bounds.size.height / 2.0 - self.font.pointSize / 2.0);
        CGContextTranslateCTM(ctx, 0, self.bounds.size.height / 2.0 - self.font.lineHeight / 2.0);
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
        CGContextConcatCTM(ctx, transform);
      
        if (self.shadowColor)
        {
            CGContextSetShadowWithColor(ctx, self.shadowOffset, 0.0, self.shadowColor.CGColor);
        }
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString_);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, self.bounds);
        
        CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,0), path, NULL);
        
        CTFrameDraw(textFrame, ctx);
        CGContextRestoreGState(ctx);
        
        CGPathRelease(path);
        CFRelease(framesetter);
        CFRelease(textFrame);
    }
    else
    {
        [super drawTextInRect:rect];
    }
}

- (void)setText:(NSString *)text
{
    [[attributedString_ mutableString] setString:text];
    [super setText:text];
}

- (void)setTextColor:(UIColor *)textColor
{
    if (attributedString_)
    {
        [attributedString_ removeAttribute:(NSString *)kCTForegroundColorAttributeName range:NSMakeRange(0, [attributedString_ length])];
        [attributedString_ addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)textColor.CGColor range:NSMakeRange(0, [attributedString_ length])];
    }
    [super setTextColor:textColor];
}

- (void)setTextColor:(UIColor *)textColor range:(NSRange)aRange
{
    if (attributedString_)
    {
        [attributedString_ removeAttribute:(NSString *)kCTForegroundColorAttributeName range:aRange];
        [attributedString_ addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)textColor.CGColor range:aRange];
    }
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName , font.pointSize, NULL);
    if (aFont && attributedString_)
    {
        [attributedString_ removeAttribute:(NSString *)kCTFontAttributeName range:NSMakeRange(0, [attributedString_ length])];
        [attributedString_  addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)aFont range:NSMakeRange(0, [attributedString_ length])];
        CFRelease(aFont);
    }
    
    [super setFont:font];
}

@end
