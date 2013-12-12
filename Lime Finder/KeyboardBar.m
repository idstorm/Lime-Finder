//
//  KeyboardBar.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 8..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "KeyboardBar.h"

@implementation KeyboardBar
@synthesize pullDownButton_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubViews];
    }
    return self;
}


/* 서브뷰를 추가한다. */
- (void)initSubViews
{
    UIImage  *pullDownButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"keyboard_bar_pulldown_button" ofType:@"png"]];
    pullDownButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [pullDownButton_ setImage:pullDownButtonImage forState:UIControlStateNormal];
    [pullDownButton_ setFrame:CGRectMake(self.bounds.size.width - BUTTON_SIZE - 5.0, self.bounds.origin.y + 1.0, BUTTON_SIZE, BUTTON_SIZE)];
    [self addSubview:pullDownButton_];
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
