//
//  TJUploadFile.h
//  webhall
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTUploadFileDelegate <NSObject>

//发送上传进度
- (void)uploadingFile:(NSString *)pecent;

//上传成功或失败
- (void)uploadSuccessOrFail:(BOOL)isSuccess;

@end

@interface CTUploadFileTool : NSObject

@property(nonatomic, weak) id<CTUploadFileDelegate>delegate;
@property(nonatomic, strong) NSNumber *state;//0未上传 1正在上传 2上传成功 3上传失败
@property(nonatomic, strong) NSString *percentStr;//上传进度

/**
 *  传入上传地址，上传文件 实例化上传对象
 */
- (instancetype)initUploadToolWithUrlStr:(NSString *)urlStr andFileData:(NSData *)fileData;

//开始上传文件
- (void)startUploadFileWithData;

@end
