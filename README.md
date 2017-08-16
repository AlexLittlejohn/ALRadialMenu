# ALRadialMenu
A radial/circular menu featuring spring animations. Written in swift.  
Experimenting with fluent interfaces (https://github.com/vandadnp/swift-weekly/blob/master/issue05/README.md)

![Screen](https://cloud.githubusercontent.com/assets/932822/7349115/18865370-ecf7-11e4-839d-ad8c225c2283.png)

## Installing

This package is only intended for use with Carthage. The original framework for Cocoapods can be found on the Cocoapods repo by searching `ALRadialMenu`

### Carthage

Add the following line to your Cartfile
`github "DanBurkhardt/ALRadialMenu"`

run carthage update

### Usage

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    let gesture = UITapGestureRecognizer(target: self, action: "showMenu:")
    view.addGestureRecognizer(gesture)
}

func showMenu(sender: UITapGestureRecognizer) {

	var buttons = [ALRadialMenuButton]()

	...
	/// create buttons
	...

    ALRadialMenu()
        .setButtons(buttons)
        .setAnimationOrigin(sender.locationInView(view))
        .presentInView(view)
}
```

## License
ALRadialMenu is available under the MIT license. See the LICENSE file for more info.
