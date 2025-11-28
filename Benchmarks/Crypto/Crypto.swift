import Benchmark
import BitcoinCrypto

let benchmarks: @Sendable () -> Void = {
    Benchmark("Secret key") { benchmark in
        for _ in benchmark.scaledIterations {
            _ = SecretKey()
        }
    }
}
