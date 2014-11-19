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
let screenScene = ScreenScene(mainViewControler: mainViewController)
self.screenSceneController?.pushScreenScene(screenScene, animated: true)
```

![ScreenSceneController](https://github.com/rshevchuk/ScreenSceneController/blob/master/preview.gif?raw=true)

### Attach
```swift
let accessoryViewController = UIViewController()
let accessoryAttachment = ScreenSceneAttachment(viewController: accessoryViewController)
accessoryAttachment.screenSceneAttachmentLayout.exclusiveFocus = true
mainViewController.screenScene?.attachAccessory(accessoryAttachment, animated: true)
```

### Detach
```swift
mainViewController.screenScene?.detachAccessory(animated: true)
```

## API

### ScreenSceneController
```swift
weak var delegate: ScreenSceneControllerDelegate?

var topViewController: ScreenSceneController.ScreenScene? { get }

var viewControllers: [ScreenSceneController.ScreenScene]
func setViewControllers(viewControllers: [AnyObject]!, animated: Bool)

func pushScreenScene(screenScene: ScreenSceneController.ScreenScene, animated: Bool)

func popViewControllerAnimated(animated: Bool) -> UIViewController?
func popToViewController(viewController: UIViewController, animated: Bool) -> [AnyObject]?
func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]?
}
```

### ScreenScene
```swift
weak var delegate: ScreenSceneDelegate?

init(mainScreenSceneAttachment: ScreenSceneController.ScreenSceneAttachment, accessoryScreenSceneAttachment: ScreenSceneController.ScreenSceneAttachment?)

convenience init(mainScreenSceneAttachment: ScreenSceneController.ScreenSceneAttachment)
convenience init(mainViewControler: UIViewController, accessoryViewControler: UIViewController?)
convenience init(mainViewControler: UIViewController)

func attachAccessory(accessoryScreenSceneAttachment: ScreenSceneController.ScreenSceneAttachment, animated: Bool)
func detachAccessory(#animated: Bool)
```

### ScreenSceneAttachment
```swift
init(viewController: UIViewController)

let screenSceneAttachmentLayout: ScreenSceneController.ScreenSceneAttachmentLayout
let viewController: UIViewController

```

### ScreenSceneAttachmentLayout
```swift
var exclusiveFocus: Bool

var portraitWidth: CGFloat
var landscapeWidth: CGFloat
var relative: Bool

var navigationBarHeight: CGFloat
var portraitInsets: UIEdgeInsets
var landscapeInsets: UIEdgeInsets

var allowInterpolatingEffect: Bool
var interpolatingEffectRelativeValue: Int

var shadowIntensity: CGFloat
var cornerRadius: CGFloat
```

### UIViewController
```swift
var screenSceneController: ScreenSceneController.ScreenSceneController? { get }
var screenScene: ScreenSceneController.ScreenScene? { get }
```

### ScreenSceneControllerDelegate
```swift
optional func screenSceneController(screenSceneController: ScreenSceneController.ScreenSceneController, willShowViewController viewController: UIViewController, animated: Bool)
optional func screenSceneController(screenSceneController: ScreenSceneController.ScreenSceneController, didShowViewController viewController: UIViewController, animated: Bool)
```

### ScreenSceneDelegate
```swift
optional func shouldBeginDetachAccessory(screenScene: ScreenSceneController.ScreenScene) -> Bool

optional func screenScene(screenScene: ScreenSceneController.ScreenScene, willAttachAccessory viewController: UIViewController, animated: Bool)
optional func screenScene(screenScene: ScreenSceneController.ScreenScene, didAttachAccessory viewController: UIViewController, animated: Bool)
optional func screenScene(screenScene: ScreenSceneController.ScreenScene, willDetachAccessory viewController: UIViewController, animated: Bool)
optional func screenScene(screenScene: ScreenSceneController.ScreenScene, didDetachAccessory viewController: UIViewController, animated: Bool)
```

### ScreenSceneSettings
```swift
class var defaultSettings: ScreenSceneController.ScreenSceneSettings { get }


var classesThatDisableScrolling: [(AnyClass)]
func addClassThatDisableScrolling(classThatDisableScrolling: AnyClass)

var navigationBarTitleTextAttributes: [String : AnyObject]

var bringFocusAnimationDuration: NSTimeInterval
var attachAnimationDamping: CGFloat
var attachAnimationDuration: NSTimeInterval
var detachAnimationDuration: NSTimeInterval

var detachCap: CGFloat

var attachmentExclusiveFocus: Bool

var attachmentPortraitWidth: CGFloat
var attachmentLandscapeWidth: CGFloat
var attachmentRelative: Bool

var attachmentNavigationBarHeight: CGFloat
var attachmentTopInset: CGFloat
var attachmentBottomInset: CGFloat
var attachmentMinLeftInset: CGFloat
var attachmentMinRightInset: CGFloat

var attachmentAllowInterpolatingEffect: Bool
var attachmentInterpolatingEffectRelativeValue: Int

var attachmentShadowIntensity: CGFloat
var attachmentCornerRadius: CGFloat
```

## License

ScreenSceneController is available under the MIT license. See the LICENSE file for more info.

