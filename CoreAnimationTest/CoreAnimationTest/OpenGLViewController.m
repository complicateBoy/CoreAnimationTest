//
//  OpenGLViewController.m
//  CoreAnimationTest
//
//  Created by 张帅 on 2019/2/22.
//  Copyright © 2019 ZS. All rights reserved.
//

#import "OpenGLViewController.h"
#import <CoreFoundation/CoreFoundation.h>

@interface OpenGLViewController ()

@end

@implementation OpenGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    label.text = @"修改内容 提交";
    label.textColor = [UIColor blueColor];
    [self.view addSubview:label];
      
}

- (void)testRunloop {
    
    int reply = 0;
    do {
        if (1+reply == 1) {
            reply = 1;
        }else if (1+reply == 2){
            reply = 0;
        }
        NSLog(@"---------------%d",reply);
    } while (reply == 0);
    
    CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

}

- (void)testTimer{
    
    UILabel *label = [[UILabel alloc] init];
    __block int sec = 0;
    __weak typeof(label) weakLabel = label;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        sec ++;
        weakLabel.text = [NSString stringWithFormat:@"%dS",sec];
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


@end
