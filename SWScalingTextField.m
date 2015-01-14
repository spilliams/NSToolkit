//
//  SWScalingTextField.m
//
//  Created by Spencer Williams on 1/13/15.
//  This is free and unencumbered software released into the public domain.
//

#import "SWScalingTextField.h"
#import "NSString+SizeHelpers.h"

#define kDefaultMinimumPointSize 2
#define LOG YES

#define AreaOfRect(r) (r.size.width*r.size.height)

@interface SWScalingTextField ()
@property (strong) NSLayoutConstraint *aspectRatioLock;
@end

@implementation SWScalingTextField

#pragma mark - Initialize

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
    self.minimumPointSize = kDefaultMinimumPointSize;
}

#pragma mark - Draw

- (void)drawRect:(NSRect)dirtyRect {
    NSLog(@"[STF] draw rect: %@, current frame: %@, current point size: %.2f", NSStringFromRect(dirtyRect), NSStringFromRect(self.frame), self.font.pointSize);
    
    // We want to change self's font with a font of the same name and a new size,
    // such that a string with that font would not overflow the dirtyRect's bounds.
    // We want to pick the maximum point size that meets this condition.
    CGFloat newPointSize = [self.stringValue largestPointSizeThatFitsSize:dirtyRect.size withFont:self.font minimumPointSize:self.minimumPointSize];
    if (newPointSize != self.font.pointSize) {
        self.font = [NSFont fontWithName:self.font.fontName size:newPointSize];
        if (self.scalingDelegate
            && [self.scalingDelegate respondsToSelector:@selector(scalingTextField:changedFontToPointSize:)]) {
            [self.scalingDelegate scalingTextField:self changedFontToPointSize:newPointSize];
        }
    }
    
    [super drawRect:dirtyRect];
}

#pragma mark - Lock

- (BOOL)lockAspectRatio {
    if (self.aspectRatioLock != nil) return NO;
    
    if (LOG) NSLog(@"[STF] locking aspect ratio");
    CGFloat aspectRatio = self.frame.size.width / self.frame.size.height;
    self.aspectRatioLock = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:aspectRatio constant:0];
    [self addConstraint:self.aspectRatioLock];
    return YES;
}
- (void)unlockAspectRatio {
    if (LOG) NSLog(@"[STF] unlocking aspect ratio");
    [self removeConstraint:self.aspectRatioLock];
    self.aspectRatioLock = nil;
}

@end
