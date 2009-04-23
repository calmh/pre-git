#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AxisCamera.h"

@interface CameraDisplayViewController : UITableViewController {
	UIWebView* webView;
	NSURL* webViewLoadedURL;
        NSMutableDictionary* camera;
        AxisCamera* axisCamera;
}

@property(nonatomic, retain) NSMutableDictionary* camera;
@property(nonatomic, retain) NSURL* webViewLoadedURL;

@end

// Hidden methods

@interface CameraDisplayViewController ()

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)updateWebViewForCamera:(NSString*)url withFps:(NSNumber*)fps;
- (void)editPressed:(id)sender;

@end;