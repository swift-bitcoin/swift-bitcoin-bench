import Benchmark
import Bitcoin

let benchmarks: @Sendable () -> Void = {
    Benchmark("Transaction signer") { benchmark in
        for _ in benchmark.scaledIterations {
            let secretKey = SecretKey()
            let pubkey = secretKey.pubkey
            let coinbaseTx = Transaction(
                ins: [.init(outpoint: .coinbase)],
                outs: [.init(value: 1, script: .payToPubkeyHash(pubkey))])
            let tx = Transaction(
                ins: [.init(outpoint: coinbaseTx.outpoint(0))],
                outs: [.init(value: 1, script: .payToPubkeyHash(pubkey))])
            var signer = TransactionSigner(tx: tx, prevouts: coinbaseTx.outs)
            signer.sign(input: 0, with: secretKey)
            // let signedTx = signer.tx
        }
    }
}
