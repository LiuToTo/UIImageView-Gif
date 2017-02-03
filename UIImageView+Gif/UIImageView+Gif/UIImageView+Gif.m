//
//  UIImageView+Gif.m
//  IMEGifView
//
//  Created by 刘ToTo on 2017/1/19.
//  Copyright © 2017年 刘ToTo. All rights reserved.
//

#import "UIImageView+Gif.h"
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>


const void *kGifDisplayLink = &kGifDisplayLink;
const void *kGifSourceURL = &kGifSourceURL;
const void *kGifSource = &kGifSource;
const void *kGifPropertiesDictionary = &kGifPropertiesDictionary;
const void *kGifImgCount = &kGifImgCount;
const void *kGifCurrentIndex = &kGifCurrentIndex;
const void *kGifPlaying = &kGifPlaying;
const void *kGifPlayingCompleted = &kGifPlayingCompleted;

@interface UIImageView ()

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic) CGImageSourceRef gifSource;
@property (nonatomic, strong) NSDictionary *gifProperties;
@property (nonatomic, assign) BOOL isGifPlaying;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, copy) void(^completed)(BOOL finished);

@end
@implementation UIImageView (Gif)

- (void)loadGifSoure
{
    NSAssert(self.gifURL, @"Gif Url must not be nil! -[UIImageView(Gif) loadGifSoure]");
    self.isGifPlaying = YES;
    NSDictionary *gifLoopCount = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:1] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    self.gifProperties = [NSDictionary dictionaryWithObject:gifLoopCount forKey:(NSString *)kCGImagePropertyGIFDictionary];
    self.gifSource = CGImageSourceCreateWithURL((CFURLRef)self.gifURL, (CFDictionaryRef)self.gifProperties);
    NSString *type = (NSString *)CGImageSourceGetType(self.gifSource);
    BOOL isGif = [type hasSuffix:@".gif"];
    NSAssert(isGif == YES, @"source type must be gif! -[UIImageView(Gif) loadGifSoure]");
    self.count = (NSUInteger)CGImageSourceGetCount(self.gifSource);
    self.currentIndex = 0;
}

- (void)playGIF
{
    [self playGIFWithCompleted:nil];
}

- (void)playGIFWithCompleted:(void(^)(BOOL finished))completed
{
    [self loadGifSoure];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startPlayGIF)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.completed = completed;
}

- (void)startPlayGIF
{
    if (self.animationRepeatCount !=0 && self.animationRepeatCount ==(self.currentIndex)/self.count) {
        [self stopGIF];
    }else{
        CGImageRef ref = CGImageSourceCreateImageAtIndex(self.gifSource, self.currentIndex%self.count, (CFDictionaryRef)self.gifProperties);
        self.image = [UIImage imageWithCGImage:ref];
        CFRelease(ref);
        self.currentIndex++;
    }
    
}

- (void)stopGIF
{
    if (self.completed) {
        self.completed(YES);
    }
    self.completed = nil;
    self.isGifPlaying = NO;
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.gifSource = nil;
    self.currentIndex = 0;
    self.gifProperties = nil;
    self.count = 0;
}


#pragma mark - getter and setter

- (NSURL *)gifURL
{
    return objc_getAssociatedObject(self, kGifSourceURL);
}

- (void)setGifURL:(NSURL *)gifURL
{
    objc_setAssociatedObject(self, kGifSourceURL, gifURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)count
{
    NSNumber *count = objc_getAssociatedObject(self, kGifImgCount);
    return count?[count integerValue]:0;
}

- (void)setCount:(NSUInteger)count
{
    objc_setAssociatedObject(self, kGifImgCount, [NSNumber numberWithUnsignedInteger:count], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)currentIndex
{
    NSNumber *currentIndex = objc_getAssociatedObject(self, kGifCurrentIndex);
    return currentIndex?[currentIndex integerValue]:0;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    objc_setAssociatedObject(self, kGifCurrentIndex, [NSNumber numberWithUnsignedInteger:currentIndex], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGImageSourceRef)gifSource
{
    return (__bridge CGImageSourceRef)(objc_getAssociatedObject(self, kGifSource));
}

- (void)setGifSource:(CGImageSourceRef)gifSource
{
    objc_setAssociatedObject(self, kGifSource, (__bridge id)(gifSource), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)gifProperties
{
    return objc_getAssociatedObject(self, kGifPropertiesDictionary);
}

- (void)setGifProperties:(NSDictionary *)gifProperties
{
    objc_setAssociatedObject(self, kGifPropertiesDictionary, gifProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isGifPlaying
{
    NSNumber *isGifPlaying = objc_getAssociatedObject(self, kGifPlaying);
    return isGifPlaying?[isGifPlaying boolValue]:NO;
}

- (void)setIsGifPlaying:(BOOL)isGifPlaying
{
    objc_setAssociatedObject(self, kGifPlaying, [NSNumber numberWithBool:isGifPlaying], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CADisplayLink *)displayLink
{
    return  objc_getAssociatedObject(self, kGifDisplayLink);
}

- (void)setDisplayLink:(CADisplayLink *)displayLink
{
    objc_setAssociatedObject(self, kGifDisplayLink, displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(BOOL))completed
{
    return  objc_getAssociatedObject(self, kGifPlayingCompleted);
}

- (void)setCompleted:(void (^)(BOOL))completed
{
    objc_setAssociatedObject(self, kGifPlayingCompleted, completed, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
