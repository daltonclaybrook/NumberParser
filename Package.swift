// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "NumberParser",
    products: [
        .library(name: "NumberParser", targets: ["NumberParser"]),
    ],
    targets: [
        .target(name: "NumberParser", dependencies: []),
        .testTarget(name: "NumberParserTests", dependencies: ["NumberParser"]),
    ]
)
