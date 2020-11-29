//
//  FARNumberRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARNumberRunInstance.h"

@implementation FARNumberRunInstance


- (BOOL)isEqualFalse {
    return self.number.boolValue;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.number];
}

@end
