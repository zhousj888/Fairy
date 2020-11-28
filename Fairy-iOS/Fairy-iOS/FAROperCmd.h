//
//  FAROperCmd.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/16.
//

#ifndef FAROperCmd_h
#define FAROperCmd_h

enum {
    FAROperCmdPushInt = 1,
    FAROperCmdPushDouble,
    FAROperCmdPushIdentifier,
    FAROperCmdPushString,
    FAROperCmdPop,
    
    FAROperCmdJmp,
    FAROperCmdJz,
    FAROperCmdJnz,
    
    FAROperCmdVar,
    FAROperCmdLet,
    
    FAROperCmdAdd,
    FAROperCmdSub,
    FAROperCmdMul,
    FAROperCmdDiv,
    FAROperCmdMod,
    FAROperCmdCmpgt,
    FAROperCmdCmplt,
    FAROperCmdCmpge,
    FAROperCmdCmple,
    FAROperCmdCmpeq,
    FAROperCmdCmpne,
    FAROperCmdOr,
    FAROperCmdAnd,
    FAROperCmdNeg,
    FAROperCmdNot,
    
    FAROperSave,
    FAROperSaveIfNil,
    FAROperCreateNewEnv,
    
    FAROperCallFunc,
    FAROperCmdRet,
    FAROperExit,
    
    FAROperFuncFinish,
    FAROperCmdCreateSaveTopClosure,
    FAROperGetObjProperty,
};

#endif /* FAROperCmd_h */
