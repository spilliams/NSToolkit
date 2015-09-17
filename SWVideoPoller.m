//
//  SWVideoPoller.m
//
//  Created by Spencer Williams on 2/6/15.
//  This is free and unencumbered software released into the public domain.
//

#import "SWVideoPoller.h"
#import "SWPoller(Protected).h"
#import <AVFoundation/AVFoundation.h>

@interface SWVideoPoller () {
    CMTime lastPolledTime;
}
@end

@implementation SWVideoPoller

- (void)pollOnce {
    NSAssert([self.target isKindOfClass:[AVPlayer class]], @"Target of a video poller must be an AVPlayer");
    
    [super pollOnce];
}

- (BOOL)pollTriggered {
    CMTime time = ((AVPlayer *)self.target).currentTime;
    if (CMTIME_COMPARE_INLINE(time, ==, lastPolledTime)) {
        return YES;
    }
    lastPolledTime = time;
    return NO;
}
@end
