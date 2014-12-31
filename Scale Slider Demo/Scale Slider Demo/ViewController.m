//
//  ViewController.m
//  Scale Slider Demo
//
//  Created by Spencer Williams on 12/31/14.
//  Copyright (c) 2014 Spencer Williams. All rights reserved.
//

#import "ViewController.h"
#import "SWScalingSlider.h"

@interface ViewController()
@property (weak) IBOutlet NSTextField *minLabelLinear;
@property (weak) IBOutlet SWScalingSlider *sliderLinear;
@property (weak) IBOutlet NSTextField *scaledLabelLinear;
@property (weak) IBOutlet NSTextField *maxLabelLinear;

@property (weak) IBOutlet NSTextField *minLabelLog2;
@property (weak) IBOutlet SWScalingSlider *sliderLog2;
@property (weak) IBOutlet NSTextField *scaledlabelLog2;
@property (weak) IBOutlet NSTextField *maxLabelLog2;

@property (weak) IBOutlet NSTextField *minLabelLogE;
@property (weak) IBOutlet SWScalingSlider *sliderLogE;
@property (weak) IBOutlet NSTextField *scaledLabelLogE;
@property (weak) IBOutlet NSTextField *maxLabelLogE;

@property (weak) IBOutlet NSTextField *minLabelLog10;
@property (weak) IBOutlet SWScalingSlider *sliderLog10;
@property (weak) IBOutlet NSTextField *scaledLabelLog10;
@property (weak) IBOutlet NSTextField *maxLabelLog10;

@property (weak) IBOutlet NSTextField *minLabelOther;
@property (weak) IBOutlet SWScalingSlider *sliderOther;
@property (weak) IBOutlet NSTextField *scaledLabelOther;
@property (weak) IBOutlet NSTextField *maxLabelOther;

- (IBAction)sliderValueChanged:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.sliderLog2 setScaleType:SliderScaleTypeLog2];
    [self.sliderLogE setScaleType:SliderScaleTypeLn];
    [self.sliderLog10 setScaleType:SliderScaleTypeLog10];
    [self.sliderOther setScaleType:SliderScaleTypeOther];
    [self.sliderOther setScale:^float(float minValue, float currentValue, float maxValue) {
        return sinf(currentValue);
    }];
    
    [self.minLabelLinear setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLinear.minValue]];
    [self.maxLabelLinear setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLinear.maxValue]];
    
    [self.minLabelLog2 setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLog2.minValue]];
    [self.maxLabelLog2 setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLog2.maxValue]];
    
    [self.minLabelLogE setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLogE.minValue]];
    [self.maxLabelLogE setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLogE.maxValue]];
    
    [self.minLabelLog10 setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLog10.minValue]];
    [self.maxLabelLog10 setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLog10.maxValue]];
    
    [self.minLabelOther setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderOther.minValue]];
    [self.maxLabelOther setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderOther.maxValue]];
    
    [self updateScaledLabels];
}

- (void)updateScaledLabels {
    [self.scaledLabelLinear setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLinear.scaledFloatValue]];
    [self.scaledlabelLog2 setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLog2.scaledFloatValue]];
    [self.scaledLabelLogE setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLogE.scaledFloatValue]];
    [self.scaledLabelLog10 setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderLog10.scaledFloatValue]];
    [self.scaledLabelOther setStringValue:[NSString stringWithFormat:@"%.2f", self.sliderOther.scaledFloatValue]];
}
- (IBAction)sliderValueChanged:(id)sender {
    [self updateScaledLabels];
}
@end
