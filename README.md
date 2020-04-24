# FMPFeedbackForm

FMPFeedbackForm is an Objective-C framework that lets you add a simple yet effective feedback form to your macOS project.

![FMPFeedbackForm](https://github.com/MacPaw/FMPFeedbackForm/blob/master/Screenshots/1.png?raw=true)

## Features

### Out of the box Zendesk support
If you work with Zendesk you'll get the form up an running with only 10-ish lines of code. You may as well adapt the form to 
send feedback to any other service by providing your own implementation of a certain data sender object without much hassle.

### System profile report
The form's UI includes a checkbox which allows the user to attach a text file to his support request 
which contains anonymous information about the user's machine. This report includes a list of software and hardware specs,
recent console logs and preferences (NSUserDefaults) of your application.

### Customizable UI
If the default look of the form doesn't quite suit your needs, you may easily customize any text, 
field value or placeholder using a handy interface.

### Localized into 12 languages
<table>
<tr>
<td width="200">
<ul>
<li>🇨🇳Chinese</li>
<li>🇳🇱Dutch</li>
<li>🇫🇷French</li>
<li>🇩🇪German</li>
<li>🇮🇹Italian</li>
<li>🇯🇵Japanese</li>
</ul>
</td>
<td width="200">
<ul>
<li>🇰🇷Korean</li>
<li>🇵🇱Polish</li>
<li>🇧🇷Portuguese</li>
<li>🇷🇺Russian</li>
<li>🇪🇸Spanish</li>
<li>🇺🇦Ukrainian</li>
</ul>
</td>
</tr>
</table>

## Requirements

FMPFeedbackForm requires macOS 10.12 or later.

## Installation

### CocoaPods
FMPFeedbackForm is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:
```ruby
pod 'FMPFeedbackForm'
```

### Carthage
FMPFeedbackForm is available through [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:
```ruby
github "MacPaw/FMPFeedbackForm"
```

### Manual
Clone this repository (or add it as a submodule) and drag the `FMPFeedbackForm.xcodedeproj` into your project in Xcode. 
Then go to your target's General settings tab and add the `FMPFeedbackForm.framework`
to the "Frameworks, Libraries, and Embedded Content" list.

See `FMPDemoApp` project for an example of this method.

![Add framework manually](https://github.com/MacPaw/FMPFeedbackForm/blob/master/Screenshots/2.png?raw=true)

## Usage
### Initializing FMPFeedbackController
`FMPFeedbackController` is an `NSWindowController` subclass which handles your form's window presentation.
It also provides a practical public interface with all the necessary tools for you to customize and handle the form's work. 

In order to initialize the controller you'll need an object that conforms to `FMPFeedbackSender` protocol. 
It has a self-described name — this object should be able to send the data gathered by the form and report on its success/failure.
If you are working with Zendesk then you may use an already implemented `FMPZendeskFeedbackSender` class, use your project's 
credentials to instantiate an object of this type and then pass it to the controller's initializer.

```swift
// Hold a reference to the controller object somewhere, otherwise it'll get deallocated
var feedbackController: FMPFeedbackController?

// User wants to display the feedback form
@IBAction func provideFeedbackButtonClick(_ sender: Any) {
    // Instantiate an FMPFeedbackSender object
    let zendeskSender = FMPZendeskFeedbackSender(zendeskSubdomain: "subdomain", // (1)
                                                 authToken: "sometoken",        // (2)
                                                 productName: "My App")         // (3)
    
    // Create the controller
    feedbackController = FMPFeedbackController(feedbackSender: zendeskSender)
    // Present the form
    feedbackController?.showWindow(self)
}
```

That's it, you've just displayed a basic form that'll send feedback to your project on Zendesk!

<p align="center">
<img src="https://github.com/MacPaw/FMPFeedbackForm/blob/master/Screenshots/3.png?raw=true" height="600"/>
</p>

For clarity, let's break down the credentials that you pass on `FMPZendeskFeedbackSender` init:
1) This is the subdomain of your Zendesk project — the `subdomain` in `https://subdomain.zendesk.com`.
2) The API token that you generate in the Zendesk admin panel. 
For more info on where to get one please refer to the [Zendesk Support API](https://developer.zendesk.com/rest_api/docs/support/introduction#api-token) doc.
3) Your product or app name, it is used as a prefix in support ticket's subject, e.g. `[My App] Bug Report`.

In case you want to send feedback somewhere else, you'll have to provide your own implementation of the `FMPFeedbackSender` object.
You may look up the `FMPZendeskFeedbackSender.m` file to get the basic idea of what's going on.

### UI Customization

The way the form looks is defined by the controller's `settings` property which is represented by an `FMPInterfaceSettings` object.
It contains all the strings used in the form's UI and you may also specify an icon to display in the form's top left corner.

There are two ways to change the form's settings:

```swift
    // Pass an updated settings object to the controller's initializer:
    let settings = FMPInterfaceSettings.default
    settings.title = "My App feedback"
    settings.subtitle = "We'd love to know what you think of our product."
    settings.subjectOptions = ["Feedback", "Bug Report", "Support Request"]
    if let iconResource = NSImage(contentsOf: "path/to/icon.png") {
        settings.icon = iconResource
        settings.iconSize = NSSize(width: 64, height: 64) // default value
    }
    
    feedbackController = FMPFeedbackController(feedbackSender: sender, settings: settings)
    
    ...
    
    // Or update the controller's settings after init:
    feedbackController?.settings.title = "My App feedback"
    feedbackController?.settings.subtitle = "We'd love to know what you think of our product."
    feedbackController?.settings.subjectOptions = ["Feedback", "Bug Report", "Support Request"]
    if let iconResource = NSImage(contentsOf: "path/to/icon.png") {
        feedbackController?.settings.icon = iconResource
        feedbackController?.settings.iconSize = NSSize(width: 64, height: 64) // default value
    }
```

You may also specify the user's name and email to simplify filling out the form:

```swift
    feedbackController?.settings.defaultName = "John Doe"
    feedbackController?.settings.defaultEmail = "john.doe@gmail.com"
```

### Behaviour on submission

You may change the way the form behaves after successfull/failed feedback submission.  
By default `FMPFeedbackController` handles these events gracefully by showing a localized alert and closing the form's window on success,
or by presenting an error sheet over the form's window in case of error.

![Defaut behaviour](https://github.com/MacPaw/FMPFeedbackForm/blob/master/Screenshots/5.png?raw=true)

You can turn this off by setting these properties to `false`:
```swift
    feedbackController?.showsGenericSuccessAlert = false
    feedbackController?.showsGenericErrorSheet = false
```

You may also handle these events yourself by setting a `onDidSendFeedback` completion (executes after the default behaviour 
if it hasn't been turned off):
```swift
    feedbackController?.onDidSendFeedback = { [weak self] error in
        guard let error = error else {
            // Error is nil, display your custom success message
            self?.showSuccessMessage()
            self?.feedbackController?.close()
            return
        }
        
        // Error is not nil, submission failed, display error
        self?.showErrorMessage(with: error)
    }
```

### System profile report
`FMPFeedbackForm` gathers data for system profile report _almost_ without any of your input, yet to achieve better quality 
of gathered data you may need to specify two things.

The console logs of your application are collected using the Apple System Log API, which doesn't always provide all of the
needed data and mostly gathers system errors related to your application. If you use `CocoaLumberjack` or some other tool
to write logs to separate text files you may specify them to the feedback controller and their contents will be included 
in the report:

```swift
    feedbackController?.logURLs = [URL(fileURLWithPath: "path/to/file.log"),
                                   URL(fileURLWithPath: "path/to/otherFile.txt")]
```

You may also want to specify your custom `NSUserDefaults` domain (or suite name) in case you use something different from your
app's bundle ID:

```swift
    feedbackController?.userDefaultsDomain = "com.MyCompany.MyAppsNonDefaultDomain"
```

## Demo app

Most of the logic described above is conveniently implemented in the demo app available in this repository. 
Please refer to it for a more detailed look on how to use the feedback form.

![Demo app](https://github.com/MacPaw/FMPFeedbackForm/blob/master/Screenshots/4.png?raw=true)

## License

FMPFeedbackForm is available under the MIT license.

See the [LICENSE](/LICENSE) file for more info.
