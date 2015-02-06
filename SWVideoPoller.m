//
//  SWVideoPoller.m
//  CurrentScience
//
//  Created by Spencer Williams on 2/6/15.
//  Copyright (c) 2015 Uncorked Studios. All rights reserved.
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
