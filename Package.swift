// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "simulator-swift",
  platforms: [
    .macOS(.v13)
  ],
  dependencies: [
    .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.8.1")),
    .package(url: "https://github.com/pvieito/PythonKit.git", branch: "master"),
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
    .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0"))
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "simulator-swift",
      dependencies: [
        .product(name: "PythonKit", package: "PythonKit"),
        .product(name: "Algorithms", package: "swift-algorithms"),
        .product(name: "CryptoSwift", package: "CryptoSwift"),
        .product(name: "Rainbow", package: "Rainbow")
      ]
    )
  ]
)
