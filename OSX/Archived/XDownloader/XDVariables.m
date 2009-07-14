//
//  XDVariables.m
//  XDownloader
//
//  Created by Jakob Borg on 2005-06-25.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "XDVariables.h"
#import "Nym.Foundation/NymLogger.h"

@implementation XDVariables

- (XDVariables*) init {
	NFLog(@"init");
	[super init];
	variables = [[NSMutableDictionary alloc] init];

	[variables setObject:@"Canon" forKey:@"EquipmentMake"];
	[variables setObject:@"Canon EOS 10D" forKey:@"CameraModel"];
	[variables setObject:@"f/1.8" forKey:@"MaximumLensAperture"];
	[variables setObject:@"One-Chip Color Area" forKey:@"SensingMethod"];
	[variables setObject:@"Firmware Version 2.0.0" forKey:@"FirmwareVersion"];
	[variables setObject:@"0930304946" forKey:@"SerialNumber"];
	[variables setObject:@"Top, Left-Hand" forKey:@"ImageOrientation"];
	[variables setObject:@"180 dpi" forKey:@"HorizontalResolution"];
	[variables setObject:@"180 dpi" forKey:@"VerticalResolution"];
	[variables setObject:@"2004:01:17 18:14:20" forKey:@"ImageCreated"];
	[variables setObject:@"2004" forKey:@"Year"];
	[variables setObject:@"01" forKey:@"Month"];
	[variables setObject:@"17" forKey:@"Day"];
	[variables setObject:@"18" forKey:@"Hour"];
	[variables setObject:@"14" forKey:@"Minute"];
	[variables setObject:@"20" forKey:@"Second"];
	[variables setObject:@"1/160 sec" forKey:@"ExposureTime"];
	[variables setObject:@"f/3.2" forKey:@"F-Number"];
	[variables setObject:@"800" forKey:@"ISOSpeed Rating"];
	[variables setObject:@"f/3.2" forKey:@"LensAperture"];
	[variables setObject:@"0 EV" forKey:@"ExposureBias"];
	[variables setObject:@"No Flash" forKey:@"Flash"];
	[variables setObject:@"50.00 mm" forKey:@"FocalLength"];
	[variables setObject:@"sRGB" forKey:@"ColorSpaceInformation"];
	[variables setObject:@"160" forKey:@"ImageWidth"];
	[variables setObject:@"120" forKey:@"ImageHeight"];
	[variables setObject:@"Normal" forKey:@"Rendering"];
	[variables setObject:@"Auto" forKey:@"ExposureMode"];
	[variables setObject:@"Standard" forKey:@"SceneCaptureType"];
	[variables setObject:@"Program" forKey:@"ExposureMode"];
	[variables setObject:@"Auto" forKey:@"FocusType"];
	[variables setObject:@"Evaluative" forKey:@"MeteringMode"];
	[variables setObject:@"Normal" forKey:@"Sharpness"];
	[variables setObject:@"Normal" forKey:@"Saturation"];
	[variables setObject:@"Normal" forKey:@"Contrast"];
	[variables setObject:@"Manual" forKey:@"ShootingMode"];
	[variables setObject:@"Large" forKey:@"ImageSize"]; 
	[variables setObject:@"One-Shot" forKey:@"FocusMode"];
	[variables setObject:@"Continuous" forKey:@"DriveMode"];
	[variables setObject:@"Off" forKey:@"FlashMode"];
	[variables setObject:@"Unknown" forKey:@"CompressionSetting"];
	[variables setObject:@"Unknown" forKey:@"MacroMode"];
	[variables setObject:@"Custom" forKey:@"WhiteBalance"];
	[variables setObject:@"3" forKey:@"ExposureCompensation"];
	[variables setObject:@"256" forKey:@"SensorISOSpeed"];
	[variables setObject:@"106-0663" forKey:@"ImageNumber"];
	[variables setObject:@"i" forKey:@"ResolutionUnit"];
	[variables setObject:@"Centered" forKey:@"ChrominanceCompPositioning"];
	[variables setObject:@"196" forKey:@"ExifIFD Pointer"];
	[variables setObject:@"2.21" forKey:@"ExifVersion"];
	[variables setObject:@"2004:01:17 18:14:20" forKey:@"ImageGenerated"];
	[variables setObject:@"2004:01:17 18:14:20" forKey:@"ImageDigitized"];
	[variables setObject:@"Unknown" forKey:@"MeaningofEach Comp"];
	[variables setObject:@"9" forKey:@"ImageCompression Mode"];
	[variables setObject:@"1/160 sec" forKey:@"ShutterSpeed"];
	[variables setObject:@"Pattern" forKey:@"MeteringMode"];
	[variables setObject:@"3443 dpi" forKey:@"FocalPlaneHorizResolution"];
	[variables setObject:@"3442 dpi" forKey:@"FocalPlaneVertResolution"];
	[variables setObject:@"i" forKey:@"FocalPlane Res Unit"];
	[variables setObject:@"Digital Still Camera" forKey:@"FileSource"];
	[variables setObject:@"Manual" forKey:@"WhiteBalance"];
	[variables setObject:@"50.00 mm" forKey:@"LensSize"];
	[variables setObject:@"3072" forKey:@"BaseZoomResolution"];
	[variables setObject:@"3072" forKey:@"ZoomedResolution"];
	[variables setObject:@"Unknown" forKey:@"ISOSpeedRating"];
	[variables setObject:@"None" forKey:@"DigitalZoom"];
	[variables setObject:@"0 sec" forKey:@"Self-TimerLength"];
	[variables setObject:@"92" forKey:@"CanonTag1Length"];
	[variables setObject:@"Unknown" forKey:@"SubjectDistance"];
	[variables setObject:@"0.00 EV" forKey:@"FlashBias"];
	[variables setObject:@"0" forKey:@"SequenceNumber"];
	[variables setObject:@"66" forKey:@"CanonTag4Length"];
	[variables setObject:@"0" forKey:@"ActuationCounter"];
	[variables setObject:@"0" forKey:@"ActuationMultiplier"];
	[variables setObject:@"18" forKey:@"CanonTag93Length"];
	[variables setObject:@"CRW:EOS 10D CMOS RAW IMAGE" forKey:@"ImageType"];
	[variables setObject:@"Jakob Borg" forKey:@"OwnerName"];
	
	return self;
}

- (void) dealloc {
	NFLog(@"dealloc");
	[variables release];
	[super dealloc];
}

- (NSDictionary*) variablesDictionary {
	NFLog(@"variablesDictionary");
	return [NSDictionary dictionaryWithDictionary: variables];
}

-(id) tableView: (NSTableView*) aTableView
    objectValueForTableColumn: (NSTableColumn*) aTableColumn
	    row: (int) rowIndex
{
	NFAssert(aTableView);
	NFAssert(aTableColumn);
	NFAssertMsg(rowIndex >= 0, @"rowIndex !>= 0");

	NSArray* varnames = [[variables allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	NSString* ident = [aTableColumn identifier];
	NFAssert(ident);
	if ([ident compare: @"name"] == NSOrderedSame) {
		return [varnames objectAtIndex: rowIndex];
	} else if ([ident compare: @"value"] == NSOrderedSame) {
		return [variables objectForKey: [varnames objectAtIndex: rowIndex]];
	} else {
		NFLog(@"unknown tableView identifier: %@", ident);
		return nil;
	}
}

-(int) numberOfRowsInTableView: (NSTableView *) aTableView
{
	NFLog(@"numberOfRowsInTableView -> %d", [variables count]);
	return [variables count];
}

@end
