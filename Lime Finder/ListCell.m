//
//  ListCell.m
//  Lime Finder
//
//  Created by idstorm on 13. 4. 25..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//

#import "ListCell.h"
#import "ListCellImageViewDummy.h"
#import <Foundation/Foundation.h>
#import "RootViewController.h"

#define DegreesToRads(degrees)((degrees) * (M_PI / 180.f))

@implementation ListCell

@synthesize rootViewController_;
@synthesize listItemMutableDictionary_;
@synthesize faviconSize_;
@synthesize faviconImage_;
@synthesize faviconDefaultImage_;
@synthesize faviconImageView_;
@synthesize receivedImageData_;
@synthesize faviconImagePath_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
        
        listItemMutableDictionary_ = nil;
        
        // 파비콘 이미지 크기 //
        faviconSize_.width = 24.f;
        faviconSize_.height = 24.f;
        faviconImage_ = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_icon_null" ofType:@"png"]];
        faviconDefaultImage_ = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_icon_null" ofType:@"png"]];
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
    }
    return self;
}


/* 서브 뷰를 초기화 한다. */
- (void)initViews
{
    UIImage *faviconDummyImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favicon_dummy" ofType:@"png"]];
    self.imageView.image = faviconDummyImage;
    [self.imageView setFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.imageView setUserInteractionEnabled:YES];
    self.contentView.backgroundColor = [UIColor clearColor];
    ListCellImageViewDummy  *listCellImageViewDummy = [[ListCellImageViewDummy alloc] initWithFrame:self.imageView.bounds];
    listCellImageViewDummy.backgroundColor = [UIColor clearColor];
    
    UIImage *editButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_btn_arrow_right" ofType:@"png"]];
    //UIImageView *editButton = [[UIImageView alloc] initWithImage:editButtonImage];
    UIButton    *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setBackgroundImage:editButtonImage forState:UIControlStateNormal];
    [editButton setBackgroundImage:editButtonImage forState:UIControlStateSelected];
    [editButton setBackgroundImage:editButtonImage forState:UIControlStateHighlighted];
    editButton.frame = CGRectMake(editButton.bounds.size.width / 2.0 - editButtonImage.size.width / 4.0, editButton.bounds.size.height / 2.0 - editButtonImage.size.height / 4.0, editButtonImage.size.height / 2.0, editButtonImage.size.height / 2.0);
    [editButton addTarget:self action:@selector(editButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    self.editingAccessoryView = editButton;
    [self.imageView addSubview:listCellImageViewDummy];
    
    faviconImageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView.image.size.width / 2 - faviconSize_.width / 2, self.imageView.image.size.height / 2 - faviconSize_.height / 2 , faviconSize_.width, faviconSize_.height)];
    faviconImageView_.image = faviconDefaultImage_;
    [self.imageView addSubview:faviconImageView_];
}


/* 즐겨찾기아이템 항목을 설정한다. */
- (void)setListItem:(NSDictionary *)dictionary
{
    listItemMutableDictionary_ = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    UIImage *faviconImage;
    NSString *imagePath = [dictionary valueForKey:@"FaviconPath"];
    NSString *hostURL = [dictionary valueForKey:@"HostURL"];
   
    if ([imagePath isEqualToString:@""] || imagePath == nil)
    {
        NSURL *faviconURL = [self getFaviconURLWithURLString:hostURL];
        if (faviconURL)
        {
            // URLRequest 생성
            NSURLRequest *theRequest = [NSURLRequest requestWithURL:faviconURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            // URLConnection 생성
            NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
            if (theConnection)
            {
                receivedImageData_ = [NSMutableData data];
            }
        }
        else
        {
           [self setFaviconImage:faviconDefaultImage_];
        }
    }
    else
    {
        /* 이미지 경로 */
        NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imagePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) // 번틀패스에 이미지가 있는지 확인한다. 있을경우 적용
        {
            faviconImage = [[UIImage alloc] initWithContentsOfFile:filePath];
            [self setFaviconImage:faviconImage];
        }
        else    // 번들패스에 이미지가 없다면, 도큐멘트 폴더에서 한번 더 확인한다. 있을경우 적용
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *applicationDirectory = [paths objectAtIndex:0];
            filePath = [applicationDirectory stringByAppendingPathComponent:imagePath];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) // 도큐멘트 폴더에서 이미지 여부 체크
            {
                faviconImage = [[UIImage alloc] initWithContentsOfFile:filePath];
                if (!faviconImage)
                    faviconImage = faviconDefaultImage_;
                [self setFaviconImage:faviconImage];
            }
            else // 없다면 네트워크로 다운받는다.
            {
                NSURL *faviconURL = [self getFaviconURLWithURLString:hostURL];
                if (faviconURL)
                {
                    // URLRequest 생성
                    NSURLRequest *theRequest = [NSURLRequest requestWithURL:faviconURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                    // URLConnection 생성
                    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
                    if (theConnection)
                    {
                        receivedImageData_ = [NSMutableData data];
                    }
                }
                else
                    [self setFaviconImage:faviconDefaultImage_];
            }
        }
    }
}


