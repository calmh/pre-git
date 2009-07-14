/* RenamerController */

#import <Cocoa/Cocoa.h>
#import "NameMapper.h"

@interface RenamerController : NSObject
{
	IBOutlet NSTableView *table;
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSWindow *progressWindow;
	IBOutlet NSProgressIndicator *progressIndicator;
	IBOutlet NSWindow* jobNameWindow;
	IBOutlet NSTextField* jobNameField;
	IBOutlet NSProgressIndicator* refreshProgress;
	IBOutlet NSButton* buttonDownload;
	IBOutlet NSButton* buttonRefresh;
    
	NSMutableDictionary* directoryCache;
	NameMapper* mapper;
	BOOL run;
	BOOL refreshDone;
	NSString* jobName;
}
- (IBAction) buttonRefreshClicked: (id) sender;
- (IBAction) buttonDownloadClicked: (id) sender;
- (IBAction) buttonStopClicked: (id) sender;
- (IBAction) buttonJobNameCancelClicked: (id) sender;
- (IBAction) buttonJobNameOKClicked: (id) sender;

- (NSString*) jobName;
- (void) setJobName: (NSString*) jobname;

- (id) init;
- (void) awakeFromNib;
- (void) renamerThread: (id) object;
- (void) refreshThread: (NSString*) path;
- (void) windowWillClose: (NSNotification*) aNotification;
- (BOOL) checkAndCreateDirectory: (NSString*) directory;
- (void) downloadFiles;
@end
