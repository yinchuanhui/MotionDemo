//
//  DeviceOrientationManager.h
//  MotionDemo
//
//  Created by ych on 15/6/25.
//  Copyright (c) 2015年 ych. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DeviceOrientationStatus_Unknown,//未知，下面四种状态之外的状态都是未知状态
    DeviceOrientationStatus_Landscape,//手机水平放置，屏幕与地面垂直
    DeviceOrientationStatus_LandscapeLeft,//屏幕与地面垂直，面对屏幕向左倾斜
    DeviceOrientationStatus_LandscapeRight,//屏幕与地面垂直，面对屏幕向右倾斜
    DeviceOrientationStatus_FaceUp,//屏幕向下
    DeviceOrientationStatus_Shake//晃动
}DeviceOrientationStatus;

@protocol DeviceOrientationManagerDelegate;

@interface DeviceOrientationManager : NSObject

- (instancetype)initWithDelegate:(id<DeviceOrientationManagerDelegate>)delegate;

@end


@protocol DeviceOrientationManagerDelegate <NSObject>

- (void)deviceOrientationDidChanged:(DeviceOrientationStatus)status;

@end