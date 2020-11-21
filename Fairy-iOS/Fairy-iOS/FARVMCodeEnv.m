//
//  FARVMCodeEnv.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARVMCodeEnv.h"

@interface FARVMCodeEnv()

@property (nonatomic, strong) FARVMCode *vmCode;

@end

@implementation FARVMCodeEnv

- (instancetype)initWithVMCode:(FARVMCode *)vmCode {
    self = [super init];
    if (self) {
        _vmCode = vmCode;
    }
    return self;
}

- (id)findVarForKey:(NSString *)key {
    return @(self.vmCode.tagDic[key].codeIndex);
    
}
- (void)setVar:(id)value key:(NSString *)key {
    
}
- (void)declareVar:(NSString *)key {
    
}
- (void)declareLet:(NSString *)key {
    
}

@end
