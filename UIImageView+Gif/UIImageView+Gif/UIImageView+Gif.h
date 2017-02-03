//
//  UIImageView+Gif.h
//  IMEGifView
//
//  Created by 刘ToTo on 2017/1/19.
//  Copyright © 2017年 刘ToTo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImageView (Gif)

@property (nonatomic, strong) NSURL *gifURL;
- (void)playGIF;
- (void)playGIFWithCompleted:(void(^)(BOOL finished))completed;
- (void)stopGIF;
- (BOOL)isGifPlaying;

@end
