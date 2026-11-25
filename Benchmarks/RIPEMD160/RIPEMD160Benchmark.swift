import Benchmark
import Crypto
import BitcoinCrypto

/// Message sizes: a Bitcoin-style HASH160 input (33 B / 32 B), one block, small, and bulk.
private let sizes: [(name: String, count: Int)] = [
    ("32 B", 32), ("64 B", 64), ("1 KiB", 1 << 10), ("64 KiB", 1 << 16), ("1 MiB", 1 << 20), ("16 MiB", 1 << 24),
]

let benchmarks: @Sendable () -> Void = {
    Benchmark.defaultConfiguration = .init(
        metrics: [.wallClock, .throughput, .mallocCountTotal],
        warmupIterations: 3,
        scalingFactor: .one,
        maxDuration: .seconds(3),
        maxIterations: 100_000
    )

    for (name, count) in sizes {
        let input = [UInt8](repeating: 0x61, count: count)

        // One-shot over a Span.
        Benchmark("RIPEMD160 one-shot \(name)") { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(RIPEMD160.hash(bytes: input.span))
            }
        }

        // Baseline: SHA-256 (hardware accelerated on Apple silicon) over the same input.
        Benchmark("SHA256 one-shot \(name) (baseline)") { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(SHA256.hash(data: input))
            }
        }
    }

    // Incremental hashing in 100-byte chunks (exercises the partial-block buffer).
    let big = [UInt8](repeating: 0x61, count: 1 << 20)
    Benchmark("RIPEMD160 incremental 1 MiB in 100 B chunks") { benchmark in
        for _ in benchmark.scaledIterations {
            var hasher = RIPEMD160()
            var offset = 0
            while offset < big.count {
                let end = min(offset + 100, big.count)
                hasher.update(bytes: big.span.extracting(offset..<end))
                offset = end
            }
            blackHole(hasher.finalize())
        }
    }

    // Bitcoin HASH160 variants over a 33-byte compressed public key.
    let pubkey = [UInt8](repeating: 0x02, count: 33)

    Benchmark("HASH160 floor: SHA256 only, 33 B") { benchmark in
        for _ in benchmark.scaledIterations { blackHole(SHA256.hash(data: pubkey)) }
    }

    Benchmark("HASH160 A: SHA256, Array copy, RIPEMD160 (naive)") { benchmark in
        for _ in benchmark.scaledIterations {
            let sha = Array(SHA256.hash(data: pubkey))
            blackHole(RIPEMD160.hash(bytes: sha.span))
        }
    }

    Benchmark("HASH160 B: SHA256, unsafe pass-through, RIPEMD160") { benchmark in
        for _ in benchmark.scaledIterations {
            let digest = SHA256.hash(data: pubkey)
            blackHole(
                digest.withUnsafeBytes { raw in
                    RIPEMD160.hash(bytes: Span<UInt8>(_unsafeElements: raw.bindMemory(to: UInt8.self)))
                })
        }
    }

    Benchmark("HASH160 C: Hash160 type (safe, single-block fast path)") { benchmark in
        for _ in benchmark.scaledIterations { blackHole(Hash160.hash(data: pubkey)) }
    }
}
