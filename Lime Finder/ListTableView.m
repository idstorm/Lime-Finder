//
//  ListTableView.m
//  Lime Finder
//
//  Created by idstorm on 13. 4. 24..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "ListTableView.h"
#import "RootViewController.h"

@implementation ListTableView
@synthesize rootViewController_;

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

    }
    return self;
}
*/

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}

- (void)reloadData
{
    [super reloadData];
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
