#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CameraDisplayViewController : UITableViewController {
	UIWebView* webView;
	NSMutableDictionary* camera;
	NSMutableData* receivedData;
	NSString* cameraText;
	NSString* cameraModel;
	BOOL fetchedAsViewer;
	BOOL fetchedAsOperator;
}

@property(nonatomic, retain) NSMutableDictionary* camera;
@property(nonatomic, retain) NSString* cameraText;
@property(nonatomic, retain) NSString* cameraModel;


- (void)editPressed: (id)sender;
- (void)fastRefreshChanged: (id)sender;

@end
