# Swift Bitcoin Benchmarks

Performance benchmarks for the [Swift Bitcoin](https://github.com/swift-bitcoin/swift-bitcoin) project using Ordo One's [Benchmark](https://github.com/ordo-one/package-benchmark) package.

It is a separate package so the library has no benchmark dependencies.

## Benchmark Targets

Each library product from Swift Bitcoin gets their own benchmark target.

Since this package uses Swift Bitcoin as a dependency, only the modules' public API may be tested.

## Run Benchmarks

First make sure you have installed the external prerequisites. For more on this please refer to the Benchmark [installation](https://swiftpackageindex.com/ordo-one/package-benchmark/1.29.6/documentation/benchmark/gettingstarted) instructions.

On Linux, install `jemalloc` or set `BENCHMARK_DISABLE_JEMALLOC=true`.

After that run simply `swift package benchmark`

Other running commands:

```
swift package benchmark                        # run everything
swift package benchmark list                   # list benchmarks
swift package benchmark baseline update main   # save a baseline
swift package benchmark baseline check main    # compare against it
```


A table with results should appear on the terminal output.

## Documentation

The documentation for this project is integrated into Swift Bitcoin's documentation. In particular refer to the [Benchmarks](https://swiftbitcoin.org/docs/documentation/bitcoin/benchmarks) guide for more information.

## RIPEMD-160 benchmarks

- RIPEMD160 one-shot at 32 B, 64 B, 1 KiB, 64 KiB, 1 MiB and 16 MiB, each next to a `SHA256` baseline
- RIPEMD160 incremental hashing of 1 MiB in 100-byte chunks
- Bitcoin HASH160 (`RIPEMD160(SHA256(x))`) of a 33-byte public key

Each reports wall clock, throughput and malloc count.

## SipHash benchmarks

- SipHash-2-4 one-shot at 8 B, 32 B, 64 B, 1 KiB, 64 KiB and 1 MiB
- SHA-256 baselines at 32 B, 1 KiB and 1 MiB
- Incremental hashing of 1 MiB in 100-byte chunks
- A BIP152-style short ID (32-byte txid, 48-bit result)

Each reports wall clock, throughput and malloc count. Results for very short inputs sit near the timer's resolution (about 42 ns), so treat them as coarse.
