//
//  FARObjectWrapper.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/7.
//

#import "FARObjectWrapper.h"
#import "FARFuncRunInstance.h"
#import "NSDictionary+Fairy.h"

@implementation FARObjectWrapper

- (instancetype)initWithFarObj:(FARBaseCodeRunInstance *)farObj {
    if (self = [super init]) {
        self.value = farObj;
    }
    return self;
}

- (void)callWithParams:(NSDictionary *)params {
    [self.value runWithParams:params];
    if ([self.value isKindOfClass:[FARFuncRunInstance class]]) {
        FARFuncRunInstance *funcIns = (FARFuncRunInstance *)self.value;
        [funcIns makeReRunable];
    }
}


@end
