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
#import "FARNativeCodeObj.h"
#import "FARNull.h"

/**
 codeObjDic's key regular:
 
 class.name = className
 class.superName = superClassName
 
 func.name = className:superClassName_funcName = tag.rawName
 
 closure.name = TAG_CLOSURE_BEGIN_closureID = tag.name
 
 
 */

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
    mainCode.name = FAR_MAIN_CODE;
    mainCode = [self parseObjWithStartIndex:0 endIndex:self.vmCode.commandArr.count - 1 rootObj:mainCode];
    self.codeObjDic[FAR_MAIN_CODE] = mainCode;
    
    
    self.codeObjDic[FAR_NATIVE_OBJ] = [[FARNativeCodeObj alloc] initWithEnv:self];
    
}

- (void)_setClassName:(FARClassCodeObj *)classObj tag:(FARCommandTag *)tag{
    NSString *classAndSuper = tag.rawName;
    if ([classAndSuper containsString:@":"]) {
        NSArray<NSString *> *strArr = [classAndSuper componentsSeparatedByString:@":"];
        classObj.name = strArr[0];
        classObj.superName = strArr[1];
    }else {
        classObj.name = tag.rawName;
    }
}

- (void)_recordCodeObjForKey:(NSString *)key codeObj:(FARCodeObj *)codeObj {
    if (self.codeObjDic[key]) {
        @throw [NSException exceptionWithName:@"重名符号" reason:nil userInfo:nil];
    }
    self.codeObjDic[key] = codeObj;
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
            [self _setClassName:classObj tag:tag];
            [self _recordCodeObjForKey:classObj.name codeObj:classObj];
            [root addSubCodeObj:classObj];
            i = classEndIndex;
            continue;
        }else if (tag.type == FARCommandTagTypeFuncBegin) {
            FARFuncCodeObj *funcObj = [[FARFuncCodeObj alloc] initWithEnv:root.env];
            FARCommandTag *pairsTag = self.vmCode.tagDic[tag.pairsEndName];
            [self.tagIndexDicCopy[@(pairsTag.codeIndex)] removeObjectAtIndex:0];
            
            NSInteger funcEndIndex = pairsTag.codeIndex - 1;
            funcObj = (FARFuncCodeObj *)[self parseObjWithStartIndex:i endIndex:funcEndIndex rootObj:funcObj];
            funcObj.name = tag.rawName;
            [self _recordCodeObjForKey:funcObj.name codeObj:funcObj];
            [root addSubCodeObj:funcObj];
            i = funcEndIndex;
            continue;
        }else if (tag.type == FARCommandTagTypeClosureStart) {
            FARClosureCodeObj *closureObj = [[FARClosureCodeObj alloc] initWithEnv:root.env];
            FARCommandTag *pairsTag = self.vmCode.tagDic[tag.pairsEndName];
            [self.tagIndexDicCopy[@(pairsTag.codeIndex)] removeObjectAtIndex:0];
            NSInteger closureEndIndex = pairsTag.codeIndex - 1;
            closureObj = (FARClosureCodeObj *)[self parseObjWithStartIndex:i endIndex:closureEndIndex rootObj:closureObj];
            closureObj.name = tag.name;
            [self _recordCodeObjForKey:closureObj.name codeObj:closureObj];
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
    //如果是类或者闭包可以直接找到
    if (self.codeObjDic[key]) {
        return self.codeObjDic[key];
    }
    //可能是类里面的方法
    FARClassCodeObj *classCodeObj = nil;
    NSString *funcKey = [NSString stringWithFormat:@"%@_%@",classCodeObj.name,key];
    return self.codeObjDic[funcKey];
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
