//
//  DeviceOrientationManager.m
//  MotionDemo
//
//  Created by ych on 15/6/25.
//  Copyright (c) 2015年 ych. All rights reserved.
//

#import "DeviceOrientationManager.h"
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

#define GravityBalance 0.3f
#define AccelerometerRate 1.5f

@interface DeviceOrientationManager ()

@property (nonatomic, weak)id<DeviceOrientationManagerDelegate>delegate;
@property (nonatomic, assign)DeviceOrientationStatus currentOrientation;
@property (nonatomic, strong)CMMotionManager *motionManager;

@end

@implementation DeviceOrientationManager

- (instancetype)initWithDelegate:(id<DeviceOrientationManagerDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
        self.currentOrientation = DeviceOrientationStatus_UnInit;
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 0.1;
        [self.motionManager startDeviceMotionUpdates];
        
        __weak typeof(self) weakSelf = self;
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            double accelerometerX = accelerometerData.acceleration.x;
            double accelerometerY = accelerometerData.acceleration.y;
            double accelerometerZ = accelerometerData.acceleration.z;
            double gravityX = weakSelf.motionManager.deviceMotion.gravity.x;
            double gravityY = weakSelf.motionManager.deviceMotion.gravity.y;
            double gravityZ = weakSelf.motionManager.deviceMotion.gravity.z;
            
            DeviceOrientationStatus orientation = weakSelf.currentOrientation;
            
            if (fabs(gravityX)+GravityBalance > 1.0f && fabs(gravityY) < GravityBalance && fabs(gravityZ) < GravityBalance) {
                orientation = DeviceOrientationStatus_Landscape;
            }
            else if (fabs(gravityX)+GravityBalance > 1.0f && fabs(gravityY) > GravityBalance && fabs(gravityZ) < GravityBalance) {
                //gravityX大于0代表面朝设备，home键在左侧；gravityX小于0代表面朝设备，home键在右侧
                if (gravityX > 0) {
                    if (gravityY < 0) {
                        orientation = DeviceOrientationStatus_LandscapeLeft;
                    }else{
                        orientation = DeviceOrientationStatus_LandscapeRight;
                    }
                }else{
                    if (gravityY < 0) {
                        orientation = DeviceOrientationStatus_LandscapeRight;
                    }else{
                        orientation = DeviceOrientationStatus_LandscapeLeft;
                    }
                }
            }
            else if (fabs(gravityX) < GravityBalance && fabs(gravityY) < GravityBalance && gravityZ+GravityBalance > 1.0f) {
                orientation = DeviceOrientationStatus_FaceUp;
            }
            else{
                if (fabs(accelerometerX) > AccelerometerRate || fabs(accelerometerY) > AccelerometerRate || fabs(accelerometerZ) > AccelerometerRate) {
                    orientation = DeviceOrientationStatus_Shake;
                }else{
                    orientation = DeviceOrientationStatus_Unknown;
                }
            }
            
            if (self.currentOrientation != orientation) {
                self.currentOrientation = orientation;
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(deviceOrientationDidChanged:)]) {
                    [weakSelf.delegate deviceOrientationDidChanged:orientation];
                }
            }
        }];
    }
    return self;
}

- (void)dealloc{
    [self.motionManager stopMagnetometerUpdates];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
