#import <Foundation/NSFileManager.h>
#import "RenamerController.h"
#import "NameMapper.h"
#import "ExifWrapper.h"
#import "CanonRAW.h"
#import "Nym.Foundation/NymLogger.h"

@implementation RenamerController

/*
 * Initializers and destructors.
 */

- (id)init {
	NFLog(@"init");
	[super init];
	refreshDone = true;
	NFLog(@"Creating debug log");
	return self;
}

- (void) dealloc {
	NFLog(@"dealloc");
	[mapper release];
	mapper = nil;
	[super dealloc];
}

- (void)awakeFromNib {
	NFLog(@"awakeFromNib");
	[self setJobName: @"(Jobname)"];
	[self buttonRefreshClicked: self];
}

/*
 * NIB actions.
 */

- (IBAction)buttonRefreshClicked:(id)sender
{
	NFLog(@"buttonRefreshClicked");
	NFAssert(sender);
	
	if (!refreshDone) {
		NFLog(@"refresh already in progress...");
		return;
	}
	
	refreshDone = false;
	[buttonRefresh setEnabled: false];
	[buttonDownload setEnabled: false];
	NSString* dir = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"sourceDirectory"];
	[NSThread detachNewThreadSelector:@selector(refreshThread:) toTarget:self withObject:dir];
}

- (IBAction)buttonDownloadClicked:(id)sender
{
	NFLog(@"buttonDownloadClicked");
	NFAssert(sender);
	
	BOOL askForJobName = [[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"askForJobName"] boolValue];
	if (askForJobName) {
		NFLog(@"askForJobName");
		[NSApp beginSheet: jobNameWindow
		   modalForWindow: mainWindow
		    modalDelegate: self
		   didEndSelector: nil
		      contextInfo: nil];
	} else {
		[self downloadFiles];
	}
}

- (IBAction)buttonStopClicked:(id)sender {
	NFLog(@"buttonStopClicked");
	run = false;
}

- (IBAction)buttonJobNameCancelClicked:(id)sender {
	NFLog(@"buttonJobNameCancelClicked");
	[NSApp endSheet: jobNameWindow];
	[jobNameWindow close];
}

- (IBAction)buttonJobNameOKClicked:(id)sender {
	NFLog(@"buttonJobNameOKClicked");
	NFAssert(jobNameWindow);
	[NSApp endSheet: jobNameWindow];
	[jobNameWindow close];
	
	[self downloadFiles];
}

/*
 * Normal methods.
 */

- (void)downloadFiles {
	NFLog(@"downloadFiles");
	NSDictionary* mappings = [mapper getMappings];
	NFAssert(mappings);
	
	if ([mappings count] <= 0)
		return;
	
	NFAssert(mainWindow);
	NFAssert(progressWindow);
	NFAssert(progressIndicator);
	
	[progressIndicator setDoubleValue: 0.0];
	[progressIndicator setMaxValue: [mappings count]];
	[NSApp beginSheet: progressWindow
	   modalForWindow: mainWindow
            modalDelegate: nil
	   didEndSelector: nil
	      contextInfo: nil];
	
	[NSThread detachNewThreadSelector:@selector(renamerThread:) toTarget:self withObject:nil];
}

/*
 * Member values.
 */

- (NSString*) jobName {
	NFLog(@"jobName");
	// Maybe OK for jobName to be nil here. It is, during intialization...
	//NFAssert(jobName);
	return jobName;
}

- (void) setJobName: (NSString*) _jobName {
	NFAssert(_jobName);
	NFLog(@"setJobName: %@", _jobName);
	[_jobName retain];
	[jobName release];
	jobName = _jobName;
}

/*
 * Worker thread methods below.
 */

- (void)refreshThread: (NSString*) path {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NFLog(@"refreshThread starting");
	NFAssert(path);
	
	NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager]  enumeratorAtPath:path];
	if (direnum == nil) {
		NFLog(@"no such directory");
		[refreshProgress stopAnimation: self];
		[buttonRefresh setEnabled: true];
		[buttonDownload setEnabled: true];
		[pool release];
		refreshDone = true;
		return;
	}
	
	[mapper release];
	mapper = [[NameMapper alloc] init];
	NFAssert(mapper);
	NFAssert(table);
	[table setDataSource: mapper];
	
	NFAssert(refreshProgress);
	[refreshProgress startAnimation: self];
	NSString *pname;
	while (pname = [direnum nextObject]) {
		NFLog(@"Looking at %@", pname);
		NSString* extension = [[pname pathExtension] lowercaseString];
		NFAssert(extension);
		if ([extension compare: @"thm"] == NSOrderedSame || [extension compare: @"jpg"] == NSOrderedSame) {
			[mapper addSourceName: [NSString stringWithFormat: @"%@/%@", path, pname]];
			[table noteNumberOfRowsChanged];
		}
	}
	
	[table reloadData];
	[refreshProgress stopAnimation: self];
	[buttonRefresh setEnabled: true];
	[buttonDownload setEnabled: true];
	NFLog(@"refreshThread ending");
	[pool release];
	refreshDone = true;
}

