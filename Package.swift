// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DVPageContainer",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DVPageContainer",
            targets: ["DVPageContainer"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/layoutBox/PinLayout",
            .upToNextMajor(from: "1.9.3")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DVPageContainer",
            dependencies: [])
    ]
)
