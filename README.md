# GetImageSizeWithURL

#### 根据网络图片URL链接获取图片的尺寸（宽高）

##### 一行代码获取图片尺寸：
```
CGSize size = [UIImage getImageSizeWithURL:@"http://upload-images.jianshu.io/upload_images/2822163-70ac87aa2d2199d1.jpg"];
NSLog(@"%f", size.height);
```

#### 在使用之前还是要先引入系统的ImageIO.framework库

#### UIImage+ImgSize.h 文件

```
#import <UIKit/UIKit.h>
@interface UIImage (ImgSize)

+ (CGSize)getImageSizeWithURL:(id)URL;

@end

```


#### UIImage+ImgSize.m 文件

```
#import "UIImage+ImgSize.h"
#import <ImageIO/ImageIO.h>
@implementation UIImage (ImgSize)

/**
*  根据图片url获取网络图片尺寸
*/
+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    
    if (imageSourceRef) {
        
        // 获取图像属性
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        
        //以下是对手机32位、64位的处理
        if (imageProperties != NULL) {
            
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            /***************** 此处解决返回图片宽高相反问题 *****************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {  // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                    break;
                default:
                    break;
            }
            /***************** 此处解决返回图片宽高相反问题 *****************/

            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

@end

```

##### 有网友提到这个方法应用到cell里面会卡顿，这里给出我的解决方法：
	
```
在拿到需要请求的url数组的时候，就将每个链接的尺寸顺便就给获取出来，然后本地化存储该图片的尺寸，然后再到cell里面根据链接直接在本地取到图片的尺寸，那样在cell里面浏览的时候就不会有卡顿了。
//获取图片尺寸时先检查是否有缓存(有就不用再获取了)
if (![[NSUserDefaults standardUserDefaults] objectForKey:url]) {
	//这里拿到每个图片的尺寸，然后计算出每个cell的高度
	CGSize imageSize = [UIImage getImageSizeWithURL:url];
	CGFloat imgH = 0;
	if (imageSize.height > 0) {
		//这里就把图片根据 固定的需求宽度  计算 出图片的自适应高度
		imgH = imageSize.height * (SCREEN_WIDTH - 2 * _spaceX) / imageSize.width;
	}   
	//将最终的自适应的高度 本地化处理
	[[NSUserDefaults standardUserDefaults] setObject:@(imgH) forKey:url];
}
```

##### 本文相关资料链接（关于方向问题即宽高相反）

1、CGImageSource对图像数据读取任务的抽象：http://www.tanhao.me/pieces/1019.html

2、iOS开发中图片方向的获取与更改：http://www.cnblogs.com/gaoxiaoniu/p/5329834.html

**本文简书地址：https://www.jianshu.com/p/854dc9c810c9**

##### 以下是png、jpg、gif的图片素材:

<div align="center">
	<img src="http://upload-images.jianshu.io/upload_images/2822163-925eb5564821ceb9.png"/>
	<img src="http://upload-images.jianshu.io/upload_images/2822163-70ac87aa2d2199d1.jpg" />
	<img src="http://upload-images.jianshu.io/upload_images/2822163-add2e3fc3735a6e7.gif" />
</div>

<div align="center">
	<img src="http://upload-images.jianshu.io/upload_images/2822163-089602958ae7072a.png"/>
</div>
