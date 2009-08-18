//
//  NameMapper.m
//  XDownloader
//
//  Created by Jakob Borg on 2005-05-26.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NameMapper.h"
#import "ExifWrapper.h"
#import "XDVariables.h"
#import "Nym.Foundation/NymLogger.h"

@implementation NameMapper
-(id) init {
	NFLog(@"init");
	[super init];
	mapping = [[NSMutableDictionary alloc] init];
	sourceNames = [[NSMutableArray alloc] init];
	return self;
}

-(void) dealloc {
	NFLog(@"dealloc");
	[mapping release];
	mapping = nil;
	[sourceNames release];
	sourceNames = nil;
	[super dealloc];
}

-(NSString*) postProcessName: (NSString*) source {
	NFLog(@"postProcessName");
	NFAssert(source);
	return source;
}

-(NSString*) remapName: (NSString*) source {
	NFLog(@"remapName");
	NFAssert(source);
	// Fetch EXIF data, replace fields in template with respective data.
	ExifWrapper* exif = [[ExifWrapper alloc] initWithFilename: source];
	NFAssert(exif);
	NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary: [exif exifFields]];
	NFAssert(dic);
NFAssertMsg([dic count] > 0, @"dic is empty");
	
	// Get our current preferences for paths and renaming template.
	id prefValues = [[NSUserDefaultsController sharedUserDefaultsController] values];
	NFAssert(prefValues);
	
	// Replace the string...
	NSMutableString* dest = [NSMutableString stringWithString: [prefValues valueForKey: @"renamingTemplate"]];
	NFAssert(dest);
	NSEnumerator* exifEnu = [dic keyEnumerator];
	NFAssert(exifEnu);
	NSString* fieldName;
	while (fieldName = [exifEnu nextObject]) {
		NFAssert(dest);
		NFAssert(fieldName);
		[dest replaceOccurrencesOfString:[NSString stringWithFormat:@"{%@}", fieldName] withString:[dic objectForKey: fieldName] options:0 range:NSMakeRange(0, [dest length])];
	}
	
	[exif release];
	exif = nil;
	NFLog(@"template '%@' for '%@' expanded to '%@'", [prefValues valueForKey: @"renamingTemplate"], source, dest);
	return [NSString stringWithString: dest];
}

-(NSString*) getExample: (NSString*) aTemplate {
	NFLog(@"getExample");

	NSMutableDictionary* dic = [[[XDVariables alloc] init] variablesDictionary];
	
	// Get our current preferences for paths and renaming template.
	id prefValues = [[NSUserDefaultsController sharedUserDefaultsController] values];
	NFAssert(prefValues);
	
	// Replace the string...
	NSMutableString* dest = [NSMutableString stringWithString: aTemplate];
	NFAssert(dest);
	NSEnumerator* exifEnu = [dic keyEnumerator];
	NFAssert(exifEnu);
	NSString* fieldName;
	while (fieldName = [exifEnu nextObject]) {
		NFAssert(dest);
		NFAssert(fieldName);
		[dest replaceOccurrencesOfString:[NSString stringWithFormat:@"{%@}", fieldName] withString:[dic objectForKey: fieldName] options:0 range:NSMakeRange(0, [dest length])];
	}
	
	NFLog(@"example expanded to '%@'", dest);
	return [NSString stringWithString: dest];
}


-(void) addSourceName: (NSString*) sourceName {
	NFLog(@"addSourceName");
	NFAssert(sourceName);
	NFAssert(sourceNames);
	[sourceNames addObject:sourceName];
	NFAssert(mapping);
	NSString* mappedName = [self remapName: sourceName];
	NFAssert(mappedName);
	mappedName = [self postProcessName: mappedName];
	NFAssert(mappedName);
	NSString* extension = [[sourceName pathExtension] lowercaseString];
	NFAssert(extension);
	id prefValues = [[NSUserDefaultsController sharedUserDefaultsController] values];
	if ([extension compare: @"thm"] == NSOrderedSame) {
		[mapping setValue:[NSString stringWithFormat:@"%@/%@.%@", [prefValues valueForKey:@"destinationDirectory"], mappedName, @"thm"] forKey:sourceName];
		NSString* sourceCrw = [NSString stringWithFormat:@"%@.%@", [sourceName substringWithRange: NSMakeRange(0, [sourceName length] - 4)], @"crw"];
		[mapping setValue:[NSString stringWithFormat:@"%@/%@.%@", [prefValues valueForKey:@"destinationDirectory"], mappedName, @"crw"] forKey:sourceCrw];
		[sourceNames addObject:sourceCrw];
	} else {
		[mapping setValue:[NSString stringWithFormat:@"%@/%@.%@", [prefValues valueForKey:@"destinationDirectory"], mappedName, extension] forKey:sourceName];
	}
}

-(NSDictionary*) getMappings {
	NFLog(@"getMappings");
	NFAssert(mapping);
	return mapping;
}

-(id) tableView: (NSTableView*) aTableView
    objectValueForTableColumn: (NSTableColumn*) aTableColumn
    row: (int) rowIndex
{
	NFAssert(aTableView);
	NFAssert(aTableColumn);
NFAssertMsg(rowIndex >= 0, @"rowIndex !>= 0");
	NSString* source = [sourceNames objectAtIndex:rowIndex];
	NFAssert(source);
	NSString* ident = [aTableColumn identifier];
	NFAssert(ident);
	if ([ident compare: @"source"] == NSOrderedSame) {
		return source;
	} else if ([ident compare: @"destination"] == NSOrderedSame) {
		NFAssert(mapping);
		return [mapping objectForKey: source];
	} else {
		NFLog(@"unknown tableView identifier: %@", ident);
		return nil;
	}
}

-(int) numberOfRowsInTableView: (NSTableView *) aTableView
{
//	NFAssert(aTableView);
	if (aTableView == nil)
		return 0;
	NFAssert(sourceNames);
	return [sourceNames count];
}
@end
