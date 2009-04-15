//
//  CameraEditViewController.m
//  Axis Viewer
//
//  Created by Jakob Borg on 4/11/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "CameraEditViewController.h"
#import "EditingCell.h"

@implementation CameraEditViewController

@synthesize camera;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	keys = [NSArray arrayWithObjects:@"description", @"address", @"username", @"password", nil]; // @"framerate", nil];
	[keys retain];
	descriptions = [[NSMutableDictionary alloc] init];
	[descriptions setValue:@"Description:" forKey:@"description"];
	[descriptions setValue:@"Address:" forKey:@"address"];
	[descriptions setValue:@"User name:" forKey:@"username"];
	[descriptions setValue:@"Password:" forKey:@"password"];
	
	[self setEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(keyboardWillShow:)
	 name:UIKeyboardWillShowNotification
         object:nil];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(keyboardWillHide:)
	 name:UIKeyboardWillHideNotification
         object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [keys count];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *identifier = @"EditingCell";
	NSString* labelStr = @"";
	NSString* valueStr = @"";
	int row = [indexPath indexAtPosition:1];
	NSString* key = [keys objectAtIndex:row];
	labelStr = [descriptions valueForKey:key];
	valueStr = [camera valueForKey:key];
	
	EditingCell *cell=  (EditingCell*) [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) { 
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
		for (id object in nib) {
			if ([object isKindOfClass:[EditingCell class]])
				cell = (EditingCell *)object;
		}
		cell.value.delegate = self;
	}
	
	cell.prompt.text = labelStr;
	cell.value.text = valueStr;
	cell.value.tag = row;
	if ([key compare:@"password"] == 0) {
		[cell.value setKeyboardType:UIKeyboardTypeDefault];
		[cell.value setAutocorrectionType:UITextAutocorrectionTypeNo];
		[cell.value setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[cell.value setSecureTextEntry:YES];
		[cell.value setPlaceholder:@"password"];
	} else if ([key compare:@"description"] == 0) {
		[cell.value setKeyboardType:UIKeyboardTypeDefault];
		[cell.value setAutocorrectionType:UITextAutocorrectionTypeDefault];
		[cell.value setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
		[cell.value setPlaceholder:@"A description"];
	} else if ([key compare:@"address"] == 0) {
		[cell.value setKeyboardType:UIKeyboardTypeURL];
		[cell.value setAutocorrectionType:UITextAutocorrectionTypeNo];
		[cell.value setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[cell.value setPlaceholder:@"cam.example.com"];
	} else if ([key compare:@"username"] == 0) {
		[cell.value setKeyboardType:UIKeyboardTypeASCIICapable];
		[cell.value setAutocorrectionType:UITextAutocorrectionTypeNo];
		[cell.value setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[cell.value setPlaceholder:@"user"];
	}
	
	return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSString* key = [keys objectAtIndex:textField.tag];
	[camera setValue:textField.text forKey:key];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return @"Basic Settings";
	else
		return nil;
}

- (void)keyboardWillShow:(NSNotification *)note
{
	CGRect keyboardBounds;
	[[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
	int keyboardHeight = keyboardBounds.size.height;
	if (keyboardIsShowing == NO)
	{
		keyboardIsShowing = YES;
		CGRect frame = self.view.frame;
		frame.size.height -= keyboardHeight;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		self.view.frame = frame;
		[UIView commitAnimations];
	}
}

- (void)keyboardWillHide:(NSNotification *)note
{
	CGRect keyboardBounds;
	[[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
	int keyboardHeight = keyboardBounds.size.height;
	if (keyboardIsShowing == YES)
	{
		keyboardIsShowing = NO;
		CGRect frame = self.view.frame;
		frame.size.height += keyboardHeight;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		self.view.frame = frame;
		[UIView commitAnimations];
	}
}

- (void)dealloc {
	[descriptions release];
	[keys release];
	[camera release];
	[super dealloc];
}

@end

