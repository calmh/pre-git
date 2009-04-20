/*
 *  Common.h
 *  Axis Viewer
 *
 *  Created by Jakob Borg on 4/20/09.
 *  Copyright 2009 Jakob Borg. All rights reserved.
 *
 */

// #define ROUND_CORNERS_ON_SAVE
#define CORNER_RADIUS 32 // This is in relation to the saved im age size of 220x207 or something like that...
void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight);
UIImage *roundCornersOfImage(UIImage *source);

