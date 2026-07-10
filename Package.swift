// swift-tools-version: 6.3.3
import PackageDescription

let package = Package(
    name: "swift-bitcoin-bench",
    platforms: [.macOS(.v26)],
    dependencies: [
        .package(url: "https://github.com/swift-bitcoin/swift-bitcoin", from: "0.1.0"),
        .package(url: "https://github.com/ordo-one/benchmark", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "BitcoinBenchmark",
            dependencies: [
                .product(name: "Benchmark", package: "benchmark"),
                .product(name: "Bitcoin", package: "swift-bitcoin")
            ],
            path: "Benchmarks/Bitcoin",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "benchmark")
            ]
        ),
        .executableTarget(
            name: "CryptoBenchmark",
            dependencies: [
                .product(name: "Benchmark", package: "benchmark"),
                .product(name: "BitcoinCrypto", package: "swift-bitcoin")
            ],
            path: "Benchmarks/Crypto",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "benchmark")
            ]
        )
    ]
)
