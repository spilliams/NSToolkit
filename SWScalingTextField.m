//
//  SWScalingTextField.m
//
//  Created by Spencer Williams on 1/13/15.
//  This is free and unencumbered software released into the public domain.
//

#import "SWScalingTextField.h"

#define kDefaultMinimumPointSize 2

@interface SWScalingTextField ()
@property (strong) NSLayoutConstraint *widthLock;
@property (strong) NSLayoutConstraint *heightLock;
@property (strong) NSLayoutConstraint *aspectRatioLock;
@end

@implementation SWScalingTextField

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

- (BOOL)lockWidth {
    if (self.widthLock != nil
        || self.heightLock != nil
        || self.aspectRatioLock != nil) return NO;
    self.widthLock = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:self.frame.size.width];
    [self addConstraint:self.widthLock];
    return YES;
}
- (void)unlockWidth {
    [self removeConstraint:self.widthLock];
    self.widthLock = nil;
}
- (BOOL)lockHeight {
    if (self.widthLock != nil
        || self.heightLock != nil
        || self.aspectRatioLock != nil) return NO;
    self.heightLock = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:self.frame.size.height];
    [self addConstraint:self.heightLock];
    return YES;
}
- (void)unlockHeight {
    [self removeConstraint:self.heightLock];
    self.heightLock = nil;
}
- (BOOL)lockAspectRatio {
    if (self.widthLock != nil
        || self.heightLock != nil
        || self.aspectRatioLock != nil) return NO;
    CGFloat aspectRatio = self.frame.size.width / self.frame.size.height;
    self.aspectRatioLock = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:aspectRatio constant:0];
    [self addConstraint:self.aspectRatioLock];
    return YES;
}
- (void)unlockAspectRatio {
    [self removeConstraint:self.aspectRatioLock];
    self.aspectRatioLock = nil;
}

@end
