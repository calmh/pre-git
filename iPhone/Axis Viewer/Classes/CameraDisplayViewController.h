#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CameraDisplayViewController : UITableViewController {
	UIWebView* webView;
	NSURL* webViewLoadedURL;
        NSMutableDictionary* camera;
	NSMutableDictionary* parameters;
}

@property(nonatomic, retain) NSMutableDictionary* camera;
@property(nonatomic, retain) NSURL* webViewLoadedURL;

@end

// Hidden methods

@interface CameraDisplayViewController ()

- (NSString*)createCameraURL;
- (void)savePreviewBackgroundThread;
- (void)saveCameraSnapshotBackgroundThread;
- (void)getAxisParametersBackgroundThread;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)updateWebViewForCamera:(NSString*)url withFps:(NSNumber*)fps;
- (void)editPressed:(id)sender;

@end;