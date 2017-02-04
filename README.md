# DBDebugToolkit

[![CI Status](http://img.shields.io/travis/dbukowski/DBDebugToolkit.svg?style=flat)](https://travis-ci.org/dbukowski/DBDebugToolkit)
[![Version](https://img.shields.io/cocoapods/v/DBDebugToolkit.svg?style=flat)](http://cocoapods.org/pods/DBDebugToolkit)
[![License](https://img.shields.io/cocoapods/l/DBDebugToolkit.svg?style=flat)](http://cocoapods.org/pods/DBDebugToolkit)
[![Platform](https://img.shields.io/cocoapods/p/DBDebugToolkit.svg?style=flat)](http://cocoapods.org/pods/DBDebugToolkit)
[![Twitter: @darekbukowski](https://img.shields.io/badge/contact-@darekbukowski-blue.svg?style=flat)](https://twitter.com/darekbukowski)

DBDebugToolkit is a debugging library written in Objective-C.

- [Features](#features)
- [Example](#example)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Author](#author)
- [License](#license)

## Features

- [x] Performance
  - [x] CPU usage (current, max, chart)
  - [x] Memory usage (current, max, chart)
  - [x] FPS (current, min, chart)
  - [x] Widget displaying current CPU usage, memory usage and FPS that stays on top of the screen
  - [x] Simulating memory warning
- [x] Network
  - [x] List of all the requests sent by the application.
- [x] Console
  - [x] Displaying console output in text view
  - [x] Sending console output by email with device and system information
- [x] Opening application settings
- [x] Showing version & build number
- [x] Showing device model & iOS version

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. The example project is written in Objective-C. The Swift examples of using DBDebugToolkit are in this README.

## Requirements

DBDebugToolkit requires iOS 8.0 or later.

## Installation

DBDebugToolkit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DBDebugToolkit"
```

## Usage

### Setup

DBDebugToolkit was meant to provide as many useful debugging tools as possible. However, the second equally important goal was to keep the setup seamless for all the iOS projects. A good place for setting up DBDebugToolkit is in the `AppDelegate`:
[//]: # (Why is it a good place?)

```swift
import DBDebugToolkit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    DBDebugToolkit.setup()
    return true
}
```

#### Triggers

Triggers are the objects that tell DBDebugToolkit to present the menu. There are 3 predefined triggers:
- `DBShakeTrigger` - reacts to shaking the device.
- `DBTapTrigger` - reacts to tapping the screen.
- `DBLongPressTrigger` - reacts to long pressing the screen.

By default, DBDebugToolkit is set up with `DBShakeTrigger`. You can also provide your own array of triggers:

```swift
import DBDebugToolkit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let tapTrigger = DBTapTrigger(numberOfTouchesRequired: 3)
    let longPressTrigger = DBLongPressTrigger(minimumPressDuration: 1.0)
    let shakeTrigger = DBShakeTrigger()
    DBDebugToolkit.setup(with: [tapTrigger, longPressTrigger, shakeTrigger])
    return true
}
```

These are just examples. Both `DBTapTrigger` and `DBLongPressTrigger` have more customization options.

You can also create your own trigger. To do this, create a class that conforms to protocol `DBDebugToolkitTrigger`. Then create an instance of this class and pass it to the setup method.

### Performance

The first submenu is dedicated to measuring your application performance. You can find there statistics divided into three sections:

* CPU

   Includes current CPU usage, max CPU usage recorded and a chart displaying the CPU usage over time.
   [//]: # (Insert cpu gif)
* Memory

   Includes current memory usage, max memory usage recorded and a chart displaying the memory usage over time. Additionally it has a "Simulate memory warning" option.
   [//]: # (Insert memory gif)
* FPS

   Includes current FPS, min FPS recorded and a chart displaying the FPS value over time.
   [//]: # (Insert fps gif)

#### Widget

On top of the performance submenu you can see a switch that enables the widget displaying current CPU usage, memory usage and frames per second. The widget will stay on top of the screen and will refresh every one second. It can be moved around the screen with pan gesture.
Tapping on the widget opens the performance submenu with tapped section (CPU, memory or FPS).
[//]: # (Insert widget gif)

#### Simulating memory warning

In the memory section you can also find the "Simulate memory warning" button. Use it to check if you handle the warning properly.

### Network

In the network submenu you can find a list of all the requests send by your application during the current launch. There is also a search bar that allows you to filter the requests.

[//]: # (Insert requests list gif)

Tap on any request on the list to see its details. From the request details screen you can also access the request and response body preview, that handles image, text and JSON data.

[//]: # (Insert request details gif)

The request and response body data is saved to the files to minimize the memory usage caused by the requests logging. If it happens to be too big anyway, you can disable the logging in the network submenu.

### Console

DBDebugToolkit displays console output inside a UITextView. The text view will be automatically scrolled down to display the new output, unless you are currently reading older entries above.

[//]: # (Insert horizontal console updating gif)

The captured console output can be easily shared by email. The share button will open a mail compose view controller with prefilled subject containing build information and body containing device and system information and the console output.

[//]: # (Insert horizontal sharing gif)

**Warning!** Capturing both stderr and stdout is very complicated. Stderr and stdout could be both redirected to a file that would be displayed in the text view. However, that data should be redirected back to stderr and stdout, so that you could for example see it in the console. Unfortunately it would be impossible to distinguish which data came from stderr and which came from stdout, so everything would be redirected to one of them. DBDebugToolkit is meant to be noninvasive, so this solution was unacceptable. Instead, stdout and stderr are observed in the background. The only drawback is that if you would have a loop sending data alternately to stdout and stderr you could notice a slight change in the received data order. If for some reason it is not acceptable in your project you can disable console output capturing:

```swift
import DBDebugToolkit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    DBDebugToolkit.setup()
    DBDebugToolkit.setCapturingConsoleOutputEnabled(false)
    return true
}
```

## Author

Dariusz Bukowski, dariusz.m.bukowski@gmail.com

## License

DBDebugToolkit is available under the MIT license. See the LICENSE file for more info.
