//
//  FARObjectWrapper.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/7.
//

#import <Foundation/Foundation.h>
#import "FARBaseCodeRunInstance.h"



NS_ASSUME_NONNULL_BEGIN
//里面是fairy对象，外层是native对象
@interface FARObjectWrapper : NSObject

@property (nonatomic, strong) FARBaseCodeRunInstance *value;

- (instancetype)initWithFarObj:(FARBaseCodeRunInstance *)farObj;

- (void)callWithParams:(nullable NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
