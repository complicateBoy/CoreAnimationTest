//
//  OpenGLViewController.m
//  CoreAnimationTest
//
//  Created by 张帅 on 2019/2/22.
//  Copyright © 2019 ZS. All rights reserved.
//

#import "OpenGLViewController.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
