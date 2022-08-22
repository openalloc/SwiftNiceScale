// swift-tools-version:5.3

// Copyright 2021, 2022 OpenAlloc LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import PackageDescription

let package = Package(
    name: "SwiftNiceScale",
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
