// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ChibiSATBenchmark",
    dependencies: [
        .package(url: "https://github.com/google/swift-benchmark", from: "0.1.0"),
        .package(name: "ChibiSAT", path: "../"),
    ],
    targets: [
        .executableTarget(name: "ChibiSATBenchmark", dependencies: [
            .product(name: "ChibiSAT", package: "ChibiSAT"),
            .product(name: "Benchmark", package: "swift-benchmark"),
        ]),
    ]
)