- (void)renamerThread:(id)object
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NFLog(@"renamerThread starting");
	NFAssertMsg(object == nil, @"I got a parameter! Why?");
	
	run = true;
	[refreshProgress startAnimation: self];
	
	[directoryCache release];
	directoryCache = [[NSMutableDictionary alloc] init];
	NFAssert(directoryCache);
	
	NSFileManager* man = [NSFileManager defaultManager];
	NFAssert(man);
	NSDictionary* mappings = [mapper getMappings];
	NFAssert(mappings);
	NSEnumerator* enu = [mappings keyEnumerator];
	NFAssert(enu);
	NSString* source;	
	while (run && (source = [enu nextObject])) {
		NSMutableString* dest = [NSMutableString stringWithString: [mappings objectForKey: source]];
		NFAssert(dest);
		[dest replaceOccurrencesOfString:@"{JobName}" withString:[self jobName] options:0 range:NSMakeRange(0, [dest length])];
		
		NSMutableArray* components = [NSMutableArray arrayWithArray:[dest pathComponents]];
		NFAssert(components);
		NFAssertMsg([components count] > 1, @"components too short");
		[components removeLastObject];
		NSString* ddir = [NSString pathWithComponents: components];
		NFAssert(ddir);
		NFAssertMsg([ddir length] > 1, @"ddir too short");
		if (![self checkAndCreateDirectory:ddir]) {
			NFLog(@"checkAndCreateDirectory failed");
			break;
		}
		
		id obj = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"moveOrCopyFiles"];
		NFAssert(obj);
		int val = [obj intValue];
		NFAssertMsg(val == 0 || val == 1, @"Illegal value for moveOrCopyFiles");
		if (val == 1) {
			// Copy file
			NFLog([NSString stringWithFormat:@"Copying '%@' to '%@'", source, dest]);
			if ([man copyPath:source toPath:dest handler:self] == NO) {
				NFLog(@"copyPath failed");
				break;
			}
		} else if (val == 0) {
			// Move file
			NFLog([NSString stringWithFormat:@"Moving '%@' to '%@'", source, dest]);
			if ([man movePath:source toPath:dest handler:self] == NO) {
				NFLog(@"movePath failed");
				break;
			}
		}
		
		// Extract JPEG
		if ([[dest pathExtension] compare: @"crw"] == NSOrderedSame && [[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"extractJpegFromRaw"] intValue] == 1) {
			NSString* expanded = [dest stringByExpandingTildeInPath];
			NSMutableString* jpg = [NSMutableString stringWithString: expanded];
			[jpg replaceOccurrencesOfString:@".crw" withString:@".jpg" options:nil range:NSMakeRange(0, [expanded length])];
			NSData* jpgData = [CanonRAW extractJpegFromRaw:expanded];
			NFLog(@" - Saving extracted JPEG to %@", jpg);
			[jpgData writeToFile: jpg atomically: true];
		}
		
		NFAssert(progressIndicator);
		[progressIndicator incrementBy: 1.0];
	}
	[directoryCache release];
	directoryCache = nil;
	NFAssert(progressWindow);
	[NSApp endSheet:progressWindow];
	[progressWindow close];
	[refreshProgress stopAnimation: self];
	
	NFLog(@"renamerThread ending");
	[pool release];
}

- (BOOL)checkAndCreateDirectory: (NSString*) directory {
	NFLog(@"checkAndCreateDirectory");
	NFAssert(directory);
	NFAssert(directoryCache);
	// Check if the path is in the cache.
	if ([directoryCache objectForKey:directory])
		return 1;
	
	// Extract the path components and walk through them, creating if necessary.
	NSMutableArray* components = [NSMutableArray arrayWithArray: [[directory stringByStandardizingPath] pathComponents]];
	NFAssert(components);
	NSEnumerator* enu = [components objectEnumerator];
	NFAssert(enu);
	NSMutableString* path = [NSMutableString stringWithString:@""];
	NFAssert(path);
	NSString* component;
	NSFileManager* man = [NSFileManager defaultManager];
	NFAssert(man);
	while (component = [enu nextObject]) {
		[path appendString:@"/"];
		[path appendString: component];
		NSString* stdPath = [path stringByStandardizingPath];
		NFAssert(stdPath);
		
		if (![man fileExistsAtPath:stdPath]) {
			NFLog(@"Creating directory '%@'", stdPath);
			if ([man createDirectoryAtPath:stdPath attributes:nil] == NO) {
				NFLog(@"createDirectoryAtPath failed");
				int result = NSRunAlertPanel(@"Directory Creation Error", @"Could not create directory '%@'.", @"Proceed", @"Stop", NULL, stdPath);
				if (result == NSAlertDefaultReturn) {
					NFLog(@"user says 'Proceed'");
					continue;
				} else {
					NFLog(@"user says 'Stop'");
					return 0;
				}
			}
		}
	}
	
	// Mark this directory as verified or created.
	NFAssert(directory);
	[directoryCache setObject:@"exist" forKey:directory];
	return 1;
}

/*
 * Delegates below.
 */

- (void)windowWillClose:(NSNotification *)aNotification {
	NFLog(@"windowWillClose");
	NFLog(@"(exiting)");
	exit(0);
}

-(BOOL)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorDict
{
	NFAssertMsg(errorDict, @"errorDict is nul");
	NFLog(@"fileManager says '%@: %@'", [errorDict objectForKey:@"Error"], [errorDict objectForKey:@"Path"]);
	int result = NSRunAlertPanel(@"Copy/Move Error", @"File operation error '%@: %@'", @"Proceed", @"Stop", NULL, 
				     [errorDict objectForKey:@"Error"], 
				     [errorDict objectForKey:@"Path"]);   
	if (result == NSAlertDefaultReturn) {
		NFLog(@"user says 'Proceed'");
		return YES;
	} else {
		NFLog(@"user says 'Stop'");
		return NO;
	}
}

@end
