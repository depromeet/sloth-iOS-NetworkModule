// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SlothNetworkModule",
    products: [
        .library(
            name: "SlothNetworkModule",
            targets: ["SlothNetworkModule"]),
    ],
    targets: [
        .target(
            name: "SlothNetworkModule",
            dependencies: []),
        .testTarget(
            name: "SlothNetworkModuleTests",
            dependencies: ["SlothNetworkModule"]),
    ]
)
