//
//  AxisCamera.h
//  Axis Viewer
//
//  Created by Jakob Borg on 4/23/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AxisCamera : NSObject {
        NSDictionary *camera;
        NSMutableDictionary *parameters;
        id delegate;
}

- (NSString*)createCameraURL;
- (AxisCamera*)initWithCamera:(NSDictionary*)icamera;
- (NSString*)parameterForKey:(NSString*)key;
- (int)numParameters;
- (void)takeSnapshotInBackground;
- (void)savePreviewInBackground;
- (BOOL)savePreviewSynchronous;
- (void)getParametersInBackground;

@property (nonatomic, assign) id delegate;

@end

@interface NSObject (AxisCameraDelegate)

- (void)axisCameraParametersUpdated:(AxisCamera*)camera;
- (void)axisCameraParametersFailed:(AxisCamera*)camera;
- (void)axisCameraPreviewUpdated:(AxisCamera*)camera;
- (void)axisCameraSnapshotTaken:(AxisCamera*)camera;

@end
