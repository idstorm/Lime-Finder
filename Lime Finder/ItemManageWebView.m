//
//  ItemManageWebView.m
//  Lime Finder
//
//  Created by idstorm on 13. 5. 30..
//  Copyright (c) 2013년 Lime Works. All rights reserved.
//
#import <objc/runtime.h>
#import "ItemManageWebView.h"

#import "RootViewController.h"

@interface UIWebView ()
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;
@end


/*
@interface NSObject (UIWebViewTappingDelegate)
- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end

@interface ItemManageWebView (Private)
- (void)fireZoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)fireTappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end

@implementation UIView (__TapHook)

- (void)__touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self __touchesEnded:touches withEvent:event];
    
	id webView = [[self superview] superview];
	if (touches.count > 1) {
		if ([webView respondsToSelector:@selector(fireZoomingEndedWithTouches:event:)]) {
			[webView fireZoomingEndedWithTouches:touches event:event];
		}
	}
	else {
		if ([webView respondsToSelector:@selector(fireTappedWithTouch:event:)]) {
			[webView fireTappedWithTouch:[touches anyObject] event:event];
		}
	}
}

@end


static BOOL hookInstalled = NO;

static void installHook()
{
	if (hookInstalled) return;
    
	hookInstalled = YES;
    
	Class klass = objc_getClass("UIWebDocumentView");
	Method targetMethod = class_getInstanceMethod(klass, @selector(touchesEnded:withEvent:));
	Method newMethod = class_getInstanceMethod(klass, @selector(__touchesEnded:withEvent:));
	method_exchangeImplementations(targetMethod, newMethod);
}
*/


@implementation ItemManageWebView

@synthesize progressDelegate_;
@synthesize resourceCount_;
@synthesize resourceCompletedCount_;
@synthesize rootViewController_;

/*
- (id)initWithCoder:(NSCoder*)coder
{
    if (self = [super initWithCoder:coder]) {
		installHook();
    }
    return self;
}



- (void)fireZoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
{
	if ([self.delegate respondsToSelector:@selector(webView:zoomingEndedWithTouches:event:)]) {
		[(NSObject*)self.delegate webView:self zoomingEndedWithTouches:touches event:event];
	}
}

- (void)fireTappedWithTouch:(UITouch*)touch event:(UIEvent*)event
{
    NSLog(@"터치 와방 됨 ");
	if ([self.delegate respondsToSelector:@selector(webView:tappedWithTouch:event:)]) {
		[(NSObject*)self.delegate webView:self tappedWithTouch:touch event:event];
	}
}
*/
 
/* 뷰 초기화 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // installHook();
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *windows = [application windows];
        UIWindow *window = [windows objectAtIndex:0];
        rootViewController_ = (RootViewController *)window.rootViewController;
    }
    return self;
}


/* 레이아웃이 변경되었을 경우 호출 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    //self.scrollView.contentOffset = CGPointMake(-self.scrollView.contentInset.top, 0);
}


/* 로딩 프로그래스 시작 */
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    // NSLog(@"데이터 수신 시작 count:%d total:%d", resourceCompletedCount_, resourceCount_);
    return [NSNumber numberWithInt:resourceCount_++];
}


/* 로딩 프로그래스 오류 발생 */
- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    resourceCompletedCount_++;
    
    if ([self.progressDelegate_ respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)])
    {
        [self.progressDelegate_ webView:self didReceiveResourceNumber:resourceCompletedCount_ totalResources:resourceCount_];
    }
    // NSLog(@"수신 오류 발생 count:%d total:%d", resourceCompletedCount_, resourceCount_);
}


/* 로딩 데이터 소스 수신 완료 */
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    [rootViewController_.itemManageViewController_ loadedFromWebViewResourceData];
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    resourceCompletedCount_++;
    if ([self.progressDelegate_ respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)])
    {
        [self.progressDelegate_ webView:self didReceiveResourceNumber:resourceCompletedCount_ totalResources:resourceCount_];
    }

    
    if(resourceCompletedCount_ == resourceCount_)
    {
        resourceCompletedCount_ = 0;
        resourceCount_ = 0;
        [rootViewController_.webViewController_.webURLBar_ endProgress];
    }
    // NSLog(@"데이터 수신 완료 count:%d total:%d", resourceCompletedCount_, resourceCount_);
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
