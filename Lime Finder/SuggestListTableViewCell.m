//
//  SuggestListTableViewCell.m
//  Lime Finder
//
//  Created by idstorm on 13. 6. 7..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "SuggestListTableViewCell.h"
#import "RootViewController.h"

@implementation SuggestListTableViewCell

@synthesize rootViewController_;
@synthesize label_;
@synthesize suggestAddButton_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        
        label_ = [[LMLabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + SUGGEST_LIST_TABLE_VIEW_CELL_LABEL_SIDE_MARGINE, SUGGEST_LIST_TABLE_VIEW_CELL_HEIGHT / 2.0 - SUGGEST_LIST_TABLE_VIEW_CELL_LABEL_HEIGHT / 2.0, self.bounds.size.width - SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_SIDE_MARGINE - SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_SIDE_MARGINE - SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_WIDTH - SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_SIDE_MARGINE, SUGGEST_LIST_TABLE_VIEW_CELL_LABEL_HEIGHT)];
        label_.backgroundColor = [UIColor clearColor];
        [self addSubview:label_];
        
        UIImage *suggestAddButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_btn_suggest" ofType:@"png"]];
        suggestAddButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [suggestAddButton_ setImage:suggestAddButtonImage forState:UIControlStateNormal];
        [suggestAddButton_ setImage:suggestAddButtonImage forState:UIControlStateSelected];
        [suggestAddButton_ setImage:suggestAddButtonImage forState:UIControlStateSelected];
        [suggestAddButton_ addTarget:self action:@selector(suggestAddButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        suggestAddButton_.tag = self.tag;
        suggestAddButton_.frame = CGRectMake(self.bounds.size.width - SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_WIDTH, SUGGEST_LIST_TABLE_VIEW_CELL_HEIGHT / 2.0 - SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_HEIGHT / 2.0, SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_WIDTH, SUGGEST_LIST_TABLE_VIEW_CELL_ADD_BUTTON_HEIGHT);
        [self addSubview:suggestAddButton_];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)suggestAddButtonTouched:(id)sender
{
    //rootViewController_.mainViewController_.searchView_.searchField_.text = [[NSString alloc] initWithFormat:@"%@ %@", rootViewController_.mainViewController_.searchView_.searchField_.text, [rootViewController_.mainViewController_.searchView_.suggestArray_ objectAtIndex:self.tag]];
    rootViewController_.mainViewController_.searchView_.searchField_.text = [rootViewController_.mainViewController_.searchView_.suggestArray_ objectAtIndex:self.tag];
    [rootViewController_.mainViewController_.searchView_ searchFieldValueChanged:rootViewController_.mainViewController_.searchView_.searchField_];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Draw Line
    CGFloat lineColor[] = {(200.0 / 255.0), (200.0 / 255.0), (200.0 / 255.0), 1.0};
    CGContextSetShouldAntialias(context, NO);
    CGContextSetLineWidth(context, 0.5);
    CGColorRef color = CGColorCreate(colorSpace, lineColor);
    CGContextSetStrokeColorWithColor(context, color);
    if (self.tag == 0)
    {
        CGContextMoveToPoint(context, self.bounds.origin.x, self.bounds.origin.y);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.origin.y);
    }
    CGContextMoveToPoint(context, self.bounds.origin.x, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(context);
    CGColorRelease(color);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
    
    /*
     for (UIView *subView in self.subviews)
     {
     NSLog(@"%@", NSStringFromClass([subView class]));
     }
     */
}


/* 터치가 시작되다 */
// 터치되었을때 셀의 배경색을 변경한다. red:(245.0 / 255.0) green:(253.0 / 255.0) blue:(253.0 / 255.0) alpha:1.0
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor colorWithRed:(245.0 / 255.0) green:(253.0 / 255.0) blue:(253.0 / 255.0) alpha:1.0];
    [super touchesBegan:touches withEvent:event];
}


/* 터치가 종료되다. */
// 셀의 배경색을 원래 색으로 변경한다.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
    [super touchesEnded:touches withEvent:event];
}

@end
