// //Expr
// a + b
// a - b
// a * b
// a / b
// a % b
// a > b
// a < b
// a <= b
// a >= b
// a == b
// a != b
// a && b
// a || b
// a ... b
// a ..< b
// -a
// +a
// !a
// 123
// 0x123
// 1.123
// (123)
// [1,2,3]
// {a:1,b:2}
// "abcd"
// a ? 1 : 2

// //VarDecl StmtSeparator
// var a
// let a

// FuncDecl
// func test(a = 1,b,c) {
//     return a + b + c
// }

// //call
// test(a:1){}

// //AssignStmt StmtSeparator    
// a = 1

// //IfStmt    
// if a {
//     if a {
//     }else if a {
//     }else {
//     }
// }else if a{
// }else {
// }

// // WhileStmt  
// while a {
//     repeat {
//         continue
//         break
//     } while a
//     continue
//     break
// }

// // jz endWhile
// // beginWhile:
// // continue = jmp before jmp
// // break = jmp endwhile
// // xxx
// // continuePoint
// // jnz beginWhile
// // endWhile


// //ForStmt
// for i in arr {
//     continue
//     break
// }

//ClassDecl    
var a = 1               
class Son:Father
{
    var a = 1
    func init() {

    }
    func init(a,b,c){

    }
    func test(a,b,c) {

    }
}

// a = Students()

// //obj call
// aaa.test()
