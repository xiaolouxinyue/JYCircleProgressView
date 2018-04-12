//
//  JYCircleProgressView.m
//  JYCircleProgressView
//
//  Created by Jaym on 2018/4/12.
//  Copyright © 2018年 Auntec. All rights reserved.
//

#import "JYCircleProgressView.h"

@interface JYCircleProgressView ()

@property (strong, nonatomic) CAShapeLayer *frontShapeLayer;
@property (strong, nonatomic) CAShapeLayer *backShapeLayer;
@property (strong, nonatomic) UIBezierPath *circleBezierPath;
//渐变用
@property (nonatomic, strong) CAGradientLayer *gradLayer;

@end

@implementation JYCircleProgressView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


#pragma mark - Setup

- (void)setup {

    self.backgroundColor = [UIColor clearColor];
    self.trackLineWidth = 4.0;
    self.trackLineColor = [UIColor lightGrayColor];
    self.progressLineWidth = 4.0;
    self.progressLineColor = [UIColor orangeColor];
    self.progressColorArray = @[(id)[UIColor orangeColor].CGColor, (id)[UIColor greenColor].CGColor];
    self.progress = 0.5f;
    [self setGradual:YES];
}


#pragma mark - Setters

- (void)setGradual:(BOOL)gradual{
    _gradual = gradual;
    if (gradual) {
        [self.frontShapeLayer removeFromSuperlayer];
        self.frontShapeLayer = nil;
    }else{
        [_gradLayer removeFromSuperlayer];
        _gradLayer = nil;
        [self.frontShapeLayer removeFromSuperlayer];
        self.frontShapeLayer = nil;
    }
}

- (void)setProgress:(CGFloat)progress{
    NSAssert(progress >= 0 && progress <=1, @"超出范围");
    _progress = progress;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    
    CGFloat kWidth = rect.size.width;
    CGFloat kHeight = rect.size.height;
    
    if (!self.circleBezierPath){
        self.circleBezierPath = ({
            CGPoint pCenter = CGPointMake(kWidth * 0.5, kHeight * 0.5);
            CGFloat radius = MIN(kWidth, kHeight);
            radius = radius - self.progressLineWidth;
            UIBezierPath *circlePath = [UIBezierPath bezierPath];
            [circlePath addArcWithCenter:pCenter radius:radius * 0.5 startAngle:270 * M_PI / 180 endAngle:269 * M_PI / 180 clockwise:YES];
            [circlePath closePath];
            circlePath;
        });
    }
    if (!self.backShapeLayer) {
        self.backShapeLayer = ({
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.frame = rect;
            shapeLayer.path = self.circleBezierPath.CGPath;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.lineWidth = self.trackLineWidth;
            shapeLayer.strokeColor = self.trackLineColor.CGColor;
            shapeLayer.lineCap = kCALineCapRound;
            [self.layer addSublayer:shapeLayer];
            shapeLayer;
        });
    }
    
    if (!self.frontShapeLayer){
        self.frontShapeLayer = ({
            CAShapeLayer  *shapeLayer = [CAShapeLayer layer];
            shapeLayer.frame = rect;
            shapeLayer.path = self.circleBezierPath.CGPath;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.lineWidth = self.progressLineWidth;
            shapeLayer.strokeColor = self.progressLineColor.CGColor;
            shapeLayer;
        });
        if (self.gradual) {
            [self addGradLayerWithRect:rect];
            self.frontShapeLayer.lineCap = kCALineCapRound;
            _gradLayer.mask = self.frontShapeLayer;
            [self.layer addSublayer:_gradLayer];
        }else{
            [self.layer addSublayer:self.frontShapeLayer];
        }
    }
    [self startAnimationValue:self.progress];
}

- (void)addGradLayerWithRect:(CGRect)rect{
    CGFloat kHeight = rect.size.height;
    CGRect viewRect = CGRectMake(0, 0, kHeight, kHeight);
    _gradLayer = ({
        CAGradientLayer *gradLayer = [CAGradientLayer layer];
        gradLayer.bounds = viewRect;
        [gradLayer setColors:self.progressColorArray];
        gradLayer.position = CGPointMake(gradLayer.bounds.size.width/2, gradLayer.bounds.size.height/2);
        gradLayer.startPoint = CGPointMake(1, 0);
        gradLayer.endPoint = CGPointMake(0, 1);
        gradLayer;
    });
}

- (void)startAnimationValue:(CGFloat)value{
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 1.0f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:value];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [self.frontShapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
}

@end
