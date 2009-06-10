#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AVAxisCamera.h"

@interface AVCameraDisplayViewController : UITableViewController {
	UIWebView* webView;
	NSURL* webViewLoadedURL;
        NSMutableDictionary* camera;
        AVAxisCamera* axisCamera;
}

@property (retain) NSMutableDictionary* camera;
@property (retain) NSURL* webViewLoadedURL;

@end

// Hidden methods

@interface AVCameraDisplayViewController ()

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)updateWebViewForCamera:(NSString*)url withFps:(NSNumber*)fps;
- (void)editPressed:(id)sender;

@end;