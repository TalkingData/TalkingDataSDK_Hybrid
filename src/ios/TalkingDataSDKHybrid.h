#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


@interface TalkingDataSDKHybrid : NSObject

+ (TalkingDataSDKHybrid *)getInstance;
- (BOOL)execute:(NSURL *)url webView:(WKWebView *)webView;

@end
