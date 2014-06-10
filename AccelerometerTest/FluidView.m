//
//  View.m
//  AccelerometerTest
//
//  Created by Mason Silber on 6/8/14.
//  Copyright (c) 2014 MasonSilber. All rights reserved.
//

#import "FluidView.h"

@implementation FluidView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:151.0f/255.0f blue:76.0f/255.0f alpha:1.0f];
    }
    return self;
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
//    self.layer.anchorPoint = center;
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    [[UIColor redColor] set];
//    
//    /*
//    Accelerometer values when plane of the screen is vertical
//    and facing you:
//     
//                        x: 0.0f, y: -1.0f
//     x: -1.0f, y: 0.0f                     x: 1.0f, y: 0.0f
//                        x: 0.0f, y: 1.0f
//     */
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // First two lines (bottom two points) always stay the same, as they're the anchor points
//    CGContextMoveToPoint(context, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
//    CGContextAddLineToPoint(context, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds));
//    
//    // The next four lines (dealing with the top two points of the shape) change based on acceleration
//    CGFloat leftAnchor = MAX(0.0f, MIN(CGRectGetMaxY(self.bounds), (1 + self.xAcceleration) * CGRectGetMidY(self.bounds)));
//    CGContextAddLineToPoint(context, CGRectGetMinX(self.bounds), leftAnchor);
//    
//    CGFloat rightAnchor = MAX(0.0f, MIN(CGRectGetMaxY(self.bounds), (1 - self.xAcceleration) * CGRectGetMidY(self.bounds)));
//    CGContextAddLineToPoint(context, CGRectGetMaxX(self.bounds), rightAnchor);
//    
//    CGContextClosePath(context);
//    CGContextFillPath(context);
//}

@end
