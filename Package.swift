// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ChibiSAT",
    products: [
        .executable(name: "chibi-sat", targets: ["chibi-sat"]),
        .library(name: "ChibiSAT", targets: ["ChibiSAT"]),
    ],
    targets: [
        .executableTarget(name: "chibi-sat", dependencies: ["ChibiSAT"]),
        .target(name: "ChibiSAT", dependencies: []),
        .testTarget(
            name: "ChibiSATTests",
            dependencies: ["ChibiSAT"],
            exclude: ["Fixtures"]),
    ]
)
