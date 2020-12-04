//
//  FAROperCmd.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/16.
//

#ifndef FAROperCmd_h
#define FAROperCmd_h


#define TAG_CLASS_BEGIN             "CLASS_BEGIN_"
#define TAG_CLASS_END               "CLASS_END_"
#define TAG_CLOSURE_BEGIN           "CLOSURE_BEGIN_"
#define TAG_CLOSURE_END             "CLOSURE_END_"
#define TAG_FUNC_START              "FUNC_BEGIN_"
#define TAG_FUNC_END                "FUNC_END_"
#define TAG_WHILE_BEGIN             "WHILE_BEGIN_"
#define TAG_WHILE_END               "WHILE_END_"
#define TAG_CONTINUE                "CONTINUE_POINT_"
#define TAG_IF_BEGIN                "IF_BEGIN_"
#define TAG_IF_END                  "IF_END_"
#define TAG_IF_THEN                 "IF_THEN_"

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
    FAROperCmdSetProperty,
    FAROperCmdAssign,
    
    FAROperCmdPushNewArr,
    FAROperCmdAddEleToArr,
    FAROperCmdGetSubscript,
};

#endif /* FAROperCmd_h */
