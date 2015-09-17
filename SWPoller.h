//
//  SWPoller.h
//
//  Created by Spencer Williams on 2/5/15.
//  This is free and unencumbered software released into the public domain.
//

#import <Foundation/Foundation.h>

@class SWPoller;
@protocol SWPollerDelegate <NSObject>
- (void)pollerTriggered:(SWPoller *)poller;
@optional
/// Delegates should implement this method if the pollee's action requires an object argument
- (id)objectForPoller:(SWPoller *)poller;
@end

@interface SWPoller : NSObject
@property (weak) id<SWPollerDelegate> delegate;
/// The number of seconds between each poll event. Defaults to 1.
@property (assign) NSTimeInterval period;
/// Whether or not to stop polling when triggered. Defaults to YES.
@property (assign) BOOL stopPollingWhenTriggered;
/// The object to ask about the trigger
@property (weak) id target;
/// The action to send to the target
@property (assign) SEL action;
/// When the target's action returns this value, this poller will be Triggered.
@property (strong) NSValue *trigger;

- (void)startPolling;
- (BOOL)currentlyPolling;
- (void)stopPolling;
@end
