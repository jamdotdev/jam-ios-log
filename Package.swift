// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "JamLog",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "JamLog",
      targets: ["JamLog"]
    ),
    .library(
      name: "JamSwiftLog",
      targets: ["JamSwiftLog"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
  ],
  targets: [
    .target(
      name: "JamLog"
    ),
    .target(
      name: "JamSwiftLog",
      dependencies: [
        "JamLog",
        .product(name: "Logging", package: "swift-log"),
      ]
    ),
  ]
)
