#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CameraDisplayViewController : UIViewController {
    UIWebView* webView;
    UILabel* titleLabel;
	UILabel* modelLabel;
    NSMutableDictionary* camera;
}

@property(nonatomic, retain) IBOutlet UIWebView* webView;
@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UILabel* modelLabel;
@property(nonatomic, retain) NSMutableDictionary* camera;

- (NSDictionary*)getAxisParametersForCamera: (NSString*)url;
- (void)editPressed: (id)sender;

@end
