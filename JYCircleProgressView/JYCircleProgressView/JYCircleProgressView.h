//
//  JYCircleProgressView.h
//  JYCircleProgressView
//
//  Created by Jaym on 2018/4/12.
//  Copyright © 2018年 Auntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYCircleProgressView : UIView

@property (nonatomic, assign) NSInteger trackLineWidth;
@property (nonatomic, strong) UIColor *trackLineColor;

@property (nonatomic, assign) NSInteger progressLineWidth;
@property (nonatomic, strong) UIColor *progressLineColor;

@property (nonatomic, copy) NSArray *progressColorArray;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign,getter=isGradual) BOOL gradual;


/**
 @param gradual 开启渐变,默认关闭;
 */
- (void)setGradual:(BOOL)gradual;
/**
 @param progress 进度 [0,1],默认开启
 */
- (void)setProgress:(CGFloat)progress;

@end
