
# Basic grammar

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
  func run(){

  }
}

class Son: Father {
  var age
  func init() {
    //first call super.init, then call this
  }
}

var son = Son()
son.run()

```

## you can see ```internalScript.far``` and find more usage