// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "NiceScale",
    products: [
        .library(name: "NiceScale", targets: ["NiceScale"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "NiceScale",
            dependencies: [
                .product(name: "Numerics", package: "swift-numerics"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "NiceScaleTests",
            dependencies: ["NiceScale"],
            path: "Tests"
        ),
    ]
)
