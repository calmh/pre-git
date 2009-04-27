#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AVEditingCell : UITableViewCell {
    UILabel *prompt;
    UITextField *value;
}

@property(nonatomic, retain) IBOutlet UILabel *prompt;
@property(nonatomic, retain) IBOutlet UITextField *value;

@end
