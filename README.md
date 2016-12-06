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

- [x] CPU usage (current, max, chart)
- [x] Memory usage (current, max, chart)
- [x] FPS (current, min, chart)
- [x] Widget displaying current CPU usage, memory usage and FPS that stays on top of the screen
- [x] Simulating memory warning
- [x] Showing version & build number

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
  [comment]: <> (insert cpu gif)
* Memory

   Includes current memory usage, max memory usage recorded and a chart displaying the memory usage over time. Additionally it has a "Simulate memory warning" option.
  [comment]: <> (insert memory gif)
* FPS

   Includes current FPS, min FPS recorded and a chart displaying the FPS value over time.
  [comment]: <> (insert fps gif)

#### Widget

On top of the performance submenu you can see a switch that enables the widget displaying current CPU usage, memory usage and frames per second. The widget will stay on top of the screen and will refresh every one second. It can be moved around the screen with pan gesture.
Tapping on the widget opens the performance submenu with tapped section (CPU, memory or FPS).

[comment]: <> (insert widget gif)

#### Simulating memory warning

In the memory section you can also find the "Simulate memory warning" button. Use it to test if you handle the warning properly.

## Author

Dariusz Bukowski, dariusz.m.bukowski@gmail.com

## License

DBDebugToolkit is available under the MIT license. See the LICENSE file for more info.
