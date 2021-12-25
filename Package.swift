// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "NumberParser",
	platforms: [
		.macOS(.v10_10),
		.iOS(.v9),
		.tvOS(.v9),
		.watchOS(.v2)
	],
    products: [
        .library(name: "NumberParser", targets: ["NumberParser"]),
    ],
    targets: [
        .target(name: "NumberParser", dependencies: []),
        .testTarget(name: "NumberParserTests", dependencies: ["NumberParser"]),
    ]
)
