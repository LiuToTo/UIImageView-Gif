//
//  ViewController.m
//  IMEGifView
//
//  Created by 刘ToTo on 2017/1/18.
//  Copyright © 2017年 刘ToTo. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+Gif.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *gif;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.gif &&self.gif.isGifPlaying) {
        [self.gif stopGIF];
    }else{
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"6.gif" ofType:nil];
        self.gif = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.gif];
        self.gif.animationRepeatCount = 1;
        self.gif.gifURL = [NSURL fileURLWithPath:path];
        [self.gif playGIFWithCompleted:^(BOOL finished) {
            NSLog(@"123");
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
