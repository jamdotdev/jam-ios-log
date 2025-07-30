// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "JamLog",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "JamLog",
      targets: ["JamLog"]
    ),
  ],
  targets: [
    .target(
      name: "JamLog"
    ),
  ]
)
