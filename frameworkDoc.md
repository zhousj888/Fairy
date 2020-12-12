
# Fairy framework


# Color

```swift
//new a white color
var c = Color(hex: "#ffffff")
```

# View

```swift

View(width: 200, height: 50, backgroundColor: red, radius: 2)
//all those property you can call set function, like this👇,except width and height
View(width: 200, height: 50).setBackgroundColor(color: blue)
//you can call setSize adjust width and height
View().setSize(width: 100, height: 100)

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

## Fairy <=> Native 

### Fairy object => Native object

基本类型会自动转换，其他对象需要Fairy对象实现```toNativeObj``` 方法，系统会自动调用这个方法获取来进行转换
Basic types will be automatically converted, other Fairy objects need to implement the ```toNativeObj``` method, the system will automatically call this method to obtain for conversion

### Native object => Fairy object

Basic types will be automatically converted, other objects will become ```FARNativeWrapperInstance```

### Fairy call native

1. add Fairy-Native interface in ```FARNativeApi.m```

   ```objective-c
   - (void)testFunc:(NSDictionary *)params {
   }
   ```

   

2. call in Fairy

   ```swift
   __Native.testFunc(param: p)
   ```

### Native call Fairy

Note: You must get the Fairy object in Native before calling Fairy

```objective-c
- (void)setClickListener:(NSDictionary *)params {
    FARObjectWrapper *wrapper = params[@"clickListener"];
    wrapper callWithParams:@{@"sender": sender}];
 }
```

### you can see ```internalScript.far``` and find more usage 