fileprivate extension Clause {
    var trivialLiteral: Literal? {
        if let first = first, count == 1 {
            return first
        }
        return nil
    }

    /// - Returns: `true` if this clause can be removed
    mutating func assumeTrue(_ variable: Literal) -> Bool {
        if contains(variable) {
            return true
        }

        self = self.filter { $0 != variable.inverse }
        return false
    }
}

extension CNF {

    func assumingTrue(_ variable: Literal, solution: [Bool?]) -> (CNF, [Bool?]) {
        var copy = self
        var solution = solution
        copy.assumeTrue(variable, solution: &solution)
        return (copy, solution)
    }

    mutating func assumeTrue(_ variable: Literal, solution: inout [Bool?]) {
        var index = clauses.startIndex
        solution[variable.number - 1] = !variable.isNegative

        while index < clauses.endIndex {
            if clauses[index].assumeTrue(variable) {
                clauses.remove(at: index)
            } else {
                index = index.advanced(by: 1)
            }
        }
    }

    mutating func applyOneLiteralRule(solution: inout [Bool?]) {
        for clause in clauses {
            if let literal = clause.trivialLiteral {
                assumeTrue(literal, solution: &solution)
            }
        }
    }

    mutating func applyPureLiteralRule(solution: inout [Bool?]) {
        let allVariables = clauses.flatMap { $0 }
        let pureVariables = allVariables.filter {
            !allVariables.contains($0.inverse)
        }
        for variable in pureVariables {
            assumeTrue(variable, solution: &solution)
        }
    }
}

func runDPLL(cnf: inout CNF, solution: inout [Bool?]) -> Bool {
    cnf.applyOneLiteralRule(solution: &solution)
    cnf.applyPureLiteralRule(solution: &solution)

    if cnf.clauses.isEmpty {
        return true
    }

    if cnf.clauses.contains(where: \.isEmpty) {
        return false
    }

    let selectedVariable = cnf.clauses.first!.first!
    var (trial0, solution0) = cnf.assumingTrue(selectedVariable, solution: solution)
    if runDPLL(cnf: &trial0, solution: &solution0) {
        solution = solution0
        return true
    }

    var (trial1, solution1) = cnf.assumingTrue(selectedVariable.inverse, solution: solution)
    if runDPLL(cnf: &trial1, solution: &solution1) {
        solution = solution1
        return true
    }
    return false
}
