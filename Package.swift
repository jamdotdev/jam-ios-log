// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "Jam",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "Jam",
      targets: ["Jam"]
    ),
  ],
  targets: [
    .target(
      name: "Jam"
    ),
  ]
)
