#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CameraDisplayViewController : UITableViewController {
	UIWebView* webView;
	NSURL* webViewLoadedURL;
	NSMutableDictionary* camera;
	NSMutableDictionary* parameters;
	BOOL previewUpdated;
}

@property(nonatomic, retain) NSMutableDictionary* camera;
@property(nonatomic, retain) NSURL* webViewLoadedURL;

- (void)editPressed: (id)sender;
// - (void)fastRefreshChanged: (id)sender;

@end
