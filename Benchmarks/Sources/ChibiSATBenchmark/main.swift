import Benchmark
import ChibiSAT
import Foundation

let benchmarkDir = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent() // ChibiSATBenchmarks
    .deletingLastPathComponent() // Sources
    .deletingLastPathComponent() // Benchmarks
    

for numberOfVariable in 2..<30 {
    let fileName = "small-cnf-\(numberOfVariable).cnf"
    let targetCNF = benchmarkDir
        .appendingPathComponent("small-cnf")
        .appendingPathComponent(fileName)
    benchmark(fileName) {
        let sourceContent = try String(contentsOf: targetCNF)
        let lines = sourceContent.split(whereSeparator: \.isNewline)
        var dimacs = DIMACS(source: lines.makeIterator())
        guard let cnf = try dimacs.nextCNF() else {
            fatalError("CNF not found in file")
        }
        _ = cnf.solve().makeIterator().next()
    }
}

Benchmark.main()
