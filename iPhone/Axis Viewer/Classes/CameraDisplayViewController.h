#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CameraDisplayViewController : UIViewController {
	UIWebView* webView;
	UILabel* titleLabel;
	UILabel* modelLabel;
	UISwitch* fastRefresh;
	NSMutableDictionary* camera;
	NSMutableData* receivedData;
}

@property(nonatomic, retain) IBOutlet UIWebView* webView;
@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UILabel* modelLabel;
@property(nonatomic, retain) IBOutlet UISwitch* fastRefresh;
@property(nonatomic, retain) NSMutableDictionary* camera;

- (void)editPressed: (id)sender;
- (void)fastRefreshChanged: (id)sender;

@end
