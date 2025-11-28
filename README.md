# Swift Bitcoin Benchmarks

Benchmarks for the [Swift Bitcoin](https://github.com/swift-bitcoin/swift-bitcoin) project using Ordo One's [Benchmark](https://github.com/ordo-one/package-benchmark) package.

## Benchmark Targets

Each library product from Swift Bitcoin gets their own benchmark target.

Since this package uses Swift Bitcoin as a dependency, only the modules' public API may be tested.

## Run Benchmarks

First make sure you have installed the external prerequisites. For more on this please refer to the Benchmark [installation](https://swiftpackageindex.com/ordo-one/package-benchmark/1.29.6/documentation/benchmark/gettingstarted) instructions.

After that run simply `swift package benchmark`.

A table with results should appear on the terminal output.

## Documentation

The documentation for this project is integrated into Swift Bitcoin's documentation. In particular refer to the [Benchmarks](https://swiftbitcoin.org/docs/documentation/bitcoin/benchmarks) guide for more information.
