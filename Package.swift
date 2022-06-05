// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Peregrine",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Peregrine",
            targets: ["Peregrine"]
        ),
    ],
    targets: [
        .target(
            name: "Peregrine",
            dependencies: []
        ),
        .testTarget(
            name: "PeregrineTests",
            dependencies: ["Peregrine"]
        ),
    ]
)
