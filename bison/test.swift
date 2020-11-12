var b = 1
1
let a
var a
a
a = 1
var a

if 1 {
}
if 1 {
} else {
}
if 1 {
}else if 1 {
}else {
}

while 1 {
}
break
continue

func test(width = 1, height = 2, content) {

}
//指定名字的参数优先匹配
//没有指定名字的参数按顺序匹配没有默认值的参数
//所以下方收到的参数width = 1,height = 3,content = {}
test(height: 3) {

}