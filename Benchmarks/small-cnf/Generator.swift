import Foundation
func generateCNF(numberOf: (variables: Int, clauses: Int)) -> [[Int]] {
    return (0..<numberOf.clauses).map { _ in
        let length = Int.random(in: 1..<numberOf.variables)
        return (0..<length).map { _ in
            let id = Int.random(in: 1...numberOf.variables)
            return Bool.random() ? id : -id
        } + [0]
    }
}

func generateDIMACS(numberOfVariables: Int) -> String {
    let numberOf = (
        variables: numberOfVariables,
        clauses: 25
    )
    let cnf = generateCNF(numberOf: numberOf)

    return """
p cnf \(numberOf.variables) \(numberOf.clauses)
\(cnf.map { $0.map(\.description).joined(separator: " ") }.joined(separator: "\n"))
"""
}

for i in 2..<30 {
    let content = generateDIMACS(numberOfVariables: i)
    try content.write(toFile: "small-cnf-\(i).cnf", atomically: true, encoding: .utf8)
}
