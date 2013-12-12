//
//  MypeopleManager.m
//  Air21
//
//  Created by Seong-jin kim on 11 5 24.
//  Copyright 2011 Daum Communications. All rights reserved.
//

#import "MypeopleManager.h"

#define MYPEOPLE_URL_SCHEME				@"myp"
#define MYPEOPLE_TASK_SEND_MESSAGE		@"sendMessage"
#define MYPEOPLE_TASK_SEND_MEDIA_MESSAGE @"sendMediaMessage"
#define MYPEOPLE_TASK_SET_PROFILE       @"setProfile"
#define MYPEOPLE_TASK_SEND_MAP_MESSAGE  @"sendMap"
#define MYPEOPLE_DOWNLOAD_URL			@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=373539016&;amp;amp;amp;amp;mt=8"
#define MYPEOPLE_INTRODUCE_URL			@"http://m.mypeople.daum.net/mypeople/promotion.do"

@interface MypeopleManager(Private)
- (NSString *)urlEncodeValue:(NSString *)str;
- (NSURL *)buildURLWithParams:(NSDictionary *)params task:(NSString*)task;
@end

@implementation MypeopleManager
@synthesize appID;
@synthesize appName;

static id sharedInstance = nil;

+ (void)initialize {
    if (self == [MypeopleManager class]) {
        sharedInstance = [[self alloc] init];
    }
}

+ (id)sharedInstance {
	static dispatch_once_t pred;
	static MypeopleManager *shared = nil;
	
	dispatch_once(&pred, ^{
		shared = [[MypeopleManager alloc] init];
	});
	return shared;
}

- (void)dealloc {
    self.appID = nil;
    self.appName = nil;
    [super dealloc];
}

- (NSString *)urlEncodeValue:(NSString *)str {
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8);
	return [result autorelease];
}

- (NSURL *)buildURLWithParams:(NSDictionary *)params task:(NSString*)task{
	NSMutableString *strUrl = [NSMutableString string];
	
	NSUInteger i = 0;
	NSUInteger count = [params count]-1;
	for (NSString *key in [params allKeys]) {
		[strUrl appendString:[NSString stringWithFormat:@"%@=%@%@", [self urlEncodeValue:key], [self urlEncodeValue:(NSString *)[params objectForKey:key]], (i < count ? @"&" : @"")]];
		i++;
	}
    
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?%@", MYPEOPLE_URL_SCHEME, task, strUrl]];
}

- (BOOL) canOpenMypeopleURL {
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", MYPEOPLE_URL_SCHEME, MYPEOPLE_TASK_SEND_MESSAGE]]];
}

- (BOOL) openMypeopleDownloadURL {
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MYPEOPLE_DOWNLOAD_URL]];
}

- (BOOL) openMypeopleIntroduceURL {
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MYPEOPLE_INTRODUCE_URL]];
}

#pragma Interface
- (BOOL) setMypeopleProfilePhotoByUrl:(NSString*)imageUrl {
	if (![self canOpenMypeopleURL]) {
		[self openMypeopleDownloadURL];
		return NO;
	}
		
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:self.appID forKey:@"appID"];
    [params setObject:self.appName forKey:@"appName"];
    
    if ([imageUrl length] > 0) {
        [params setObject:imageUrl forKey:@"url"];
    }
    
    return [[UIApplication sharedApplication] openURL:[self buildURLWithParams:params task:MYPEOPLE_TASK_SET_PROFILE]];
}

- (BOOL) setMypeopleProfilePhoto:(NSData*)imageData {
	if (![self canOpenMypeopleURL]) {
		[self openMypeopleDownloadURL];
		return NO;
	}
    
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:self.appID forKey:@"appID"];
    [params setObject:self.appName forKey:@"appName"];
    
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    [gpBoard setData:imageData forPasteboardType:@"public.image"];
    
    return [[UIApplication sharedApplication] openURL:[self buildURLWithParams:params task:MYPEOPLE_TASK_SET_PROFILE]];
}

