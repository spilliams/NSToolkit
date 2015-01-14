//
//  SWScaleSlider.m
//
//  Created by Spencer Williams on 12/31/14.
//

#import "SWScalingSlider.h"
#import <math.h>

@implementation SWScalingSlider

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    self.scaleType = SliderScaleTypeLinear;
}

- (float)scaledFloatValue
{
    switch (self.scaleType) {
        case SliderScaleTypeLinear:
            return self.floatValue;
            break;
        case SliderScaleTypeLog2:
            return [self logX:self.floatValue base:2];
            break;
        case SliderScaleTypeLn:
            return [self logX:self.floatValue base:M_E];
            break;
        case SliderScaleTypeLog10:
            return log10f(self.floatValue);
            break;
        case SliderScaleTypeOther:
            return self.scale(self.minValue, self.floatValue, self.maxValue);
            break;
    }
    return 0;
}

- (float)logX:(float)value base:(float)base {
    return log10f(value) / log10f(base);
}

@end
