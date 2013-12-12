//
//  LMLabel.h
//  Lime Finder
//
//  Created by idstorm on 13. 6. 8..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMLabel : UILabel
{
    NSMutableAttributedString   *attributedString_;
}

@property (nonatomic, retain) NSMutableAttributedString *attributedString_;

- (void)setTextColor:(UIColor *)textColor range:(NSRange)aRange;

@end
