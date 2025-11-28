// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "swift-bitcoin-bench",
    platforms: [.macOS(.v26)],
    dependencies: [
        .package(url: "https://github.com/swift-bitcoin/swift-bitcoin", from: "0.1.4"),
        .package(url: "https://github.com/ordo-one/package-benchmark", from: "1.29.6"),
    ],
    targets: [
        .executableTarget(
            name: "BitcoinBenchmark",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                .product(name: "Bitcoin", package: "swift-bitcoin"),
            ],
            path: "Benchmarks/Bitcoin",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
        .executableTarget(
            name: "CryptoBenchmark",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                .product(name: "BitcoinCrypto", package: "swift-bitcoin")
            ],
            path: "Benchmarks/Crypto",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        )
    ]
)
