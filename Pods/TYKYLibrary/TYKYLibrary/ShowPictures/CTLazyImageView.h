//
//  LazyImageView.h
//  FacePk
//
//  Created by 腾 on 16/6/26.
//  Copyright © 2016年 腾. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTDownloadWithSession;

@interface CTLazyImageView : UIImageView

@property (strong, nonatomic) CTDownloadWithSession *request;//下载工具

@end
