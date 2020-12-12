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

