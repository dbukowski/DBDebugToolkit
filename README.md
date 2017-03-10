# DBDebugToolkit

[![CI Status](http://img.shields.io/travis/dbukowski/DBDebugToolkit.svg?style=flat)](https://travis-ci.org/dbukowski/DBDebugToolkit)
[![Version](https://img.shields.io/cocoapods/v/DBDebugToolkit.svg?style=flat)](http://cocoapods.org/pods/DBDebugToolkit)
[![License](https://img.shields.io/cocoapods/l/DBDebugToolkit.svg?style=flat)](http://cocoapods.org/pods/DBDebugToolkit)
[![Platform](https://img.shields.io/cocoapods/p/DBDebugToolkit.svg?style=flat)](http://cocoapods.org/pods/DBDebugToolkit)
[![Twitter: @darekbukowski](https://img.shields.io/badge/contact-@darekbukowski-blue.svg?style=flat)](https://twitter.com/darekbukowski)

DBDebugToolkit is a debugging library written in Objective-C. It is meant to provide as many easily accessible tools as possible while keeping the integration process seamless.

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
- [x] User interface
  - [x] Showing all view frames
  - [x] Slowing down animations
  - [x] Showing touches on screen (useful for recording and screen sharing)
  - [x] Autolayout trace
  - [x] Current view description
  - [x] View controllers hierarchy
  - [x] List of available fonts
- [x] Network
  - [x] List of all the requests sent by the application
  - [x] Request and response preview
- [x] Resources
  - [x] File system: browsing and removing selected files
  - [x] User defaults: browsing, removing selected item and clearing all the data
  - [x] Keychain: browsing, removing selected item and clearing all the data
  - [x] Core Data: browsing all the managed objects and their relationships with sorting and filtering options
  - [x] Cookies: browsing, removing selected cookie and clearing all the data
- [x] Console
  - [x] Displaying console output in text view
  - [x] Sending console output by email with device and system information
- [x] Simulating location
- [x] Adding custom actions to the menu
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

### User interface

DBDebugToolkit provides many useful tools for UI debugging:

* Showing view frames
[//]: # (Insert view frames gif)
* Slow animations
[//]: # (Insert slow animations gif)
* Showing touches (for screen sharing and recording)
[//]: # (Insert showing touches gif)
If your device supports 3D Touch, the touch indicator view's alpha value will depend on the touch force.
* Various debug logs
[//]: # (Insert images with 4 logs)

### Network

In the network submenu you can find a list of all the requests send by your application during the current launch. There is also a search bar that allows you to filter the requests.

[//]: # (Insert requests list gif)

Tap on any request on the list to see its details. From the request details screen you can also access the request and response body preview, that handles image, text and JSON data.

[//]: # (Insert request details gif)

The request and response body data is saved to the files to minimize the memory usage caused by the requests logging. If it happens to be too big anyway, you can disable the logging in the network submenu.

### Resources

DBDebugToolkit allows you to browse and manage five data sources: file system, user defaults, keychain, Core Data and cookies.

#### File system

Browsing file system is really straightforward. You start in your application's directory. On top of the screen you see the label with the current path. Below are the directory contents: subdirectories and files. You can select a subdirectory to move deeper in the file system hierarchy. You can swipe a file cell to delete the file (but only if you have the needed permissions). You can also see the size of every file next to their names.

[//]: # (Insert file system gif)

#### User defaults and keychain

Browsing the user defaults and the keychain is very similar. For both of those data sources you can see a list of all the stored key-value pairs. Every pair can be removed by swiping the cell left and tapping the delete button. On the right of the navigation bar there is also a clear button that allows you to remove all the values stored in the currently browsed data source.

[//]: # (Insert user defaults gif next to keychain gif)

Apart from that, DBDebugToolkit provides the methods that allow you to clear the user defaults or the keychain programmatically:

```swift
import DBDebugToolkit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    DBDebugToolkit.clearKeychain()
    DBDebugToolkit.clearUserDefaults()
    return true
}
```

#### Core Data

DBDebugToolkit allows you to see all the objects stored in Core Data. Thanks to displaying related objects and filtering and sorting options it should be really helpful if your application uses Core Data. First, if your application uses more instances of `NSPersistentStoreCoordinator` class, you will see a list where you will need to choose one of them. This step is omitted when your application uses only one such an instance. The next screen allows you to choose one of the entities. Select an entity to see the list of all its instances:

[//]: # (Insert entity to list gif)

It's difficult to see all the managed object's attributes in a table view cell, so you can tap one of them to present a new view with all the details about the selected managed object. In the first section you can see all the attributes and their values. The second section has all the relationships. You can tap any of them to see the related objects.
In case of to-one relationships you will be redirected to the same view, but this time it will display the details of the related object:

[//]: # (Insert list to one to to-one relationship gif)

In case of to-many relationship you will see a view with a list of the related objects:

[//]: # (Insert details to to-many relationship gif)

On top of the view presenting the managed objects list you can see a filter button that allows you to filter the objects by their attributes and sort the results.

[//]: # (Insert list to filtering and sorting back to list gif)

#### Cookies

Browsing cookies is similar to browsing user defaults and keychain, but this time the stored data are not key-value pairs anymore. First screen displays the list of all the cookies, but only the most important data are shown: names and domains of the cookies. You can select a cookie cell to see its details on a new view. You can delete one cookie by swiping left on its cell and tapping delete button or by opening the details screen and using the navigation bar button. You can also clear all the cookies by using the clear button on the right of the navigation bar in the cookies list view.

[//]: # (Insert cookies with deletion gif)

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

### Simulating location

Simulating location with DBDebugToolkit is really straightforward. You can either select a location from the predefined list (the same as on iOS simulator) or choose any point on a map. This choice is remembered even after you relaunch the application, which should be really helpful when you work on a feature that depends on the user location.

[//]: # (Insert location simulation gif)

### Custom actions

If you need an easy access to any action performed by your application, you can use the custom actions feature of DBDebugToolkit. After the setup you can add as many custom actions as you like:

```swift
import DBDebugToolkit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    DBDebugToolkit.setup()
    let sendReportAction = DBCustomAction(name: "Send report") {
        // Your code responsible for sending the report.
    }
    let clearDatabaseAction = DBCustomAction(name: "Clear database") {
        // Your code responsible for clearing the database.
    }
    DBDebugToolkit.add([sendReportAction, clearDatabaseAction])
    return true
}
```

To run these actions simply open the menu and go to custom actions section. You will see the list of all the actions. Tap on any of them to perform it.

[//]: # (Insert menu -> tapping on those actions gif)

## Author

Dariusz Bukowski, dariusz.m.bukowski@gmail.com

## License

DBDebugToolkit is available under the MIT license. See the LICENSE file for more info.
