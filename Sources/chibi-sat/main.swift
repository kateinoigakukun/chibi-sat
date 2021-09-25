import ChibiSAT
import Darwin
import Foundation

let args = CommandLine.arguments

func printHelp() {
    fputs("""
Usage: \(args[0]) <input file>
""", stderr)
}

guard args.count >= 2 else {
    printHelp()
    exit(1)
}

let inputFile = CommandLine.arguments[1]
let sourceContent = try String(contentsOfFile: inputFile)
let lines = sourceContent.split(whereSeparator: \.isNewline)

var dimacs = DIMACS(source: lines.makeIterator())
guard let cnf = try dimacs.nextCNF() else {
    fputs("CNF not found in file", stderr)
    exit(1)
}
fputs(cnf.description + "\n", stderr)
if let solution = cnf.solve().makeIterator().next() {
    print("s SATISFIABLE")
    let solutionString = solution.enumerated().map { idx, positive in
        "\((idx + 1) * (positive ? 1 : -1))"
    }.joined(separator: " ")
    print("v \(solutionString)")
    exit(10)
} else {
    print("s UNSATISFIABLE")
    exit(20)
}
