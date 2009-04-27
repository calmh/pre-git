//
//  AxisCamera.h
//  Axis Viewer
//
//  Created by Jakob Borg on 4/23/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AVAxisCamera : NSObject {
        NSDictionary *camera;
        NSMutableDictionary *parameters;
        id delegate;
}

- (NSString*)baseURL;
- (AVAxisCamera*)initWithCamera:(NSDictionary*)icamera;
- (NSString*)parameterForKey:(NSString*)key;
- (int)numParameters;
- (void)takeSnapshotInBackground;
- (void)savePreviewInBackground;
- (BOOL)savePreviewSynchronous;
- (void)getParametersInBackground;

@property (nonatomic, assign) id delegate;

@end

@interface NSObject (AxisCameraDelegate)

- (void)axisCameraParametersUpdated:(AVAxisCamera*)camera;
- (void)axisCameraParametersFailed:(AVAxisCamera*)camera;
- (void)axisCameraPreviewUpdated:(AVAxisCamera*)camera;
- (void)axisCameraSnapshotTaken:(AVAxisCamera*)camera;

@end