/* 검색어가 입력되었다. */
- (void)setCellLabelWithString:(NSString *)string
{
    NSString *title = [listItemMutableDictionary_ valueForKey:@"Title"];
    NSString *searchURL = [listItemMutableDictionary_ valueForKey:@"SearchURL"];
    
    
    NSString *searchMessage = @"";
    if ([string isEqualToString:@""] || string == nil)
    {
        // searchMessage = [[NSString alloc] initWithFormat:@"%@ 열기", title];
        searchMessage = title;
        self.textLabel.text = searchMessage;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:16.f];
        self.textLabel.textColor = [UIColor grayColor];
    }
    else
    {
        if([searchURL isEqualToString:@""] || searchURL == nil)
        {
            // searchMessage = [[NSString alloc] initWithFormat:@"%@ 열기", title];
            searchMessage = title;
            NSString *detailMessage = @"검색URL이 입력되지 않았습니다 !";
            self.textLabel.text = searchMessage;
            self.detailTextLabel.text = detailMessage;
            self.detailTextLabel.textColor = [UIColor colorWithRed:(136.0 / 255.0) green:(136.0 / 255.0) blue:(136.0 / 255.0) alpha:1.0];
            self.detailTextLabel.font = [UIFont systemFontOfSize:11.f];
            self.textLabel.font = [UIFont systemFontOfSize:13.f];
            self.textLabel.textColor = [UIColor grayColor];
        }
        else
        {
            NSString *stringA = [[NSString alloc] initWithFormat:@"%@에서 ", title];
            NSString *stringB = [[NSString alloc] initWithFormat:@"%@ 검색하기", string];
            searchMessage = [[NSString alloc] initWithFormat:@"%@%@", stringA, stringB];
            
            const CGFloat fontSize = 14.0;
            UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
            UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
            UIColor *foregroundColor = [UIColor grayColor];
            UIColor *highlightColor = [[UIColor alloc] initWithRed:(114.0 / 255.0) green:(210.0 / 255.0) blue:(216.0 / 255.0) alpha:1.0];
            
            // Label의 문자열 속성을 설정한다. //
            
            // 기본 문자열 설정 - 레귤러 폰트, grayColor
            NSDictionary *attrsDefault = [NSDictionary dictionaryWithObjectsAndKeys:
                                   regularFont, NSFontAttributeName,
                                   foregroundColor, NSForegroundColorAttributeName, nil];
            
            // 하일라이트 문자열 설정 - 레귤러 폰트, red:(114.0 / 255.0) green:(210.0 / 255.0) blue:(216.0 / 255.0) alpha:1.0
            NSDictionary *attrsHighlight = [NSDictionary dictionaryWithObjectsAndKeys:
                                      regularFont, NSFontAttributeName,
                                      highlightColor, NSForegroundColorAttributeName, nil];
            // Bold 문자열
            NSDictionary *attrsBold = [NSDictionary dictionaryWithObjectsAndKeys:
                                   boldFont, NSFontAttributeName,
                                   foregroundColor, NSForegroundColorAttributeName, nil];
            
            NSRange rangeHighlight;
            rangeHighlight.location = stringA.length;
            rangeHighlight.length = string.length;
            NSRange rangeBold;
            rangeBold.location = 0;
            rangeBold.length = title.length;
            
            
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:searchMessage
                                                   attributes:attrsDefault];
            [attributedText addAttributes:attrsHighlight range:rangeHighlight];
            [attributedText addAttributes:attrsBold range:rangeBold];
            

            [self.textLabel setAttributedText:attributedText];
            
            /*
            searchMessage = [[NSString alloc] initWithFormat:@"%@에서 '%@' 검색하기", title, string];
            self.textLabel.text = searchMessage;
            self.textLabel.font = [UIFont systemFontOfSize:13.f];
            self.textLabel.textColor = [UIColor grayColor];
             */
        }
    }

}


