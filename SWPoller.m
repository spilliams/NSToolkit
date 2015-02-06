//
//  SWPoller.m
//  CurrentScience
//
//  Created by Spencer Williams on 2/5/15.
//  This is free and unencumbered software released into the public domain.
//

#import "SWPoller.h"
#import "SWPoller(Protected).h"

@interface SWPoller () {
    BOOL currentlyPolling;
    BOOL staaaahp;
}

@end

@implementation SWPoller

- (instancetype)init {
    if (self = [super init]) {
        self.stopPollingWhenTriggered = YES;
        self.period = 1;
    }
    return self;
}

- (void)pollOnce {
    NSLog(@"[Poller] pollOnce");
    if (staaaahp) return;
    currentlyPolling = YES;
    
    // You may want to put asserts in your subclass's implementation of pollOnce
//    NSAssert(self.target != nil, @"Poller target may not be nil");
//    NSAssert(self.action != nil, @"Poller action may not be nil");
//    NSAssert([self.target respondsToSelector:self.action], @"Poller's target must respond to poller's action");
    
    // And maybe your target's action requires an object?
//    id object = nil;
//    if (self.delegate
//        && [self.delegate respondsToSelector:@selector(objectForPoller:)]) {
//        object = [self.delegate objectForPoller:self];
//    }
    
    BOOL triggered = [self pollTriggered];
    
    if (triggered && self.stopPollingWhenTriggered) {
        NSLog(@"[Poller] triggered and auto-stopping");
        [self stopPolling];
    } else {
        __weak __typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.period * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf pollOnce];
        });
    }
}

- (void)startPolling {
    NSLog(@"[Poller] starting");
    staaaahp = NO;
    [self pollOnce];
}
- (BOOL)currentlyPolling {
    return currentlyPolling;
}
- (void)stopPolling {
    NSLog(@"[Poller] stopping");
    staaaahp = YES;
    currentlyPolling = NO;
}

- (BOOL)pollTriggered {
    NSAssert(NO, @"Implement this in a subclass!");
    
    // Since we can't get return value from a `performSelector` call,
    // the recommendd implementation here is with NSInvocation
//    NSInvocation *poll = [NSInvocation invocationWithMethodSignature:[[self.target class] instanceMethodSignatureForSelector:self.action]];
//    [poll setTarget:self.target];
//    [poll setSelector:self.action];
//    [poll invoke];
//    NSValue *returnValue;
//    [poll getReturnValue:&returnValue];
    
    return NO;
}
@end
