# JamLog

This framework lets you send log events to [Jam for iOS](https://apps.apple.com/us/app/jam-fix-bugs-faster/id6469037234) so that they can be associated with your [Jam](https://jam.dev).

## Supported Platforms

- iOS 15.0+

## Quick Start

Add the following to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/jamdotdev/jam-ios-log.git", from: "1.0.0")
]
```

Alternatively, you can add the package [directly via Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

## Usage

```swift
import JamLog

JamLog.debug("Hello world!")
```

Also supports `info`, `warn`, and `error`.

## SwiftLog

You can integrate with [SwiftLog](https://github.com/apple/swift-log) by importing `JamSwiftLog` and bootstraping the logging system:

```swift
import JamSwiftLog
import Logging

LoggingSystem.bootstrap { label in
  JamLogHandler(label: label)
}
```

Alternatively, you can add JamLog to your existing logging system by using the `MultiplexLogHandler`. Assuming you are already using the `StreamLogHandler`:

```swift
import JamSwiftLog
import Logging

LoggingSystem.bootstrap { label in
  MultiplexLogHandler([
    StreamLogHandler.standardOutput(label: label),
    JamLogHandler(label: label)
  ])
}
```