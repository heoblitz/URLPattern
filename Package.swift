// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "URLPattern",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(
      name: "URLPattern",
      targets: ["URLPattern"]
    ),
    .executable(
      name: "URLPatternClient",
      targets: ["URLPatternClient"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax", "509.0.0"..<"603.0.0"),
  ],
  targets: [
    .macro(
      name: "URLPatternMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),
    .target(name: "URLPattern", dependencies: ["URLPatternMacros"]),
    .executableTarget(name: "URLPatternClient", dependencies: ["URLPattern"]),
    .testTarget(
      name: "URLPatternTests",
      dependencies: [
        "URLPatternMacros",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ]
)