- (BOOL) sendTextMessage:(NSString*)textMessage {
	if (![self canOpenMypeopleURL]) {
		[self openMypeopleDownloadURL];
		return NO;
	}
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params setObject:self.appID forKey:@"appID"];
    [params setObject:self.appName forKey:@"appName"];
    
	if ([textMessage length] > 0) {
		[params setObject:textMessage forKey:@"message"];
	}
    
    return [[UIApplication sharedApplication] openURL:[self buildURLWithParams:params task:MYPEOPLE_TASK_SEND_MESSAGE]];
}

- (BOOL)sendTextMessageWithUrl:(NSString *)linkUrl message:(NSString *)message {
	if (![self canOpenMypeopleURL]) {
		[self openMypeopleDownloadURL];
		return NO;
	}
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
	if ([linkUrl length] > 0) {
		[params setObject:linkUrl forKey:@"url"];
	}
	
	if ([message length] > 0) {
		[params setObject:message forKey:@"message"];
	}
    
    [params setObject:self.appID forKey:@"appID"];
    [params setObject:self.appName forKey:@"appName"];
    
	return [[UIApplication sharedApplication] openURL:[self buildURLWithParams:params task:MYPEOPLE_TASK_SEND_MESSAGE]];
}

- (BOOL) sendMediaByUrl:(NSString*)url {
	if (![self canOpenMypeopleURL]) {
		[self openMypeopleDownloadURL];
		return NO;
	}
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:self.appID forKey:@"appID"];
    [params setObject:self.appName forKey:@"appName"];
    
    if ([url length] > 0) {
        [params setObject:url forKey:@"url"];
    }
    
    return [[UIApplication sharedApplication] openURL:[self buildURLWithParams:params task:MYPEOPLE_TASK_SEND_MEDIA_MESSAGE]];
}

- (BOOL) sendMediaData:(NSData *)mediaData fileName:(NSString*)fileName {
	if (![self canOpenMypeopleURL]) {
		[self openMypeopleDownloadURL];
		return NO;
	}
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:self.appID forKey:@"appID"];
    [params setObject:self.appName forKey:@"appName"];
    
    if([fileName length] > 0 ){
		[params setObject:fileName forKey:@"fileName"];        
    }
    
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    [gpBoard setData:mediaData forPasteboardType:@"public.data"];
    
    return [[UIApplication sharedApplication] openURL:[self buildURLWithParams:params task:MYPEOPLE_TASK_SEND_MEDIA_MESSAGE]];
}

- (BOOL) sendMapMessage:(NSString*)mapTitle latitude:(double)latitude longitude:(double)longitude {
	if (![self canOpenMypeopleURL]) {
		[self openMypeopleDownloadURL];
		return NO;
	}
	
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:self.appID forKey:@"appID"];
    [params setObject:self.appName forKey:@"appName"];
    
    [params setObject:[[NSNumber numberWithDouble:latitude] stringValue] forKey:@"latitude"];
    [params setObject:[[NSNumber numberWithDouble:longitude] stringValue] forKey:@"longitude"];
    [params setObject:mapTitle forKey:@"caption"];
    
    
    return [[UIApplication sharedApplication] openURL:[self buildURLWithParams:params task:MYPEOPLE_TASK_SEND_MAP_MESSAGE]];
}


#pragma setter, getter
- (NSString *) appName {
    if(appName == nil){
        NSDictionary *info = [NSBundle mainBundle].infoDictionary;
        self.appName = [info objectForKey:@"CFBundleDisplayName"];
    }
    return appName;
}

- (NSString *) appID {
    if(appID == nil){
        NSDictionary *info = [NSBundle mainBundle].infoDictionary;
        self.appID = [info objectForKey:@"CFBundleIdentifier"];
        
    }    
    return appID;
}
@end
