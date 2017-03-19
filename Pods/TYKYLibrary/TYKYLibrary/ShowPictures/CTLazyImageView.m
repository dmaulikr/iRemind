//
//  LazyImageView.m
//  FacePk
//
//  Created by 腾 on 16/6/26.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "CTLazyImageView.h"
#import "CTImagePreviewViewController.h"
#import "CTDownloadWithSession.h"

#define Device_height   [[UIScreen mainScreen] bounds].size.height
#define Device_width    [[UIScreen mainScreen] bounds].size.width

@interface CTLazyImageView ()<TJSessionDownloadToolDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *vwIndView;
@property (nonatomic, strong) UILabel *progressLabel;//下载进度
@property (nonatomic, strong) UIButton *reFreshBtn;//重新下载按钮

@end
@implementation CTLazyImageView

#pragma mark 初始化下载对象
- (void)setRequest:(CTDownloadWithSession *)request{
    _request  = request;
    [self loadImageFromURLString:request.downloadURl.absoluteString];
}

#pragma mark 加载网络图片
-(void)loadImageFromURLString:(NSString*)imageURLString{
    
    self.image = nil;
    
    NSString *filePath  = [CTLazyImageView getImagePathWithURLstring:imageURLString];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath ])
    {
        UIImage *savedImage = [UIImage imageWithContentsOfFile:filePath ];
        if (savedImage) {
            self.image = savedImage;
            self.frame = [self makeImageViewFrame:savedImage];
        }
       
        return;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Device_width/2-30, Device_height/2-10, 60, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    self.progressLabel = label;
    
    self.vwIndView = [UIActivityIndicatorView new];
    self.vwIndView.hidesWhenStopped = YES;
    self.vwIndView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.vwIndView.center = CGPointMake(Device_width/2, Device_height/2-20);
    [self.vwIndView startAnimating];
    [self addSubview:self.vwIndView];
  
    self.request.delegate = self;
    self.request.filePath = filePath;
    if (!self.request.isDownloading) {
        [self.request startDownload];

    }
    label.text = self.request.percentStr;

}

#pragma mark 获取图片地址
+(NSString *)getImagePathWithURLstring:(NSString *)imageURL{
    NSString *fileName = [imageURL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *imgPath = [[CTLazyImageView documentPath] stringByAppendingPathComponent:fileName];
    
    return imgPath;
}

#pragma mark 获取图片根目录
+(NSString*)documentPath
{
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CT_LOCAL_IMAGES"];
    
    BOOL isDir = YES;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir];
    if(!isExist || !isDir)
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
    
    return cachePath;
}

#pragma mark 根据图片大小设置imageview的frame
- (CGRect)makeImageViewFrame:(UIImage *)image{
    
    CGSize imageSize = image.size;
    CGFloat scaleW = imageSize.width/Device_width;
    CGFloat picHeight = imageSize.height/scaleW;
    
    CGFloat picW;
    CGFloat picH;
    
    if (picHeight>Device_height) {
        CGFloat scaleH = picHeight/(Device_height);
        picW = Device_width/scaleH;
        picH = Device_height;
    }else{
        picW = Device_width;
        picH = picHeight;
    }
    
    CGRect newFrame = CGRectMake(Device_width/2-picW/2, Device_height/2-picH/2, picW, picH);
    return  newFrame;
}

#pragma mark 添加警示标语
- (UIButton *)addWarningLabel{
  
    UIButton *downBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 60, 140, 35)];
    downBtn.layer.masksToBounds = YES;
    downBtn.layer.cornerRadius = 5.0;
    downBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    downBtn.layer.borderWidth = 1.0;
    [downBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    downBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [downBtn addTarget:self action:@selector(downloadImageAgain) forControlEvents:UIControlEventTouchUpInside];
    
    return downBtn;

}
#pragma mark 重新下载
- (void)downloadImageAgain{
    
    [self.vwIndView startAnimating];
    self.reFreshBtn.hidden = YES;
    self.progressLabel.hidden = NO;
    [self.request startDownload];
}

#pragma mark CTRequestDelegate
- (void)changeProgressValue:(NSString *)progress{
    
    self.progressLabel.text = progress;
    
}
- (void)downLoadedSuccessOrFail:(BOOL)state withUrl:(NSString *)urlStr{
    
    self.progressLabel.hidden = YES;
    [self.vwIndView stopAnimating];
    
    if (state) {//下载成功
        //清空下载对象
        [[CTImagePreviewViewController defaultShowPicture].requestArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[(CTDownloadWithSession *)obj downloadURl].absoluteString isEqualToString:_request.downloadURl.absoluteString]) {
                [[CTImagePreviewViewController defaultShowPicture].requestArray removeObject:obj];
                *stop = YES;
            }
        }];
        self.transform = CGAffineTransformMakeScale(0.01,0.01);
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:7];
            self.transform = CGAffineTransformMakeScale(1.0,1.0);
            
        }];
        [self loadImageFromURLString:urlStr];

        self.userInteractionEnabled = YES;

        if (self.reFreshBtn) {
            self.reFreshBtn.hidden = YES;
        }
        
    }else{
        //下载失败
        if (!self.reFreshBtn) {
            self.reFreshBtn = [self addWarningLabel];
            if (self.superview&&[self.superview isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scr = (UIScrollView *)self.superview;
                scr.maximumZoomScale = 1.0;
                [scr addSubview:self.reFreshBtn];
            }
        }
        
        self.reFreshBtn.hidden = NO;
    }
}

@end
