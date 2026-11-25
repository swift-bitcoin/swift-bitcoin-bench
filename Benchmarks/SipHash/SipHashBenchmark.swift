import Benchmark
import Crypto
import BitcoinCrypto

private let k0: UInt64 = 0x0706_0504_0302_0100
private let k1: UInt64 = 0x0f0e_0d0c_0b0a_0908

/// Message sizes: one word, a BIP152 transaction ID (32 B), small, and bulk.
private let sizes: [(name: String, count: Int)] = [
    ("8 B", 8), ("32 B", 32), ("64 B", 64), ("1 KiB", 1 << 10), ("64 KiB", 1 << 16), ("1 MiB", 1 << 20),
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

        Benchmark("SipHash-2-4 one-shot \(name)") { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(SipHash.hash(bytes: input.span, k0: k0, k1: k1))
            }
        }
    }

    // Context: SHA-256 (hardware accelerated on Apple silicon) over a few of the same sizes.
    for (name, count) in sizes where [32, 1 << 10, 1 << 20].contains(count) {
        let input = [UInt8](repeating: 0x61, count: count)
        Benchmark("SHA256 one-shot \(name) (baseline)") { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(SHA256.hash(data: input))
            }
        }
    }

    // Incremental hashing in 100-byte chunks (exercises the pending-word buffer).
    let big = [UInt8](repeating: 0x61, count: 1 << 20)
    Benchmark("SipHash-2-4 incremental 1 MiB in 100 B chunks") { benchmark in
        for _ in benchmark.scaledIterations {
            var hasher = SipHash(k0: k0, k1: k1)
            var offset = 0
            while offset < big.count {
                let end = min(offset + 100, big.count)
                hasher.update(bytes: big.span.extracting(offset..<end))
                offset = end
            }
            blackHole(hasher.finalize())
        }
    }

    // BIP152 compact-block short ID: SipHash-2-4 of a 32-byte txid, truncated to 6 bytes.
    let txid = [UInt8](repeating: 0x5a, count: 32)
    Benchmark("BIP152 short ID (32 B txid, 48-bit)") { benchmark in
        for _ in benchmark.scaledIterations {
            let value = SipHash.hash(bytes: txid.span, k0: k0, k1: k1).value
            blackHole((value << 16) >> 16)
        }
    }
}
