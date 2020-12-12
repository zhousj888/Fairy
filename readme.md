# Fairy

## 项目介绍

Fairy是一个轻量级的UI脚本语言，可以在iOS低版本上体验SwiftUI开发！



## Demo

<img src="/uploads/fairy.gif" align=center>



## 使用方式

1. clone 这个仓库
2. 然后打开Fairy-iOS下的Fairy-iOS.xcodeproj
3. 运行Fairy-iOS-Demo 这个 target


目前还处在beta版本，如果想在项目中使用，可以将 Fairy-iOS 拷贝到你的工程中,作为子工程依赖


## 基本语法

```swift
//basic type
var yes = true
var no = false
var integer = 1
var decimal = 1.111
var str = "this is string type"
var array = [1,2,3]
var arrayValue = array[0]
var dic = ["key1": 1, "key2": 2]
var dicValue = dic["key1"]

//declare
var a = 1

//if
if a > 1 {
  
} else if a < 0 {
  
} else {
  
}

//while
while a > 0 {
  a = a - 1
}

repeat {
  a = a - 1
} while a > 0


//fuction
func test(param1, param2) {
	//do something
}
test(param1: p1, param2: p2)

//class
class Father {
  var height
  func init() {
    //init func will call automatically when new a instance
  }
}
class Son: Father {
  var age
  func init() {
    //first call super.init, then call this
  }
}

//you can see internalScript.far and find more usage
```

## Fairy frameword 的使用


# Color

```swift
//new a white color
var c = Color(hex: "#ffffff")
```

# View

```swift

View(width: 200, height: 50, backgroundColor: red, radius: 2)
//all those property you can call set function, like this👇
View(width: 200, height: 50).setBackgroundColor(color: blue)

```

# Stack: View

stack is extended from View, you can call any View's function.

They are implement with UIStackView.

```swift
VStack()
HStack()
```

# Label: View

```swift
Label(width: 200, height: 50, text: "Fairy", textAlignment: TextAlignmentCenter, textColor: red, bold:1, textSize: 18)
```

# ImageView: View

```swift
ImageView(width: 400, height: 200, src: "fairy")
```

# Spacer: View

```swift
Spacer(width:1, height:40)
```

## Fairy - Native 交互

### Fairy对象 => Native对象

基本类型会自动转换，其他对象需要Fairy对象实现```toNativeObj``` 方法，系统会自动调用这个方法获取来进行转换

### Native 对象 => Fairy对象

基本类型会自动转换，其他对象会变成```FARNativeWrapperInstance```

### Fairy 调用 native

1. 增加 Fairy-Native 接口

   ```objective-c
   - (void)testFunc:(NSDictionary *)params {
   }
   ```

   

2. 在Fairy代码中调用

   ```swift
   __Native.testFunc(param: p)
   ```

### Native 调用 Fairy

注意: 要先在Native中获取到Fairy对象，才能调用到Fairy

```objective-c
- (void)setClickListener:(NSDictionary *)params {
			FARObjectWrapper *wrapper = params[@"clickListener"];
  		[wrapper callWithParams:@{@"sender": sender}];
 }
```

