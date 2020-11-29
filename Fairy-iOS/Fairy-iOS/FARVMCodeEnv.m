//
//  FARVMCodeEnv.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARVMCodeEnv.h"
#import "FARCodeObj.h"
#import "FARClassCodeObj.h"
#import "FARFuncCodeObj.h"
#import "FARClosureCodeObj.h"

@interface FARVMCodeEnv()

@property (nonatomic, strong) FARVMCode *vmCode;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<FARCommandTag *>*> *tagIndexDicCopy;
@property (nonatomic, strong) NSMutableDictionary<NSString *, FARCodeObj *>* codeObjDic;

@end

@implementation FARVMCodeEnv

- (instancetype)initWithVMCode:(FARVMCode *)vmCode {
    self = [super init];
    if (self) {
        _vmCode = vmCode;
        _tagIndexDicCopy = [vmCode.tagIndexDic mutableCopy];
        [self parseCode];
    }
    return self;
}

- (void)parseCode {
    FARCodeObj *mainCode = [[FARFuncCodeObj alloc] initWithEnv:self];
    mainCode = [self parseObjWithStartIndex:0 endIndex:self.vmCode.commandArr.count - 1 rootObj:mainCode];
    self.codeObjDic[FAR_MAIN_CODE] = mainCode;
}

- (FARCodeObj *)parseObjWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex rootObj:(FARCodeObj *)root{
    
    for (NSInteger i = startIndex;i <= endIndex;i++) {
        FARCommandTag *tag = self.tagIndexDicCopy[@(i)].firstObject;
        if(tag) {
            [self.tagIndexDicCopy[@(i)] removeObjectAtIndex:0];
        }
        if (tag.type == FARCommandTagTypeClassBegin) {
            FARClassCodeObj *classObj = [[FARClassCodeObj alloc] initWithEnv:root.env];
            FARCommandTag *pairsTag = self.vmCode.tagDic[tag.pairsEndName];
            //删除用过的tag
            [self.tagIndexDicCopy[@(pairsTag.codeIndex)] removeObjectAtIndex:0];
            
            NSInteger classEndIndex = pairsTag.codeIndex - 1;
            classObj = (FARClassCodeObj *)[self parseObjWithStartIndex:i endIndex:classEndIndex rootObj:classObj];
            [root addSubCodeObj:classObj];
            i = classEndIndex;
            continue;
        }else if (tag.type == FARCommandTagTypeFuncBegin) {
            FARFuncCodeObj *funcObj = [[FARFuncCodeObj alloc] initWithEnv:root.env];
            FARCommandTag *pairsTag = self.vmCode.tagDic[tag.pairsEndName];
            [self.tagIndexDicCopy[@(pairsTag.codeIndex)] removeObjectAtIndex:0];
            
            NSInteger funcEndIndex = pairsTag.codeIndex - 1;
            funcObj = (FARFuncCodeObj *)[self parseObjWithStartIndex:i endIndex:funcEndIndex rootObj:funcObj];
            [root addSubCodeObj:funcObj];
            i = funcEndIndex;
            continue;
        }else if (tag.type == FARCommandTagTypeClosureStart) {
            FARClosureCodeObj *closureObj = [[FARClosureCodeObj alloc] initWithEnv:root.env];
            FARCommandTag *pairsTag = self.vmCode.tagDic[tag.pairsEndName];
            [self.tagIndexDicCopy[@(pairsTag.codeIndex)] removeObjectAtIndex:0];
            NSInteger closureEndIndex = pairsTag.codeIndex - 1;
            closureObj = (FARClosureCodeObj *)[self parseObjWithStartIndex:i endIndex:closureEndIndex rootObj:closureObj];
            [root addSubCodeObj:closureObj];
            i = closureEndIndex;
            continue;
        }else {
            [root addCodeIndex:i];
            continue;
        }
        
    }
    
    return root;
}

- (FARBaseObj *)findVarForKey:(NSString *)key {
    if (self.vmCode.tagDic[key]) {
        return @(self.vmCode.tagDic[key].codeIndex);
    }
    return nil;
}

- (NSMutableDictionary<NSString *,FARCodeObj *> *)codeObjDic {
    if(!_codeObjDic) {
        _codeObjDic = [NSMutableDictionary dictionary];
    }
    return _codeObjDic;

}


- (void)setVar:(id)value key:(NSString *)key {
    @throw [NSException exceptionWithName:@"代码表不能设置变量" reason:nil userInfo:nil];
}
- (void)declareVar:(NSString *)key {
    @throw [NSException exceptionWithName:@"代码表不能声明变量" reason:nil userInfo:nil];
}
- (void)declareLet:(NSString *)key {
    @throw [NSException exceptionWithName:@"代码表不能声明变量" reason:nil userInfo:nil];
}



@end
