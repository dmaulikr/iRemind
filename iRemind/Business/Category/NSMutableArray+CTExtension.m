//
//  NSMutableArray+CTExtension.m
//  FacePk
//
//  Created by Apple on 16/7/15.
//  Copyright © 2016年 腾. All rights reserved.
//

#import "NSMutableArray+CTExtension.h"
#import <objc/runtime.h>
@implementation NSMutableArray (CTExtension)

+(void)load{
    Method orginalMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(CT_addObject:));
    
    //方法替换
    method_exchangeImplementations(orginalMethod, newMethod);
}

- (void)CT_addObject:(id)object{
    if (object) {
        [self CT_addObject:object];
    }else
    {
        NSLog(@"object is nil");
    }
//    @try {
//        [self CT_addObject:object];
//    }
//    @catch (NSException *exception) {
//        
//        NSLog(@"异常名称:%@   异常原因:%@",exception.name, exception.reason);
//    }
//    @finally {
//    }
   
}

@end
