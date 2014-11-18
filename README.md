# ScreenSceneController

[![CI Status](http://img.shields.io/travis/rshevchuk/ScreenSceneController.svg?style=flat)](https://travis-ci.org/rshevchuk/ScreenSceneController)

ScreenSceneController is a specialized view controller that manages the navigation of hierarchical content. It was originally used in JetRadar and Aviasales apps.

## Requirements

- iOS 7.0+
- Xcode 6.1+

## Installation

ScreenSceneController is **not available** through [CocoaPods](http://cocoapods.org) because Swift Pods support is still being worked.

For this reason you should add ScreenSceneController's **\*.swift sources** to you project **manually**.

## Usage

```swift
let mainViewController = UIViewController()
let mainAttachmentLayout = ScreenSceneAttachmentLayout(width: 0.5, relative: true)
let mainAttachment = ScreenSceneAttachment(viewController: mainViewController, screenSceneAttachmentLayout: mainAttachmentLayout)
let screenScene = ScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: nil)
self.screenSceneController?.pushSceneScene(screenScene, animated: true)
```

![ScreenSceneController](https://github.com/rshevchuk/ScreenSceneController/blob/master/preview.gif?raw=true)

### Attach
```swift
let accessoryViewController = UIViewController()
let accessoryAttachmentLayout = ScreenSceneAttachmentLayout(width: 0.8, relative: true)
let accessoryAttachment = ScreenSceneAttachment(viewController: accessoryViewController, screenSceneAttachmentLayout: accessoryAttachmentLayout)
mainViewController.screenScene?.attachAccessory(accessoryAttachment, animated: true)
```

### Detach
```swift
mainViewController.screenScene?.detachAccessory(animated: true)
```

## API

### ScreenSceneController
```swift
func pushSceneScene(screenScene: ScreenSceneController.ScreenScene, animated: Bool)

func popViewControllerAnimated(animated: Bool) -> UIViewController?
func popToViewController(viewController: UIViewController, animated: Bool) -> [AnyObject]?
func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]?

var topViewController: ScreenSceneController.ScreenScene? { get }
var viewControllers: [ScreenSceneController.ScreenScene]

func setViewControllers(viewControllers: [AnyObject]!, animated: Bool)
}
```

### ScreenScene
```swift
var delegate: ScreenSceneDelegate?

init(mainScreenSceneAttachment: ScreenSceneController.ScreenSceneAttachment, accessoryScreenSceneAttachment: ScreenSceneController.ScreenSceneAttachment?)

func attachAccessory(accessoryScreenSceneAttachment: ScreenSceneController.ScreenSceneAttachment, animated: Bool)
func detachAccessory(#animated: Bool)
```

### ScreenSceneAttachment
```swift
init(viewController: UIViewController, screenSceneAttachmentLayout: ScreenSceneController.ScreenSceneAttachmentLayout)

let viewController: UIViewController
var screenSceneAttachmentLayout: ScreenSceneController.ScreenSceneAttachmentLayout
```

### ScreenSceneAttachmentLayout
```swift
init(portraitWidth: CGFloat, landscapeWidth: CGFloat, relative: Bool)
init(width: CGFloat, relative: Bool)

var allowInterpolatingEffect: Bool
var exclusiveFocus: Bool
var insets: UIEdgeInsets
var interpolatingEffectRelativeValue: Int
var landscapeWidth: CGFloat
var portraitWidth: CGFloat
var relative: Bool
var shadowIntensity: CGFloat
```

### UIViewController
```swift
var screenSceneController: ScreenSceneController.ScreenSceneController? { get }
var screenScene: ScreenSceneController.ScreenScene? { get }
```

### ScreenSceneContainerView
```swift
var classesThatDisableScrolling: [(AnyClass)]
```

### ScreenSceneControllerDelegate
```swift
optional func screenSceneController(screenSceneController: ScreenSceneController.ScreenSceneController, willShowViewController viewController: UIViewController, animated: Bool)
optional func screenSceneController(screenSceneController: ScreenSceneController.ScreenSceneController, didShowViewController viewController: UIViewController, animated: Bool)
```

### ScreenSceneDelegate
```swift
optional func screenScene(screenScene: ScreenSceneController.ScreenScene, willAttachAccessory viewController: UIViewController, animated: Bool)
optional func screenScene(screenScene: ScreenSceneController.ScreenScene, didAttachAccessory viewController: UIViewController, animated: Bool)
optional func screenScene(screenScene: ScreenSceneController.ScreenScene, willDetachAccessory viewController: UIViewController, animated: Bool)
optional func screenScene(screenScene: ScreenSceneController.ScreenScene, didDetachAccessory viewController: UIViewController, animated: Bool)
```


## License

ScreenSceneController is available under the MIT license. See the LICENSE file for more info.

