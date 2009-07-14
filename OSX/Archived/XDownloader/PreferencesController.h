/* PreferencesController */

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSObject
{
	IBOutlet NSPanel* preferencesPanel;
	IBOutlet NSTextField* exampleField;
	IBOutlet NSTableView* exampleVariables;
	NSString* renamingTemplate;
}
- (id)init;
- (void)setupDefaults;
- (IBAction)buttonOKClicked:(id)sender;
- (IBAction)buttonCancelClicked:(id)sender;
- (IBAction)chooseDestination:(id)sender;
- (IBAction)chooseSource:(id)sender;
- (IBAction)preferencesSelected:(id)sender;
- (void) setRenamingTemplate: (NSString*) aRenamingTemplate;
- (NSString*) renamingTemplate;
@end
