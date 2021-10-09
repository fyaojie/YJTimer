//
//  YJTimer.h
//  YJTimer
//
//  Created by symbio on 2021/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJTimer : NSObject


/// 定时器开启
/// @param start 开启时间, 立即启动 DISPATCH_TIME_NOW
/// @param interval 定时器执行间隔, 每1000ms执行一次(1000 * NSEC_PER_MSEC)
/// @param queue 执行队列
/// @param eventHandler 执行回调
- (void)startWithStart:(dispatch_time_t)start
          timeInterval:(uint64_t)interval
                 queue:(dispatch_queue_t)queue
          eventHandler:(void (^)(void))eventHandler;

/// 继续执行
- (void)resume;

/// 暂停执行
- (void)suspend;

/// 停止定时器
- (void)stop;

/// 是否正在运行
- (BOOL)isRunning;

@end

NS_ASSUME_NONNULL_END
