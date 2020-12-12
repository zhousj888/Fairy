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


## 语法
### [基本语法](./grammarDoc.md)

### [框架接口](./frameworkDoc.md)


## 关于Fairy

Fairy的定位是一门轻量级的UI脚本语言，一个专门用来写UI的语言，语法主要借鉴SwiftUI。
原本是想做成一个跨平台的UI脚本语言，但是目前时间有限，只开发了iOS上的虚拟机，所以目前相当于是SwiftUI的兼容实现。
以后有时间的话还会增加Android和JavaScript的虚拟机，理想状况是只需要一个Fairy脚本，就可以实现三端渲染。