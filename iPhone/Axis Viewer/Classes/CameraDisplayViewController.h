#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CameraDisplayViewController : UIViewController {
    UIWebView* webView;
    UILabel* titleLabel;
    NSMutableDictionary* camera;
}

@property(nonatomic, retain) IBOutlet UIWebView* webView;
@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) NSMutableDictionary* camera;

-(void) editPressed:(id) sender;

@end
