//
//  CMSViewController.m
//  YJTimer
//
//  Created by 562925462@qq.com on 10/09/2021.
//  Copyright (c) 2021 562925462@qq.com. All rights reserved.
//

#import "CMSViewController.h"
#import <YJTimer/YJTimer.h>

@interface CMSViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YJTimer *timer;
@property (nonatomic, strong) dispatch_queue_t timerQueue;    /**< 定时器队列 */

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CMSViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    
   self.timer = [[YJTimer alloc] init];

    self.navigationItem.rightBarButtonItems = @[
        [[UIBarButtonItem alloc] initWithTitle:@"继续" style:(UIBarButtonItemStyleDone) target:self action:@selector(reumeTimer)],
        [[UIBarButtonItem alloc] initWithTitle:@"暂停" style:(UIBarButtonItemStyleDone) target:self action:@selector(suspendTimer)],
        [[UIBarButtonItem alloc] initWithTitle:@"停止" style:(UIBarButtonItemStyleDone) target:self action:@selector(stopTimer)],
        [[UIBarButtonItem alloc] initWithTitle:@"启动" style:(UIBarButtonItemStyleDone) target:self action:@selector(startTimer)]
                                               ];
}


- (void)reumeTimer {
    [self.timer resume];
}

- (void)suspendTimer {
    [self.timer suspend];
}
- (void)stopTimer {
    [self.timer stop];
}

- (void)startTimer {
    if ([self.timer isRunning]) {
        return;
    }
    const int timerInterval = 1000;
    [self.timer startWithStart:DISPATCH_TIME_NOW
                        timeInterval:timerInterval * NSEC_PER_MSEC
                               queue:self.timerQueue
                        eventHandler:^{
//        NSLog(@"定时器执行");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = [NSString stringWithFormat:@"%@", NSDate.new];
        });
        
                            
                        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld组, 第%ld行", indexPath.section, indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
@end
