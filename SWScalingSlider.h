//
//  SWScaleSlider.h
//
//  Created by Spencer Williams on 12/31/14.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, SliderScaleType) {
    SliderScaleTypeLinear,
    SliderScaleTypeLog10,
    SliderScaleTypeLn,
    SliderScaleTypeLog2,
    SliderScaleTypeOther
};

/// This class is implemented to provide a slider that has a non-linear scale.
/// Mostly I was just pissed off that my other option is to use "tickmarks" to do my logarithming,
/// but what about the gradient?
@interface SWScalingSlider : NSSlider
@property (nonatomic, assign) SliderScaleType scaleType;
/// Set this property to a block that takes in 3 parameters: minimum, current and maximum values.
/// This block must return a float that is the scaled value of the current slider.
/// This property is not used for the specific SliderScaleTypes, only for SliderScaleTypeOther
@property (copy) float(^scale)(float minValue, float currentValue, float maxValue);
/// Use this to get the scaled float value
- (float)scaledFloatValue;
@end
