#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CameraDisplayViewController : UIViewController {
    IBOutlet UIWebView* webView;
    IBOutlet UILabel* titleLabel;
    NSMutableDictionary* camera;
}

-(void) setCamera:(NSMutableDictionary*)newCamera;
-(void) editPressed:(id) sender;

@property(nonatomic, retain) UIWebView* webView;
@property(nonatomic, retain) UILabel* titleLabel;
@property(nonatomic, retain) NSMutableDictionary* camera;

@end