/* 데이터 수신에 대한 응답이 됨 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedImageData_ setLength:0];
}


/* 데이터 수신 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedImageData_ appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self setFaviconImage:faviconDefaultImage_];
}


/* 데이터 수신 완료 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 수신된 데이터를 UIImage 데이터로 저장한다. 
    UIImage *image = [[UIImage alloc] initWithData:receivedImageData_];
    
    if (image)
    {
        // Cell의 이미지를 설정한다.
        [self setFaviconImage:image];
        
        // 파일로 저장한다. - document/favicon
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.f];
        NSTimeInterval interval = [date timeIntervalSince1970];
        NSString *filename = [[NSString alloc] initWithFormat:@"%f", interval];
        filename = [filename stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        filename = [filename stringByAppendingPathExtension:@"ico"];
        printf(">time %s \n", [filename UTF8String]);
        
        if([receivedImageData_ writeToFile:[self dataFilePathWithFilename:filename] atomically:YES])
        {
            faviconImagePath_ = [NSString stringWithFormat:@"favicon/%@", filename];
            [listItemMutableDictionary_ setObject:faviconImagePath_ forKey:@"FaviconPath"];
            [rootViewController_.listManager_ updateList:listItemMutableDictionary_ atIndex:self.tag];
        }
        else
        {
            // NSLog(@"파일 저장 실패 !\n");
        }
    }
    else
    {
        [self setFaviconImage:faviconDefaultImage_];
    }
}


/* 저장할 파일 패스를 생성한다. */
- (NSString *)dataFilePathWithFilename:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // document 하위 favicon 폴더가 없다면 폴더를 생성한다.
    
    NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:@"favicon"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [directoryPath stringByAppendingPathComponent:filename];
}



/* 파비콘을 추가한다. */
- (void)setFaviconImage:(UIImage *)faviconImage
{
    faviconImageView_.image = faviconImage;
}


/* ImageView가 터치 되었다 */
- (void)imageViewTouched:(UITapGestureRecognizer *)sender
{
    
}


/* editButton이 터치 되다. */
- (void)editButtonTouched:(id)sender
{
    NSDictionary *dictionary = [rootViewController_.listManager_.list_ objectAtIndex:self.tag];
    rootViewController_.itemManageViewController_.itemManageState_ = ITEM_MANAGE_STATE_EDIT;
    rootViewController_.itemManageViewController_.itemIndex_ = self.tag;
    [rootViewController_.itemManageViewController_.itemMutableDictionary_ setDictionary:dictionary];
    [rootViewController_ showItemManageView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


/* 영역을 그리다. */
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   
    // Draw Line
    CGFloat lineColor[] = {(200.0 / 255.0), (200.0 / 255.0), (200.0 / 255.0), 1.0};
    CGContextSetShouldAntialias(context, NO);
    CGContextSetLineWidth(context, 1.0);
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
}


- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
     if ((state & UITableViewCellStateShowingEditControlMask) == UITableViewCellStateShowingEditControlMask)
     {
        for (UIView *subView in self.subviews)
        {
            if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellReorderControl"])
            {
                UIView *tableViewCellReorderControl = [subView.subviews objectAtIndex:0];
                UIImage *reorderButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_btn_list_movement" ofType:@"png"]];
                UIImageView *reorderButton = [[UIImageView alloc] initWithImage:reorderButtonImage];
                reorderButton.userInteractionEnabled = NO;
                reorderButton.frame = tableViewCellReorderControl.bounds;
                reorderButton.backgroundColor = [UIColor whiteColor];
                [tableViewCellReorderControl addSubview:reorderButton];
            }
        }
     }
     if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
     {
         for (UIView *subView in self.subviews)
         {
             if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
             {
                 UIView *tableViewCellDeleteConfirmationControl = [subView.subviews objectAtIndex:0];
                 UIImage *deleteButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list_btn_btn_delete" ofType:@"png"]];
                 UIImageView *deleteButton = [[UIImageView alloc] initWithImage:deleteButtonImage];
                 deleteButton.userInteractionEnabled = NO;
                 deleteButton.frame = tableViewCellDeleteConfirmationControl.bounds;
                 deleteButton.backgroundColor = [UIColor whiteColor];
                 if (tableViewCellDeleteConfirmationControl.subviews.count == 0)
                 {
                     [tableViewCellDeleteConfirmationControl addSubview:deleteButton];
                 }
             }
         }
     }
}


/* 주어진 URL문자열로 NSURL을 반환한다. */
- (NSURL *)getFaviconURLWithURLString:(NSString *)string
{
    NSString *urlString;
    NSString *hostString;
    NSString *httpString;
    
    if([[string lowercaseString] rangeOfString:@"http://"].location == NSNotFound && [[string lowercaseString] rangeOfString:@"https://"].location == NSNotFound)
    {
        httpString = @"http://";
        urlString = [NSString stringWithFormat:@"http://%@", string];
    }
    else
    {
        if ([[string lowercaseString] rangeOfString:@"https://"].location != NSNotFound)
        {
            httpString = @"https://";
            urlString = string;
        }
        else
        {
            httpString = @"http://";
            urlString = string;
        }
    }
    
    hostString = [[NSURL alloc] initWithString:urlString].host;
    hostString = [hostString stringByReplacingOccurrencesOfString:@"m." withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 2)];
    
    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@/favicon.ico",httpString, hostString]];
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



/* 터치가 취소되었다. */
// 셀의 배경색을 원래 색으로 변경한다. 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
    [super touchesEnded:touches withEvent:event];
}


@end
