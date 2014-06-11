//
//  ViewController.m
//  AccelerometerTest
//
//  Created by Mason Silber on 5/31/14.
//  Copyright (c) 2014 MasonSilber. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) UIView *containerView;
@property (nonatomic) UIView *fluidView;

@property (nonatomic) UIGravityBehavior *gravityBehavior;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic) UIDynamicAnimator *animator;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    self.containerView.center = self.view.center;
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.borderWidth = 2.0f;
    self.containerView.clipsToBounds = YES;
    [self.view addSubview:self.containerView];

    self.fluidView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 300.0f)];
    self.fluidView.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:151.0f/255.0f blue:76.0f/255.0f alpha:1.0f];
    self.fluidView.center = CGPointMake(50.0f, 200.0f);
    [self.containerView addSubview:self.fluidView];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.containerView];

    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.fluidView]];

    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.fluidView offsetFromCenter:UIOffsetMake(0.0f, -1.0f * CGRectGetHeight(self.fluidView.frame) / 2.0f) attachedToAnchor:CGPointMake(CGRectGetWidth(self.containerView.frame) / 2.0f, (CGRectGetHeight(self.containerView.frame) / 2.0f) - 10.0f)];
    self.attachmentBehavior.length = 10.0f;
    self.attachmentBehavior.damping = 0.5f;

    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.fluidView]];
    self.itemBehavior.angularResistance = 10.0f;

    [self.animator addBehavior:self.attachmentBehavior];

    self.motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.accelerometerAvailable) {
        __weak typeof(self) weakSelf = self;
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            typeof(self) strongSelf = weakSelf;
//            NSLog(@"%f, %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y);

            //                        x: 0.0f, y: -1.0f
            //     x: -1.0f, y: 0.0f                     x: 1.0f, y: 0.0f
            //                        x: 0.0f, y: 1.0f

            // Factor of 10 is to pull down on liquid much more strongly than horizontal forces
            strongSelf.gravityBehavior.gravityDirection = CGVectorMake(accelerometerData.acceleration.x, 10 * fabsf(accelerometerData.acceleration.y));
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.gravityBehavior.gravityDirection = CGVectorMake(0.0f, -1.0f);
    [self.animator addBehavior:self.gravityBehavior];
}

@end
