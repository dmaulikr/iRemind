//
//  TJUploadFile.m
//  webhall
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import "CTUploadFileTool.h"
#define debugLog(...) NSLog(__VA_ARGS__)

#define MULTIPART @"multipart/form-data; boundary=---------------------------7da2137580612"

@interface CTUploadFileTool ()<NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession *session;//任务
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;

@end

@implementation CTUploadFileTool

- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    }
    return _session;
    
}
- (instancetype)initUploadToolWithUrlStr:(NSString *)urlStr andFileData:(NSData *)fileData{
    self = [super init];
    if (self) {
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [urlRequest setHTTPMethod: @"POST"];
        [urlRequest setValue:MULTIPART forHTTPHeaderField: @"Content-Type"];
        [urlRequest setHTTPBody:fileData];
        
        self.urlRequest = urlRequest;

    }
    return self;
}

//开始上传文件
- (void)startUploadFileWithData{
    
    _state = @1;

    NSURLSessionUploadTask *task = [self.session uploadTaskWithRequest:self.urlRequest fromData:self.urlRequest.HTTPBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *outstring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; //替换掉null
        outstring = [outstring stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
                if (error) {
                    _state = @3;
                    if ([self.delegate respondsToSelector:@selector(uploadSuccessOrFail:)]) {

                        [self.delegate uploadSuccessOrFail:NO];
                    }
                   
                }else{
                    NSError *error;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    if ([dic[@"code"] intValue] != 200) {
                        return;
                    }
                    _state = @2;
                    
                    if ([self.delegate respondsToSelector:@selector(uploadSuccessOrFail:)]) {
                        
                        [self.delegate uploadSuccessOrFail:YES];
                    }
                }
            
        });
       
    }];
    
    [task resume];

}

#pragma mark - NSURLSessionTaskDelegate

/**
 *  监听上传进度
 *
 *   session
 *   task                     上传任务
 *   bytesSent                当前这次发送的数据
 *   totalBytesSent           已经发送的总数据
 *   totalBytesExpectedToSend 期望发送的总数据
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    _state = @1;
    float progress = (float)1.0*totalBytesSent / totalBytesExpectedToSend;
    
    self.percentStr = [NSString stringWithFormat:@"%@",[self makePasentFromFloat:progress]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.percentStr = [self makePasentFromFloat:progress];
        if ([self.delegate respondsToSelector:@selector(uploadingFile:)]) {
            [self.delegate uploadingFile:self.percentStr];
        }
    });
   
    debugLog(@"正在上传文件......:%@",self.percentStr);
}
//上传成功
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            _state = @3;
            if ([self.delegate respondsToSelector:@selector(uploadSuccessOrFail:)]) {
                
                [self.delegate uploadSuccessOrFail:NO];
            }
        }
        
    });

}
//浮点转百分比
- (NSString *)makePasentFromFloat:(float)value{
    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
    CFNumberFormatterRef numberFormatter = CFNumberFormatterCreate(NULL, currentLocale, kCFNumberFormatterPercentStyle);
    CFNumberRef number = CFNumberCreate(NULL, kCFNumberFloatType, &value);
    CFStringRef numberString = CFNumberFormatterCreateStringWithNumber(NULL, numberFormatter, number);
    return [NSString stringWithFormat:@"%@",numberString];
    
}
@end
