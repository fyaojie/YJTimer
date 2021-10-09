//
//  YJTimer.m
//  YJTimer
//
//  Created by symbio on 2021/10/9.
//

#import "YJTimer.h"

#define YJWeakSelf(type)  __weak typeof(type) weak##type = type;
#define YJStrongSelf(type)  __strong typeof(type) type = weak##type;

@interface YJTimer ()
@property (nonatomic, strong) dispatch_source_t dispatchTimer;

@property (nonatomic, assign, getter=isRunning) BOOL running;

@property (nonatomic, strong) dispatch_queue_t timerOperationQueue;

@end

@implementation YJTimer

- (BOOL)isRunning {
    return _running;
}

- (instancetype)init {
    if (self = [super init]) {
        self.timerOperationQueue = dispatch_queue_create("com.timeroperationqueue.bonree", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)startWithStart:(dispatch_time_t)start
          timeInterval:(uint64_t)interval
                 queue:(dispatch_queue_t)queue
          eventHandler:(void (^)(void))eventHandler {
    
    //    NSAssert(self.dispatchTimer == nil, @"Timer 尚未停止,不可重复调用 start");
        
    dispatch_sync(self.timerOperationQueue, ^{
        
        if (!self.dispatchTimer) {
            self.dispatchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            
            dispatch_source_set_timer(self.dispatchTimer, start, interval, 0);
            
            dispatch_source_set_event_handler(self.dispatchTimer, ^{
                if (eventHandler) eventHandler();
            });
            
            YJWeakSelf(self)
            dispatch_source_set_cancel_handler(self.dispatchTimer, ^{
                YJStrongSelf(self)
                self.dispatchTimer = nil;
            });
            
        }
        
        if (self.isRunning || self.isDispatchCancel) {
            return;
        }
        
        self.running = YES;
        dispatch_resume(self.dispatchTimer);
        
    });
}

- (void)resume {
    
    dispatch_sync(self.timerOperationQueue, ^{
        if (!self.dispatchTimer || self.isRunning || self.isDispatchCancel) {
            return;
        }
        self.running = YES;
        dispatch_resume(self.dispatchTimer);
    });
}

- (void)suspend {
    
    dispatch_sync(self.timerOperationQueue, ^{
        if (!self.dispatchTimer || !self.isRunning || self.isDispatchCancel) {
            return;
        }
        self.running = NO;
        dispatch_suspend(self.dispatchTimer);
    });
}

- (void)stop {
    dispatch_sync(self.timerOperationQueue, ^{
        
        if (!self.dispatchTimer || self.isDispatchCancel) {
            return;
        }
        if (!self.isRunning) {
            dispatch_resume(self.dispatchTimer);
        }
        self.running = NO;
        dispatch_source_cancel(self.dispatchTimer);
    });
}

- (BOOL)isDispatchCancel {
    if (self.dispatchTimer) {
        return dispatch_source_testcancel(self.dispatchTimer) ? YES : NO;
    }
    return YES;
}

- (void)dealloc {
    //定时器存在且没有运行且未被取消 -> suspend 状态
    //需要 resume 不然会 crash
    if (self.dispatchTimer && !self.isRunning && !self.isDispatchCancel) {
        dispatch_resume(self.dispatchTimer);
    }
}
@end
