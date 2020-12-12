
# Fairy frameword 的使用


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
    wrapper callWithParams:@{@"sender": sender}];
 }
```

