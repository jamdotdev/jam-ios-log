# JamLog

This framework lets you send log events to [Jam for iOS](https://apps.apple.com/us/app/jam-fix-bugs-faster/id6469037234) so that they can be associated with your [Jam](https://jam.dev).

## Supported Platforms

- iOS 17.0+

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
