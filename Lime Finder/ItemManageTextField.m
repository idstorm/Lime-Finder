//
//  ItemManageTextField.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 29..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "ItemManageTextField.h"

@implementation ItemManageTextField
@synthesize urlTextFieldBackgroundImage_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        urlTextFieldBackgroundImage_ = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_fieldset_bg" ofType:@"png"]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Bar ContextRef
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [urlTextFieldBackgroundImage_ drawInRect:self.bounds];
    CGContextRestoreGState(context);
}
@end
