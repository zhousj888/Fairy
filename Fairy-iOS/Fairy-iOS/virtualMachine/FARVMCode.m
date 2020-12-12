//
//  FARVMCode.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import "FARVMCode.h"

@implementation FARVMCode

- (void)addOtherCode:(FARVMCode *)otherVmCode {
    [self.commandArr addObjectsFromArray:otherVmCode.commandArr];
    [self.tagDic addEntriesFromDictionary:otherVmCode.tagDic];
    [self.tagIndexDic addEntriesFromDictionary:otherVmCode.tagIndexDic];
}

+ (FARVMCode *)linkCode:(FARVMCode *)code1 code2:(FARVMCode *)code2 {
    
    FARVMCode *code1Cp = [code1 mutableCopy];
    FARVMCode *code2Cp = [code2 mutableCopy];
    
    NSUInteger code1Count = code1Cp.commandArr.count;
    
    for (NSString *key in code2Cp.tagDic) {
        FARCommandTag *tag = code2Cp.tagDic[key];
        tag.codeIndex += code1Count;
    }
    NSMutableDictionary<NSNumber *, NSMutableArray<FARCommandTag *>*> *code2NewIndexTagDic = [NSMutableDictionary dictionary];
    for (NSNumber *index in code2Cp.tagIndexDic) {
        code2NewIndexTagDic[@(index.integerValue + code1Count)] = code2Cp.tagIndexDic[index];
    }
    
    code2Cp.tagIndexDic = code2NewIndexTagDic;
    
    [code1Cp.commandArr addObjectsFromArray:code2Cp.commandArr];
    [code1Cp.tagDic addEntriesFromDictionary:code2Cp.tagDic];
    [code1Cp.tagIndexDic addEntriesFromDictionary:code2Cp.tagIndexDic];
    
    return code1Cp;
    
}


- (void)printCode {
    FARLog(@"---------------------------code👇--------------------------");
    for (FARCommand *cmd in self.commandArr) {
        FARLog(@"%@", cmd);
    }
    FARLog(@"---------------------------code👆--------------------------");
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    FARVMCode *newIns = [[FARVMCode alloc] init];
    newIns.commandArr = [self.commandArr mutableCopy];
    newIns.tagDic = [self.tagDic mutableCopy];
    newIns.tagIndexDic = [self.tagIndexDic mutableCopy];
    return newIns;
}

@end
