//
//  ListCellImageViewDummy.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 24..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "ListCellImageViewDummy.h"

@implementation ListCellImageViewDummy

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Draw Line
    CGFloat lineColor[] = {(200.0 / 255.0), (200.0 / 255.0), (200.0 / 255.0), 1.0};
    CGColorRef color = CGColorCreate(colorSpace, lineColor);
    CGContextSetShouldAntialias(context, NO);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextMoveToPoint(context, self.bounds.origin.x, self.bounds.origin.y);
    CGContextAddLineToPoint(context, self.bounds.origin.x, self.bounds.size.height);
    CGContextMoveToPoint(context, self.bounds.size.width, self.bounds.origin.y);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(context);
    
    CGColorRelease(color);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
}
@end
