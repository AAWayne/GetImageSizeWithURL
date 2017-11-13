//
//  ViewController.m
//  GetImageSizeWithURL
//
//  Created by Candy on 2017/11/13.
//  Copyright © 2017年 com.zhiweism. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImgSize.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 获取图片url链接获取图片的宽高尺寸
    // 例如以下的png、jpg、gif图片等等
    // http://upload.jianshu.io/collections/images/546902/QQ20171013-100604_2x.png
    // http://img02.tooopen.com/images/20140401/sy_58062548899.jpg
    // https://b-ssl.duitang.com/uploads/item/201502/28/20150228235225_BHEXZ.gif
    
    CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/2822163-70ac87aa2d2199d1.jpg"]];
    NSLog(@"%f", size.height);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
