//
//  CameraEditViewController.m
//  Axis Viewer
//
//  Created by Jakob Borg on 4/11/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "CameraEditViewController.h"

@implementation CameraEditViewController

@synthesize camera;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	keys = [NSArray arrayWithObjects:@"description", @"address", @"username", @"password", nil]; // @"framerate", nil];
	[keys retain];
	descriptions = [[NSMutableDictionary alloc] init];
	[descriptions setValue:@"Description" forKey:@"description"];
	[descriptions setValue:@"Address" forKey:@"address"];
	[descriptions setValue:@"User name" forKey:@"username"];
	[descriptions setValue:@"Password" forKey:@"password"];
	[descriptions setValue:@"Frame rate" forKey:@"framerate"];
	
	[self setEditing:YES];
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
	static NSString *CellIdentifier = @"EditCell";
	
	NSString* labelStr = @"";
	NSString* valueStr = @"";
	int row = [indexPath indexAtPosition:1];
	NSString* key = [keys objectAtIndex:row];
	labelStr = [descriptions valueForKey:key];
	valueStr = [camera valueForKey:key];
	
        UITableViewCell *cell; // = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	//      if (cell == nil) {
	int margin = 5;
	
	CGRect frame = CGRectMake(0, 0, 300, 44);
	cell = [[[UITableViewCell alloc] initWithFrame:frame reuseIdentifier:CellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	frame = CGRectInset(frame, margin, margin);
	int width = frame.size.width;
	frame.size.width = width / 3 - margin;
	
	UILabel *label;
	label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.text = labelStr;
	label.lineBreakMode = UILineBreakModeTailTruncation;
	label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
	[cell.contentView addSubview:label];
	
	frame.origin.x += width / 3 + margin;
	frame.size.width = width / 3 * 2 - margin;
	
	UITextField* value;
	value = [[[UITextField alloc] initWithFrame:frame] autorelease];
	value.text = valueStr;
	value.borderStyle = UITextBorderStyleNone;
	value.textColor = [UIColor darkGrayColor];
	value.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	value.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	value.delegate = self;
	value.tag = row;
	if ([key compare:@"password"] == 0) {
		[value setKeyboardType:UIKeyboardTypeDefault];
		[value setAutocorrectionType:UITextAutocorrectionTypeNo];
		[value setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[value setSecureTextEntry:YES];
	} else if ([key compare:@"description"] == 0) {
		[value setKeyboardType:UIKeyboardTypeDefault];
		[value setAutocorrectionType:UITextAutocorrectionTypeDefault];
		[value setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
	} else if ([key compare:@"address"] == 0) {
		[value setKeyboardType:UIKeyboardTypeURL];
		[value setAutocorrectionType:UITextAutocorrectionTypeNo];
		[value setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	} else {
		[value setKeyboardType:UIKeyboardTypeASCIICapable];
		[value setAutocorrectionType:UITextAutocorrectionTypeNo];
		[value setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	}
	[cell.contentView addSubview:value];
	
	//} else {
	//		((UILabel*) [cell.contentView.subviews objectAtIndex:0]).text = labelStr;
	//		((UILabel*) [cell.contentView.subviews objectAtIndex:1]).text = valueStr;
	//      }
	
	return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSString* key = [keys objectAtIndex:textField.tag];
	[camera setValue:textField.text forKey:key];
}

- (void)dealloc {
	[descriptions release];
	[keys release];
	[camera release];
	[super dealloc];
}

@end

