#import "PreferencesController.h"
#import "NameMapper.h"
#import "XDVariables.h"
#import "Nym.Foundation/NymLogger.h"

@implementation PreferencesController

- (id) init {
	NFLog(@"init");
	[super init];
	[self setupDefaults];
	return self;
}

- (void)setupDefaults
{
	NFLog(@"setupDefaults");
	NSString *userDefaultsValuesPath;
	NSDictionary *userDefaultsValuesDict;
	NSDictionary *initialValuesDict;
	
	// load the default values for the user defaults
	userDefaultsValuesPath = [[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"];
	// Seems ok if this is nil...
	// NFAssert(userDefaultsValuesPath);
	userDefaultsValuesDict = [NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
	// Seems ok if this is nil...
	// NFAssert(userDefaultsValuesDict);

	// set them in the standard user defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];
	
	// set default values
	initialValuesDict = [NSDictionary
		dictionaryWithObjects: [NSArray arrayWithObjects:@"/CF", @"~/Pictures", @"{Year}{Month}{Day} - {JobName}/{Year}{Month}{Day}-{Hour}{Minute}{Second}-{ImageNumber}", [NSNumber numberWithInt: 1]  , [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 0], nil]
		forKeys: [NSArray arrayWithObjects:@"sourceDirectory",@"destinationDirectory",@"renamingTemplate",@"moveOrCopyFiles", @"askForJobName", @"extractJpegFromRaw", nil]
		];
	NFAssert(initialValuesDict);
	
	// Set the initial values in the shared user defaults controller 
	[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:initialValuesDict];

	// We don't want to apply until "OK" is pressed.
	[[NSUserDefaultsController sharedUserDefaultsController] setAppliesImmediately: false];
	
	// Initialize our local copy of the template.
	[self setRenamingTemplate: [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"renamingTemplate"]];
}

- (void) setRenamingTemplate: (NSString*) aRenamingTemplate {
	NFLog(@"setRenamingTemplate");
	[aRenamingTemplate retain];
	[renamingTemplate release];
	renamingTemplate = aRenamingTemplate;
	NameMapper* mapper = [[NameMapper alloc] init];
	[exampleField setStringValue: [mapper getExample: [self renamingTemplate]]];
	[mapper release];
}

- (NSString*) renamingTemplate {
	NFLog(@"renamingTemplate");
	return [NSString stringWithString: renamingTemplate];
}

- (IBAction)buttonOKClicked:(id)sender
{
	NFLog(@"buttonOKClicked");
	[[[NSUserDefaultsController sharedUserDefaultsController] values] setValue:[self renamingTemplate] forKey:@"renamingTemplate"];
	[[NSUserDefaultsController sharedUserDefaultsController] save: sender];
	[preferencesPanel close];
}

- (IBAction)buttonCancelClicked:(id)sender
{
	NFLog(@"buttonCancelClicked");
	[self setRenamingTemplate: [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"renamingTemplate"]];
	[[NSUserDefaultsController sharedUserDefaultsController] revert: sender];
	[preferencesPanel close];
}

- (IBAction)chooseDestination:(id)sender
{
	NFLog(@"chooseDestination");
	NSOpenPanel* p = [NSOpenPanel openPanel];
	NFAssert(p);
	[p setCanChooseFiles: 0];
	[p setCanChooseDirectories: true];
	int result = [p runModalForDirectory:[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"destinationDirectory"] file:@""];
	if (result == NSOKButton) {
		NSString* dir = [[p filenames] objectAtIndex:0];
		NFAssert(dir);
		[[[NSUserDefaultsController sharedUserDefaultsController] values] setValue:dir forKey:@"destinationDirectory"];
	}
}

- (IBAction)chooseSource:(id)sender
{
	NFLog(@"chooseSource");
	NSOpenPanel* p = [NSOpenPanel openPanel];
	NFAssert(p);
	[p setCanChooseFiles: 0];
	[p setCanChooseDirectories: true];
	int result = [p runModalForDirectory:[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"sourceDirectory"] file:@""];
	if (result == NSOKButton) {
		NSString* dir = [[p filenames] objectAtIndex:0];
		NFAssert(dir);
		[[[NSUserDefaultsController sharedUserDefaultsController] values] setValue:dir forKey:@"sourceDirectory"];
	}
}

- (IBAction)preferencesSelected:(id)sender
{
	NFLog(@"preferencesSelected");
	[preferencesPanel makeKeyAndOrderFront: sender];
	[self setRenamingTemplate: [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"renamingTemplate"]];
	
	// Point the example variables at their data
	[exampleVariables setDataSource: [[XDVariables alloc] init]];
	
}

@end
