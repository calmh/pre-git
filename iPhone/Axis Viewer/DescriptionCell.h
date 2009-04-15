#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DescriptionCell : UITableViewCell {
    UILabel *descriptionLabel;
    UILabel *valueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property(nonatomic, retain) IBOutlet UILabel *valueLabel;

@end
