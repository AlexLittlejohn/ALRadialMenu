# ALRadialMenu
A radial/circular menu featuring spring animations. Written in swift.  
An experiment with fluent interfaces (https://github.com/vandadnp/swift-weekly/blob/master/issue05/README.md)

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
