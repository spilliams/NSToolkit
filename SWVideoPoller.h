//
//  SWVideoPoller.h
//
//  Created by Spencer Williams on 2/6/15.
//  This is free and unencumbered software released into the public domain.
//

#import "SWPoller.h"

/// A video poller is for polling an instance of AVPlayer.
/// It doesn't use its action, rather it checks its target's `rate` and `currentTime` directly.
/// Currently the poller triggers when the video is halted, or otherwise stops playing.
@interface SWVideoPoller : SWPoller

@end
