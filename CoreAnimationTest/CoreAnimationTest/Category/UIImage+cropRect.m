//
//  UIImage+cropRect.m
//  CoreAnimationTest
//
//  Created by ZS on 2018/4/28.
//  Copyright © 2018年 ZS. All rights reserved.
//

#import "UIImage+cropRect.h"

@implementation UIImage (cropRect)


- (UIImage*)cropImageWithRect:(CGRect)cropRect
{
    //豆电雨
    CGRect drawRect = CGRectMake(-cropRect.origin.x , -cropRect.origin.y, self.size.width * self.scale, self.size.height * self.scale);
    
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, cropRect.size.width, cropRect.size.height));
    
    [self drawInRect:drawRect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
