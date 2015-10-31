//
//  ViewController.m
//  GrayscaleTime
//
//  Created by 房懷安 on 2015/10/31.
//  Copyright © 2015年 Thinkpower. All rights reserved.
//

#import "ViewController.h"

#include "time.h"

@interface ViewController ()
{
    IBOutlet UIImageView *imageViewDiplay ;
    IBOutlet UIButton *btnGrayscale ;
    IBOutlet UILabel *lbTime ;
    IBOutlet UIButton *btnReload;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnGrayscaleClicked :(id)sender {
    
    UIImage *imageOriginal = [UIImage imageNamed:@"sample"];
    UIImage *imageSource = [UIImage imageWithCGImage:imageOriginal.CGImage];
    
    clock_t start ;
    clock_t finish ;
    
    start = clock();
    
    UIImage *imageProcessed = [self imageToGreyImage:imageSource];
    
    finish = clock();
    
    float duration =   ((float)(finish - start)) / CLOCKS_PER_SEC  ;
    
    NSString *message = [NSString stringWithFormat:@"start:%lu; finish:%lu; duration:%f;\ntick:%lu", start, finish, duration, (finish - start)];
    
    NSLog(@"%@", message );
    [lbTime setText:message];
    
    [imageViewDiplay setImage:imageProcessed];
    
}

- (IBAction)btnReloadClicked :(id)sender{

    UIImage *imageOriginal = [UIImage imageNamed:@"sample"];
    [imageViewDiplay setImage:imageOriginal];
    
}

- (UIImage *)imageToGreyImage:(UIImage *)image {
    // Create image rectangle with current image width/height
    CGFloat actualWidth = image.size.width;
    CGFloat actualHeight = image.size.height;
    
    CGRect imageRect = CGRectMake(0, 0, actualWidth, actualHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    CGImageRef grayImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, nil, kCGImageAlphaOnly);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    CGImageRef mask = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *grayScaleImage = [UIImage imageWithCGImage:CGImageCreateWithMask(grayImage, mask) scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(grayImage);
    CGImageRelease(mask);
    
    // Return the new grayscale image
    return grayScaleImage;
}

@end
