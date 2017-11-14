# GetImageSizeWithURL

#### 根据网络图片URL链接获取图片的尺寸（宽高）

> 先喳喳两句：我不是原创，主要是为了做一个笔记，原作者的方法有些许瑕疵，不过在它得评论区已经有热心网友给出了完美的解决方案，所以我就借此整理到我的简书，希望大家见怪莫怪，这个方法确实挺有效的。[原文链接](http://www.jianshu.com/p/9984c37f3f54)


##### 导入.h头文件后一行代码调用 - 获取图片尺寸：
```
    CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/2822163-70ac87aa2d2199d1.jpg"]];
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
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        //以下是对手机32位、64位的处理（由网友评论区拿到的：小怪兽饲养猿）
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
##### 以下是图片素材:
![png图片.png](http://upload-images.jianshu.io/upload_images/2822163-925eb5564821ceb9.png)

![jpg图片.jpg](http://upload-images.jianshu.io/upload_images/2822163-70ac87aa2d2199d1.jpg)

![gif图片.gif](http://upload-images.jianshu.io/upload_images/2822163-add2e3fc3735a6e7.gif)

#### [Github 测试Demo 点击下载](https://github.com/90candy/GetImageSizeWithURL)

![阿唯不知道](http://upload-images.jianshu.io/upload_images/2822163-39718ec5bd7e3cf8.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
