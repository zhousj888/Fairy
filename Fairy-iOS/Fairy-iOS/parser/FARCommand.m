//
//  FARCommand.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/16.
//

#import "FARCommand.h"
NSString *transCmdToDescription(int cmd);

@implementation FARCommand

+ (instancetype)commandWithCmd:(NSInteger)cmd line:(NSInteger)line fileName:(nonnull NSString *)fileName{
    return [self commandWithCmd:cmd oper:nil line:line fileName:fileName];
}

+ (instancetype)commandWithCmd:(NSInteger)cmd oper:(id)oper line:(NSInteger)line fileName:(nonnull NSString *)fileName{
    return [self commandWithCmd:cmd oper1:oper oper2:nil line:line fileName:fileName];
}

+ (instancetype)commandWithCmd:(NSInteger)cmd oper1:(id)oper1 oper2:(id)oper2 line:(NSInteger)line fileName:(nonnull NSString *)fileName{
    return [self commandWithCmd:cmd oper1:oper1 oper2:oper2 oper3:nil line:line fileName:fileName];
}

+ (instancetype)commandWithCmd:(NSInteger)cmd oper1:(id)oper1 oper2:(id)oper2 oper3:(id)oper3 line:(NSInteger)line fileName:(nonnull NSString *)fileName{
    FARCommand *command = [[FARCommand alloc] init];
    command.line = line;
    command.operCmd = cmd;
    command.oper1 = oper1;
    command.oper2 = oper2;
    command.oper3 = oper3;
    command.fileName = fileName;
    return command;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(cmd=%@,oper1=%@,oper2=%@,oper3=%@", transCmdToDescription((int)self.operCmd),self.oper1,self.oper2,self.oper3];
}


@end
